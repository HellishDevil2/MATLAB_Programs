clc;
clear;
close all;
sampling_frequency = 8000;
w1 = 2*pi*1000;
w2 = 2*pi*2000;
w3 = 2*pi*4000;
number_of_points = 256;

time_axis = linspace(0,(number_of_points-1)/sampling_frequency,number_of_points);
signal = 10*cos(w1*time_axis)+6*cos(w2*time_axis)+2*cos(w3*time_axis);

signal_fft = fft(signal);
frequency_axis = (-number_of_points/2:number_of_points/2-1)*sampling_frequency/number_of_points;

subplot(1,2,1);
plot(frequency_axis,abs(fftshift(signal_fft)));
title("Amplitude vs Frequency Plot");
ylabel("Amplitude");
xlabel("Frequency");

subplot(1,2,2);
plot(frequency_axis,angle(fftshift(signal_fft)));
title("Phase vs Frequency Plot");
ylabel("Phase");
xlabel("Frequency");


