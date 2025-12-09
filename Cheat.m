clc; clear; close all;

%% ---------- Problem setup ----------
A        = 2;                     % sinusoid amplitude
Fo_list  = [1e3 2e3 3e3 10e3];    % Hz (repeat for these)
Fs       = 100e3;                 % sampling freq (Hz)  >> 2*max(F0)
T        = 0.5;                   % duration (s)
N        = round(T*Fs);           % number of samples
n        = (0:N-1).';
t        = n/Fs;

L        = 32;                    % FIR length (number of taps)
D        = 1;                     % delay (z^-1 in the diagram)
mu       = 1e-4;                  % LMS step size (μ)
eps_rel  = 1e-3;                  % stopping threshold ε'
maxPass  = 3;                     % safety: require a few passes below eps_rel

% helper for stable relative-change when w is near zero at start
relChange = @(w_new,w_old) (norm(w_new-w_old)^2) / (norm(w_old)^2 + 1e-16);

%% ---------- Loop over the requested F0 values ----------
figure('Name','|H(e^{j\omega})|^2 of the learned ALE','Color','w');
tiledlayout(2,2, 'Padding','compact','TileSpacing','compact');

for k = 1:numel(Fo_list)
    F0 = Fo_list(k);

    % 1) Sinusoidal message m(t)
    m = A*sin(2*pi*F0*t);

    % 2) Add zero-mean, unit-variance white Gaussian noise
    v = randn(N,1);               % unit variance
    x = m + v;                    % input to ALE

    % 3) Discrete signal is already 'x' (sampled at Fs)

    % 4–6) ALE with one-sample delay and LMS adaptation
    w = zeros(L,1);               % initial weights
    belowCnt = 0;                 % count consecutive passes of stopping test

    % Buffers for analysis (optional)
    e = zeros(N,1);               % error
    y = zeros(N,1);               % filter output

    for nIdx = (L+D):N-1
        % Regressor vector: delayed input [x(n-D); x(n-D-1); ...]
        u = x(nIdx-D:-1:nIdx-D-L+1);

        % Filter output & error: y(n) = w^T u, e(n) = x(n) - y(n)
        y(nIdx) = w.'*u;
        e(nIdx) = x(nIdx) - y(nIdx);

        % 5) Update: w(n+1) = w(n) + μ * u * e(n)
        w_new = w + mu * u * e(nIdx);

        % 6) Stop when relative change < eps'
        rc = relChange(w_new, w);
        if rc < eps_rel
            belowCnt = belowCnt + 1;
        else
            belowCnt = 0;
        end
        w = w_new;

        if belowCnt >= maxPass
            % a few consecutive passes to avoid accidental early stop
            break;
        end
    end

    % 7) Plot the latest transfer function |H(e^{jω})|^2
    Nfft = 2048;
    [H, wnorm] = freqz(w, 1, Nfft, 'whole');   % 0..2π
    Hs = fftshift(H);                           % -> -π..π
    wplot = linspace(-pi, pi, Nfft);            % rad/sample
    fplot = wplot * Fs/(2*pi);                  % Hz (for readability)

    nexttile;
    plot(fplot, abs(Hs).^2, 'LineWidth', 1.15); grid on;
    xlim([-Fs/2 Fs/2]);
    xlabel('Frequency (Hz)');
    ylabel('|H(e^{j\omega})|^2');
    title(sprintf('ALE learned |H|^2   F_0 = %.0f kHz', F0/1e3));
end
