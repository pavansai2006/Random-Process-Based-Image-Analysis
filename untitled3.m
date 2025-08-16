N = 1e5;                     % Number of samples (must be even)
fs = 1e4;                    % Sampling frequency

% Frequency vector (for half spectrum, skip DC and Nyquist)
f = (1:(N/2 - 1)) / N * fs;

% PSD ∝ 1/f for frequencies > 0
mag = 1 ./ sqrt(f);          % Magnitude spectrum (1/f)

% Build full symmetric magnitude spectrum
mag_full = [0, mag, 0, fliplr(mag)];  % Now mag_full has length N

% Random phase for each frequency bin
phi = 2 * pi * rand(1, N);           % Uniformly random phase
spectrum = mag_full .* exp(1j * phi);  % Combine mag and phase

% IFFT to get time-domain flicker noise
flicker_noise = real(ifft(spectrum));

% Normalize
flicker_noise = flicker_noise / max(abs(flicker_noise));

% Plot first 1000 samples
plot(flicker_noise(1:1000));
title('Flicker Noise (1/f)');
xlabel('Sample'); ylabel('Amplitude');
grid on;