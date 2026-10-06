%COURSE: ENG EC707 RADAR REMOTE SENSING
%PROF. : JOSHUA SEMETER
%AUTHOR: CHRISTOPHER LEMUS
%YEAR  : 2026 - SPRING
%HW #  : Final Project
%DUE   : April 23 2026 

% N x M Phased Array Antenna 3D Power Pattern (dB)
clear;
close all;

% --- Parameters ---
N = 100; M = 100;      % Array elements
d = 0.5;            % Element Spacing (lambda)
theta_steer = 20;   % Steering Angle (Elevation, deg)
phi_steer = 30;     % Steering Angle (Azimuth, deg)

% Create observation grid
psi = linspace(0, pi, 180);       % Elevation
phi = linspace(0, 2*pi, 360);       % Azimuth
[PHI, PSI] = meshgrid(phi, psi);

% Sum
factors = zeros(size(PSI));
for n =  0:N-1
    for m =  0:M-1
        % Phase contribution for element (n,m)
        psi = n * (2*pi*d*sin(PSI).*cos(PHI) ) + ...
              m * (2*pi*d*sin(PSI).*sin(PHI) );
        factors = factors + exp(1i * psi);
    end
end

% Power Pattern
F = abs(factors).^2;
F = F / max(F(:)); 
F_dB = 10 * log10(F + 1e-6); 

% --- 3D Visualization ---
% Convert to Cartesian for 3D plotting. 
% We scale the radius to a linear range based on dB: 
% 0 dB -> max radius, -40 dB -> 0 radius.
R_dB_scaled = (F_dB + 40) / 40; % Maps [-40, 0] to [0, 1]
R_dB_scaled(R_dB_scaled < 0) = 0;   % Threshold any value below -40 dB

X = R_dB_scaled .* sin(PSI) .* cos(PHI);
Y = R_dB_scaled .* sin(PSI) .* sin(PHI);
Z = R_dB_scaled .* cos(PSI);

% Plot as a 3D mesh surface
figure('Color', 'w');
surf(X, Y, Z, F_dB); % Color by original dB value
shading interp; 
colormap('jet'); 
colorbar;
view(45, 30); 
axis equal; 
grid on;
title(['3D Power Pattern: 100 x 100 Array Pattern (10000 Elements)']);
zlim([0 1.1]); % Set z-axis limit to show the lobe clearly
zlabel('Scaled Power (dB)');
xlabel('Elevation')
ylabel('Azimuth')

figure('Color', 'w');
pcolor(X, Y, F_dB);
shading interp; colormap('jet');
colorbar; 
clim([-40 0]); % 40dB dynamic range
axis square; 
grid on;
title(['40 x 40 Array Pattern (1600 Elements)']);
ylabel('u = sin(\theta)cos(\phi)'); 
xlabel('v = sin(\theta)sin(\phi)');

