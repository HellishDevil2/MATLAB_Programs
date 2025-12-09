clc;
clear;
close all;

time_period = 1e-3;
sampling_frequency = 20e3;
number_of_points = 256;

time_axis = linspace(0,(number_of_points-1)/sampling_frequency,number_of_points);
sine_wave = sin((2*pi/time_period)*time_axis);
square_wave = sign(sine_wave);

square_wave_fft = fftshift(fft(square_wave));
frequency_axis = (-number_of_points/2:number_of_points/2-1)*sampling_frequency/number_of_points;


subplot(1,2,1);
plot(time_axis,square_wave);
xlabel("Time");
ylabel("Amplitude");
title("Square Wave");

subplot(1,2,2);
plot(frequency_axis,abs(square_wave_fft));
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title("FFT Plot");
