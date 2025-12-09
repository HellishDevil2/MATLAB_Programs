clc;
clear;
close all;
number_of_points = 1e4;



Amplitude_of_message_signal = 1;
Amplitude_of_carrier = 1;
Signal_frequency = 1e3;
k_f = 5e5;
band_width = (k_f*Amplitude_of_message_signal/(2*pi) + Signal_frequency)*2;
sampling_frequency = 2.5*band_width;

time_axis = 0:1/sampling_frequency:(number_of_points-1)/sampling_frequency;


message_signal = Amplitude_of_message_signal*cos(2*pi*Signal_frequency*time_axis);
integrated_signal = cumsum(message_signal)/sampling_frequency;

fm_modulated_signal = Amplitude_of_carrier*cos(k_f*integrated_signal);

noise_dBm = -180;
noise_in_W = power(10,noise_dBm/10)/1000;
noise_in_base_band = 2*noise_in_W;
noise = wgn(1,number_of_points,noise_in_W,'linear');

fm_with_noise = fm_modulated_signal;

diff_signal = [0,diff(fm_with_noise)] * sampling_frequency;
freq_axis = linspace(-sampling_frequency/2,sampling_frequency/2,number_of_points);
plot(freq_axis,abs(fftshift(fft(diff_signal))));
% xlim([-1.5*Signal_frequency,1.5*Signal_frequency]);



diff_signal = diff_signal + max(diff_signal);

[upper,A12] = envelope(diff_signal);

upper = upper-mean(upper);
% freq_axis = linspace(-sampling_frequency/2,sampling_frequency/2,number_of_points);
% plot(freq_axis,abs(fftshift(fft(upper))));
% hold on;
% plot(freq_axis,abs(fftshift(fft(message_signal))));
% xlim([-5*Signal_frequency,5*Signal_frequency]);
% hold off;
% 
% upper = lowpass(upper,1.1*Signal_frequency,sampling_frequency);
% upper = upper-mean(upper);
