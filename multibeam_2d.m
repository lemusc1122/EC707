%% Phased Array 2x2 Beam Grid Simulation
clear; clc; close all;

% --- Array Configuration ---
N = 40;                 % Number of elements (Azimuth)
M = 40;                 % Number of elements (Elevation)
d = 0.5;                % Spacing (lambda)
theta_res = 0.5;        % Grid resolution

% --- 2x2 Beam Spacing ---
% This defines the offset from the center for each beam
az_spacing = 6;        
el_spacing = 20;

% Define the four coordinate pairs for the beams
%az_steer = [-az_spacing, az_spacing]; 
%el_steer = [-el_spacing, el_spacing];

% Combine into final steering vectors
%Trident
%az_steer = [-9,0,9];
%el_steer = [-9,0,9];
%broadened/spoiled
%az_steer = [-6,-3,0,3,6];
%el_steer = [0];
%less spoiled
%az_steer = [-12,-6,0,6,12];
%el_steer = [0];
%az_steer=0;
%el_steer=0;

% --- Coordinate Grid ---
az = -45:theta_res:45;
el = -45:theta_res:45;
[AZ, EL] = meshgrid(az, el);
AZ_rad = deg2rad(AZ);
EL_rad = deg2rad(EL);

% --- Array Factor Calculation ---
AF_total = zeros(size(AZ));

% Nested loops to create the 2x2 grid
for th_s = az_steer
    for ph_s = el_steer
        
        % Steering vectors in u-v space
        u_s = sin(deg2rad(th_s)) * cos(deg2rad(ph_s));
        v_s = sin(deg2rad(ph_s));
        
        % Calculate Phase terms
        % Note: We use the full planar steering equation here
        psi_x = 2 * pi * d * (sin(AZ_rad) .* cos(EL_rad) - u_s);
        psi_y = 2 * pi * d * (sin(EL_rad) - v_s);
        
        % Dirichlet Kernel (Sinc-like response)
        AF_x = sin(N * psi_x / 2) ./ (N * sin(psi_x / 2));
        AF_y = sin(M * psi_y / 2) ./ (M * sin(psi_y / 2));
        
        % Clean up NaNs at the exact steering center
        AF_x(isnan(AF_x)) = 1;
        AF_y(isnan(AF_y)) = 1;
        
        % Accumulate the beams
        AF_total = AF_total + (AF_x .* AF_y);
    end
end

% --- Processing and Log Scale ---
AF_mag = abs(AF_total);
AF_norm = AF_mag / max(AF_mag(:));
AF_dB = 20 * log10(AF_norm);
AF_dB(AF_dB < -30) = -30; % Clip floor for better visualization

% --- Visualization ---
figure('Color', 'w');
surf(AZ, EL, AF_dB, 'EdgeColor', 'none');
colormap(jet);
h = colorbar;
ylabel(h, 'Normalized Gain (dB)');
view(0, 90); % Top-down view to clearly see the 2x2 grid
view(-35, 45); % Uncomment this for 3D perspective like your original images

xlabel('Azimuth (°)');
ylabel('Elevation (°)');
title(['1x5 Beam Grid (\pm', num2str(az_spacing), '° Offset)']);
axis tight;
grid on;