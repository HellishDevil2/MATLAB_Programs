clc;
clear;
close all;

number_of_points = 16;
window = blackman(number_of_points)';
cutoff_frequency = pi/2;

low_pass_filter = zeros(1,number_of_points);

for i = 1:number_of_points
    k = (number_of_points-1)/2;
    if i == k
        low_pass_filter(i) = cutoff_frequency/pi;
    else
        x = sin(cutoff_frequency*(i-k))/(pi*(i-k));
        low_pass_filter(i) = x;
    end
end

windowed_low_pass_filter = low_pass_filter.*window;

[freq_response ,frequency_axis] = freqz(windowed_low_pass_filter,1,number_of_points);


window_fft = fftshift(fft(window));
fft_axis = -number_of_points/2:number_of_points/2-1;
figure(1);
plot(fft_axis,abs(window_fft));
title("FFT Plot of the Window");
xlabel("Frequency Bins");
ylabel("Magnitude of FFT");


figure(2);
plot(frequency_axis,20*log10(abs(freq_response)))
grid on;
title("Bode Plot")

ylabel("Magnitude (dB)");
xlabel("Digital Frequency");

figure(3);
plot(fft_axis,abs(fftshift(fft(low_pass_filter))));
title("FFT Plot of the Low Pass Filter");
xlabel("Frequency Bins");
ylabel("Magnitude of FFT");



