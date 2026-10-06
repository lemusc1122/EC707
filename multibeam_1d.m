%% Phased Array Beamforming Simulation
clear; clc; close all;

% --- Parameters ---
N = 40;                 % Number of elements in X (Azimuth)
M = 40;                 % Number of elements in Y (Elevation)
d = 0.5;                % Element spacing in wavelengths (lambda)
theta_res = 0.5;        % Resolution in degrees

% Beam Spacing (Adjust this to match your 7.5 or 15 degree requirement)
beam_spacing = 15;     
steer_angles = [0]; % 1 Beam
%steer_angles = [-beam_spacing, beam_spacing]; % 2 Beams
%steer_angles = [-beam_spacing, 0, beam_spacing]; % 3 Beams
%steer_angles = [-beam_spacing, 0, 0.7*beam_spacing, beam_spacing]; % 4 Beams
% --- Coordinate Grid ---
az = -45:theta_res:45;
el = -45:theta_res:45;
[AZ, EL] = meshgrid(az, el);

% Convert degrees to radians for calculation
AZ_rad = deg2rad(AZ);
EL_rad = deg2rad(EL);

% --- Array Factor Calculation ---
% Initialize AF matrix
AF = zeros(size(AZ));

% Loop through each desired beam and sum them
for theta_s = steer_angles
    phi_s = 0; % Elevation steering (kept at 0 for these plots)
    
    % Steering phase shifts
    u_s = sin(deg2rad(theta_s)) * cos(deg2rad(phi_s));
    v_s = sin(deg2rad(phi_s));
    
    % Calculate AF for a single beam
    % Simplified AF for rectangular planar array: AF = AFx * AFy
    psi_x = 2 * pi * d * (sin(AZ_rad) .* cos(EL_rad) - u_s);
    psi_y = 2 * pi * d * (sin(EL_rad) - v_s);
    
    AF_x = sin(N * psi_x / 2) ./ (N * sin(psi_x / 2));
    AF_y = sin(M * psi_y / 2) ./ (M * sin(psi_y / 2));
    
    % Handle singularities at steer point
    AF_x(isnan(AF_x)) = 1;
    AF_y(isnan(AF_y)) = 1;
    
    AF = AF + (AF_x .* AF_y);
end

% --- Normalization and Log Scale ---
AF_mag = abs(AF);
AF_norm = AF_mag / max(AF_mag(:));
AF_dB = 20 * log10(AF_norm);
AF_dB(AF_dB < -40) = -40; % Floor at -40dB to match your image

% --- Visualization ---
figure('Color', 'w', 'Position', [100, 100, 800, 600]);
surf(AZ, EL, AF_dB, 'EdgeColor', 'none');
colormap(jet);
colorbar;
view(-30, 45); % Adjust view angle to match your screenshot

% Formatting
xlabel('Azimuth (°)');
ylabel('Elevation (°)');
zlabel('Normalized Gain (dB)');
title(['Planar Array Pattern: ', num2str(beam_spacing), '° Spacing']);
grid on;
axis tight;