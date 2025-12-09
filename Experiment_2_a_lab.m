clc;
clear;
close all;
N = 64;
w_c = pi/2;
hd_n = zeros(1,N);
k = (N-1)/2;
for i= 1:N
    if i~=k
        hd_n(i) = (sin(w_c *(i-k)))/(pi*(i-k));
    else 
        hd_n(i) = w_c/pi;
    end
end


number_of_points = 4*N;
sampling_frequency = 24e3;
time_axis = linspace(0,(number_of_points-1)/sampling_frequency,number_of_points);
f1 = 4e3;
f2 = 10e3;
noise = rand(1,number_of_points);
input_signal = 2*cos(2*pi*f1*time_axis)+cos(2*pi*f2*time_axis);
noisy_input_signal = 2*cos(2*pi*f1*time_axis)+cos(2*pi*f2*time_axis) + 1.5 * noise; 


rectangular_window = ones(1,N);
hamming_window = hamming(N)';
hanning_window = hann(N)';
blackman_window = blackman(N)';
kbdwin_window = kbdwin(N)';
kaiser_window = kaiser(N,2.5)';
window_array = {rectangular_window,hamming_window,hanning_window,blackman_window,kbdwin_window,kaiser_window};
window_titles = ["Rectangular Window","Hamming Window","Hanning Window","Blackman Window","KBDWIN Window","Kaiser Window"];
for i = 1:length(window_titles)
    h_n = hd_n.*window_array{i};
    [amplitude,frequency_axis] = freqz(h_n,1);
    figure(i);
    subplot(4,1,1);
    plot(frequency_axis-pi/2,20*log(abs(amplitude)));
    xlabel("Angle from 0 to 2*pi");
    ylabel("dB Plot");
    title(strcat("Amplitude plot of filter with ",window_titles(i)));
    subplot(4,1,2);
    plot(frequency_axis-pi/2,angle(amplitude));
    xlabel("Angle from 0 to 2*pi");
    ylabel("Angle in Radians");
    title(strcat("Phase plot of filter with ",window_titles(i)));
    subplot(4,1,3);
    filtered_output = filtfilt(h_n,1,input_signal);
    frequency_axis = linspace(-sampling_frequency,sampling_frequency,length(filtered_output))/2;
    plot(frequency_axis-pi,abs(fftshift(fft(filtered_output))));
    xlabel("Frequency");
    ylabel("Amplitude");
    title(strcat("FFT plot of filtered output with ",window_titles(i)));
    subplot(4,1,4);
    filtered_noisy_output = filtfilt(h_n,1,noisy_input_signal);
   
    frequency_axis = linspace(-sampling_frequency,sampling_frequency,length(filtered_noisy_output))/2;
    plot(frequency_axis-pi,abs(fftshift(fft(filtered_noisy_output))));
    xlabel("Frequency");
    ylabel("noisy Amplitude");
    title(strcat("FFT plot of filtered noisy output with ",window_titles(i)));
    disp(snr(filtered_output,filtered_noisy_output-filtered_output));


end
