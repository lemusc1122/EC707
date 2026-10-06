% Parameters
clear all;
close all;
N = 40;             % Number of elements per side
spacing = 1;      % Spacing between dots (e.g., 0.5 lambda)

% 1. Generate the coordinate vectors
x = (0:N-1) * spacing;
y = (0:N-1) * spacing;

% 2. Create the 2D grid matrices
[X, Y] = meshgrid(x, y);

% 3. Visualization
figure('Color', 'w');
% We use (:) to flatten the matrices into vectors for the scatter plot
scatter(X(:), Y(:), 6, 'filled', 'MarkerFaceColor', [0.8500 0.3250 0.5]);

% Formatting
axis equal;         % Ensure the grid looks square
grid on;
title(['40 x 40 Array (', num2str(N^2), ' Elements)']);
xlabel('Column Element Position');
ylabel('Row Element Position');
xlim([-spacing, N*spacing]);
ylim([-spacing, N*spacing]);

% Optional: Set the figure to a square shape
set(gcf, 'Position', [100, 100, 600, 600]);