% Parameters for a 40x8 Phased Array Grid
clear all;
close all;
Nx = 40;            % Number of elements in X (columns)
Ny = 8;             % Number of elements in Y (rows)
dx = 1;           % Spacing in X (wavelengths)
dy = 1;           % Spacing in Y (wavelengths)

% 1. Generate the coordinate vectors
x_coords = (0:Nx-1) * dx;
y_coords = (0:Ny-1) * dy;

% 2. Create the 2D grid matrices
[X, Y] = meshgrid(x_coords, y_coords);

% 3. Visualization
figure('Color', 'w');
% Flatten matrices to vectors for scatter plotting
scatter(X(:), Y(:), 12, 'filled', 'MarkerFaceColor', [0.8500 0.3250 0.5]);

% Formatting
axis equal; % Important to see the true aspect ratio
grid on;
title(['40 x 8 Array (', num2str(Nx*Ny), ' Elements)']);
xlabel('Column Element Position');
ylabel('Row Element Position');

% Adjust view to show the elongated shape of the 40x8 array
xlim([-dx, Nx*dx]);
ylim([-dy, Ny*dy]);

% Set figure size to match the rectangular aspect ratio
set(gcf, 'Position', [100, 100, 1000, 300]);