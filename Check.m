% Fixed LMS adaptive-filter script
clear; close all; clc;

A = 2;                      % Amplitude
F0_values = [1, 2, 3, 10];  % Frequencies in kHz
fs = 10e3;                  % Sampling frequency (Hz)
T = 10;                    % Duration in seconds
mu = 1e-4;                  % Step size
epsilon = 1e-9;             % Convergence threshold (relative)
M = 8;                      % Number of filter coefficients (filter order = M-1)

t = 0:1/fs:T-1/fs;
N = length(t);

for freq_idx = 1:length(F0_values)
    F0 = F0_values(freq_idx) * 1000; % Convert to Hz
    fprintf('Processing F0 = %d kHz\n', F0_values(freq_idx));
    
    % Generate signals
    m = A * sin(2 * pi * F0 * t); % desired sinusoid
    n = randn(1, N);              % white Gaussian noise
    x = m + n;                    % observed signal x(n)
    
    % LMS initialization
    w = zeros(M, 1);
    e = zeros(1, N);
    converged = false;
    
    for idx = M+1:N
        % build input vector [x(n-1); x(n-2); ...; x(n-M)]
        x_delayed = x(idx-1:-1:idx-M).';    % column vector length M
        
        % filter output y(n)
        y = w.' * x_delayed;
        
        % error (enhanced output)
        e(idx) = x(idx) - y;
        
        % update
        w_old = w;
        w = w + mu * x_delayed * e(idx);
        
        % convergence check (relative change of weight vector)
        % rel_change = norm(w - w_old)^2 / (norm(w)^2 + 1e-12);
        % if ~converged && rel_change < epsilon
        %     fprintf('  Converged at iteration %d (rel_change = %.2e)\n', idx, rel_change);
        %     converged = true;
        % end
    end
    
    % print final weights
    fprintf('  Final weights: ');
    fprintf('%.6f ', w);
    fprintf('\n\n');
    
    % Compute transfer function magnitude squared:
    % H_system(z) = 1 - H(z), H(z) = sum_{k=1..M} w(k) z^-k
    freq = linspace(0, fs/2, 1000);
    H_mag_sq = zeros(1, length(freq));
    for k = 1:length(freq)
        f = freq(k);
        omega = 2 * pi * f / fs;
        z = exp(1j * omega);
        H_z = sum( w.' .* z.^(- (1:M)) );   % evaluates H(z)
        H_system = 1 - H_z;
        H_mag_sq(k) = abs(H_system)^2;
    end
    [H_mag_sq,~] = freqz(w,1,length(freq));
    H_mag_sq = abs(H_mag_sq).^2;
    % Plot results
    fig = figure('Name', sprintf('F0 = %d kHz', F0_values(freq_idx)), 'NumberTitle','off');
    
    subplot(3,1,1);
    plot(t(1:500), x(1:500));
    xlabel('Time (s)'); ylabel('Amplitude');
    title(sprintf('Noisy Input Signal x(n) - F0 = %d kHz', F0_values(freq_idx)));
    grid on;
    
    subplot(3,1,2);
    plot(t(1:500), e(1:500));
    xlabel('Time (s)'); ylabel('Amplitude');
    title('Enhanced Output Signal e(n)');
    grid on;
    
    subplot(3,1,3);
    plot(freq/1000, H_mag_sq, 'k', 'LineWidth', 1.5);
    xlabel('Frequency (kHz)'); ylabel('|H(e^{j2\pi f})|^2');
    title('Transfer Function Magnitude Squared');
    grid on; xlim([0, 15]); hold on;
    
    % Mark sinusoid frequency
    [~, idx_marker] = min(abs(freq - F0));
    marker_x = freq(idx_marker)/1000;    % in kHz
    marker_y = H_mag_sq(idx_marker);
    plot(marker_x, marker_y, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6);
    % vertical dashed line and text label
    xline(marker_x, 'r--');
    text(marker_x + 0.2, marker_y, sprintf('F0 = %.1f kHz', marker_x), 'FontSize', 9);
    hold off;
    
    % Optionally save the figure (uncomment to enable)
    % saveas(fig, sprintf('LMS_F0_%dkHz.png', F0_values(freq_idx)));

end