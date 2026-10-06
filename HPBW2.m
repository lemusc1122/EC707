% Parameters
N = 100;                 % Number of elements in X (Elevation control)
M = 100;                  % Number of elements in Y (Azimuth control)
d = 0.5;                % Spacing in wavelengths
theta = linspace(-90, 90, 2000); % Elevation angle sweep
theta_rad = deg2rad(theta);

% --- 1. Elevation Plane Calculation (phi = 0) ---
phi_el = deg2rad(0);
psi_x_el = 2 * pi * d * sin(theta_rad) * cos(phi_el);
psi_y_el = 2 * pi * d * sin(theta_rad) * sin(phi_el);

AF_x_el = abs(sin(N * psi_x_el / 2) ./ (N * sin(psi_x_el / 2)));
AF_y_el = abs(sin(M * psi_y_el / 2) ./ (M * sin(psi_y_el / 2)));
AF_x_el(isnan(AF_x_el)) = 1; AF_y_el(isnan(AF_y_el)) = 1;

AF_dB_el = 20 * log10(AF_x_el .* AF_y_el);
hp_idx_el = find(AF_dB_el >= -3);
hpbw_el = theta(max(hp_idx_el)) - theta(min(hp_idx_el));

% --- 2. Azimuth Plane Calculation (phi = 90) ---
phi_az = deg2rad(90);
psi_x_az = 2 * pi * d * sin(theta_rad) * cos(phi_az);
psi_y_az = 2 * pi * d * sin(theta_rad) * sin(phi_az);

AF_x_az = abs(sin(N * psi_x_az / 2) ./ (N * sin(psi_x_az / 2)));
AF_y_az = abs(sin(M * psi_y_az / 2) ./ (M * sin(psi_y_az / 2)));
AF_x_az(isnan(AF_x_az)) = 1; AF_y_az(isnan(AF_y_az)) = 1;

AF_dB_az = 20 * log10(AF_x_az .* AF_y_az);
hp_idx_az = find(AF_dB_az >= -3);
hpbw_az = theta(max(hp_idx_az)) - theta(min(hp_idx_az));

% --- Plotting ---
figure('Color', 'w', 'Position', [100, 100, 900, 450]);

% Subplot 1: Elevation Plane
subplot(1, 2, 1);
plot(theta, AF_dB_el, 'LineWidth', 1.5); hold on; grid on;
yline(-3, '--r', 'LineWidth', 1.5); % Red dashed line
plot([theta(min(hp_idx_el)) theta(max(hp_idx_el))], [-3 -3], 'ro');
title(['Elevation Plane (\phi = 0^\circ)']);
xlabel('Angle \theta (deg)'); ylabel('Magnitude (dB)');
ylim([-40 0]); xlim([-90 90]);
legend('Pattern', '-3dB Limit', 'Location', 'south');
text(0, -5, sprintf('HPBW: %.2f^o', hpbw_el), 'HorizontalAlignment', 'center', 'FontWeight', 'bold');

% Subplot 2: Azimuth Plane
subplot(1, 2, 2);
plot(theta, AF_dB_az, 'LineWidth', 1.5, 'Color', [0 0.5 0]); hold on; grid on;
yline(-3, '--r', 'LineWidth', 1.5); % Red dashed line
plot([theta(min(hp_idx_az)) theta(max(hp_idx_az))], [-3 -3], 'ro');
title(['Azimuth Plane (\phi = 90^\circ)']);
xlabel('Angle \theta (deg)'); ylabel('Magnitude (dB)');
ylim([-40 0]); xlim([-90 90]);
legend('Pattern', '-3dB Limit', 'Location', 'south');
text(0, -5, sprintf('HPBW: %.2f^o', hpbw_az), 'HorizontalAlignment', 'center', 'FontWeight', 'bold');

sgtitle([num2str(N), 'x', num2str(M), ' Phased Array Beamwidth Analysis']);