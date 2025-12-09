clc;
clear;
close all;


sampling_frequency = 300e6;
message_frequency = 1e3;
carrier_frequency = 100e6;
amplitude_of_message_signal = 1;
fm_mod_amplitude = 1;
number_of_points = 5e6;

k_f = 5e5;

peak_frequency_deviation = amplitude_of_message_signal*k_f/(2*pi);
bandwidth_of_fm = 2*(peak_frequency_deviation+message_frequency);

time_axis = 0:1/sampling_frequency:(number_of_points-1)/sampling_frequency;

message_signal = amplitude_of_message_signal*sin(2*pi*message_frequency*time_axis);

fm_modulated_wave = fm_mod_amplitude*fmmod(message_signal,carrier_frequency,sampling_frequency,peak_frequency_deviation);



noise_power = -170;
noise_power_W = 10^((noise_power-30)/10);



noise = wgn(1,length(message_signal),noise_power_W*sampling_frequency/number_of_points,'linear');

fm_modulated_wave_with_noise = fm_modulated_wave + noise;
figure(1);
subplot(2,1,1);
plot(time_axis,fm_modulated_wave);
%xlim([0.08,0.09]);
subplot(2,1,2);
plot(time_axis,fm_modulated_wave_with_noise);
%xlim([0.08,0.0801]);

%%

fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency,"ImpulseResponse","iir");
fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency,"ImpulseResponse","iir");

analytic = hilbert(fm_modulated_wave_with_noise_after_bpf);
inst_phase = unwrap(angle(analytic));
inst_freq = diff(inst_phase) * sampling_frequency / (2*pi);
inst_freq = [inst_freq inst_freq(end)]; % pad one sample
baseband_with_noise = inst_freq - carrier_frequency; % remove carrier
baseband_with_noise = lowpass(baseband_with_noise,1.2*message_frequency,sampling_frequency);

baseband_with_noise = baseband_with_noise-mean(baseband_with_noise);

analytic = hilbert(fm_modulated_wave_without_noise_after_bpf);
inst_phase = unwrap(angle(analytic));
inst_freq = diff(inst_phase) * sampling_frequency / (2*pi);
inst_freq = [inst_freq inst_freq(end)]; % pad one sample
baseband_without_noise = inst_freq - carrier_frequency; % remove carrier

baseband_without_noise = lowpass(baseband_without_noise,1.2*message_frequency,sampling_frequency);

baseband_without_noise = baseband_without_noise-mean(baseband_without_noise);

figure(2);
subplot(2,1,1);
plot(baseband_without_noise);
ylim([-1e6,1e6]);
title("Demodulated Signal without Noise");
subplot(2,1,2);
plot(baseband_with_noise);
ylim([-1e6,1e6]);
title("Demodulated Signal with Noise");

figure(3);
freq = linspace(-sampling_frequency/2,sampling_frequency/2,length(baseband_with_noise));
subplot(2,1,1);
plot(freq,abs(fftshift(fft(baseband_without_noise))));
xlim([-5*message_frequency,5*message_frequency]);
title("Frequency Plot for the demodulated signal without noise");
xlabel("Frequency(Hz)")
ylabel("Magnitude");
subplot(2,1,2);
plot(freq,abs(fftshift(fft(baseband_with_noise))));
xlim([-5*message_frequency,5*message_frequency]);

title("Frequency Plot for the demodulated signal with noise");
xlabel("Frequency(Hz)")
ylabel("Magnitude");


signal_power = bandpower(baseband_without_noise,sampling_frequency,[0,100*message_frequency]);
noise_power = bandpower(baseband_with_noise-baseband_without_noise,sampling_frequency,[0,100*message_frequency]);
disp(noise_power)
disp(signal_power);
SNR_with_Modulation = signal_power/noise_power;
%disp(SNR_with_Modulation);

% 
% 
% no_modulation_output_noise = lowpass(message_signal*fm_mod_amplitude/amplitude_of_message_signal+noise,1.1*message_frequency,sampling_frequency,"ImpulseResponse","iir");
% no_modulation_output = lowpass(message_signal*fm_mod_amplitude/amplitude_of_message_signal,1.1*message_frequency,sampling_frequency,"ImpulseResponse","iir");
% 
% 
% signal_power = bandpower(no_modulation_output,sampling_frequency,[0,1000*message_frequency]);
% noise_power = bandpower(no_modulation_output-no_modulation_output_noise,sampling_frequency,[0,1000*message_frequency]);
% %SNR_without_Modulation = sum(no_modulation_output.^2)/sum((no_modulation_output_noise-no_modulation_output).^2);
% SNR_without_Modulation = signal_power/noise_power;
% disp(SNR_without_Modulation);

disp("Figure of Merit without premephasis and deemphasis:")
% disp(SNR_with_Modulation/SNR_without_Modulation);
% disp("In Log")
% disp(10*log10(SNR_with_Modulation/SNR_without_Modulation))
disp("FOM")
k = fm_mod_amplitude^2/(4*noise_power_W*message_frequency);
disp(SNR_with_Modulation/k);
disp("FOM in Log");
disp(10*log10(SNR_with_Modulation/k));



% 
% differentiated_signal_with_noise = gradient(fm_modulated_wave_with_noise_after_bpf,1/sampling_frequency);
% differentiated_signal_without_noise = gradient(fm_modulated_wave_without_noise_after_bpf,1/sampling_frequency);
% figure(2)
% subplot(2,1,1);
% plot(time_axis,differentiated_signal_without_noise);
% subplot(2,1,2);
% plot(time_axis,differentiated_signal_with_noise);
% 
% envelope_without_noise = abs(hilbert(differentiated_signal_without_noise));
% envelope_with_noise = abs(hilbert(differentiated_signal_with_noise));
% 
% figure(3);
% subplot(2,1,1);
% plot(time_axis,envelope_without_noise);
% subplot(2,1,2);
% plot(time_axis,envelope_with_noise);
% 
% figure(4);
% a = envelope_without_noise;
% a = a-mean(a);
% b = envelope_with_noise;
% b = b-mean(b);
% frequency_axis = linspace(-sampling_frequency/2,sampling_frequency/2,length(a));
% subplot(2,1,1);
% plot(frequency_axis,abs(fftshift(fft(a))));
% xlim([-5*message_frequency,5*message_frequency])
% subplot(2,1,2);
% plot(frequency_axis,abs(fftshift(fft(b))));
% xlim([-5*message_frequency,5*message_frequency])

%%

w_0 = 2*pi*15e3;
f_0 = 15e3;
filter_numerator = [1+w_0/sampling_frequency,-1];
filter_denominator = w_0/sampling_frequency;

premphasis_signal = filter(filter_numerator,filter_denominator,message_signal);

fm_modulated_wave = fm_mod_amplitude*fmmod(premphasis_signal,carrier_frequency,sampling_frequency,peak_frequency_deviation);

fm_modulated_wave_with_noise = fm_modulated_wave + noise;


fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency,"ImpulseResponse","iir");
fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency,"ImpulseResponse","iir");

analytic = hilbert(fm_modulated_wave_with_noise_after_bpf);
inst_phase = unwrap(angle(analytic));
inst_freq = diff(inst_phase) * sampling_frequency / (2*pi);
inst_freq = [inst_freq inst_freq(end)]; % pad one sample
baseband_with_noise = inst_freq - carrier_frequency; % remove carrier

%baseband_with_noise = filter(filter_denominator,filter_numerator,baseband_with_noise);



baseband_with_noise = lowpass(baseband_with_noise,1.2*message_frequency,sampling_frequency);

baseband_with_noise = lowpass(baseband_with_noise,f_0,sampling_frequency);
baseband_with_noise = baseband_with_noise-mean(baseband_with_noise);

analytic = hilbert(fm_modulated_wave_without_noise_after_bpf);
inst_phase = unwrap(angle(analytic));
inst_freq = diff(inst_phase) * sampling_frequency / (2*pi);
inst_freq = [inst_freq inst_freq(end)]; % pad one sample
baseband_without_noise = inst_freq - carrier_frequency; % remove carrier
%baseband_without_noise = filter(filter_denominator,filter_numerator,baseband_without_noise);



baseband_without_noise = lowpass(baseband_without_noise,1.2*message_frequency,sampling_frequency);

baseband_without_noise = lowpass(baseband_without_noise,f_0,sampling_frequency);
baseband_without_noise = baseband_without_noise-mean(baseband_without_noise);

figure(2);
subplot(2,1,1);
plot(baseband_without_noise);

title("Demodulated Signal without Noise after pre-emphasis and de-emphasis filters");
ylim([-1e6,1e6]);
subplot(2,1,2);
plot(baseband_with_noise);

title("Demodulated Signal with Noise after pre-emphasis and de-emphasis filters");
ylim([-1e6,1e6]);

figure(3);
freq = linspace(-sampling_frequency/2,sampling_frequency/2,length(baseband_with_noise));
subplot(2,1,1);
plot(freq,abs(fftshift(fft(baseband_without_noise))));
xlim([-5*message_frequency,5*message_frequency]);
title("Frequency Plot of Baseband without Noise after pre-emphasis and de-emphasis filters")
xlabel("Frequency(Hz)")
ylabel("Magnitude");
subplot(2,1,2);
plot(freq,abs(fftshift(fft(baseband_with_noise))));
xlim([-5*message_frequency,5*message_frequency]);

title("Frequency Plot of Baseband with Noise after pre-emphasis and de-emphasis filters")
xlabel("Frequency(Hz)")
ylabel("Magnitude");


signal_power = bandpower(baseband_without_noise,sampling_frequency,[0,100*message_frequency]);
noise_power = bandpower(baseband_with_noise-baseband_without_noise,sampling_frequency,[0,100*message_frequency]);
SNR_with_Modulation = signal_power/noise_power;
%disp(SNR_with_Modulation);


% 
% no_modulation_output_noise = lowpass(message_signal*fm_mod_amplitude/amplitude_of_message_signal+noise,1.1*message_frequency,sampling_frequency,"ImpulseResponse","iir","StopbandAttenuation",100);
% no_modulation_output = lowpass(message_signal*fm_mod_amplitude/amplitude_of_message_signal,1.1*message_frequency,sampling_frequency,"ImpulseResponse","iir","StopbandAttenuation",100);
% 
% 
% no_modulation_output = filtfilt(filter_numerator,filter_denominator,no_modulation_output);
% no_modulation_output = filtfilt(filter_denominator,filter_numerator,no_modulation_output);
% 
% no_modulation_output_noise = filtfilt(filter_numerator,filter_denominator,no_modulation_output_noise);
% no_modulation_output_noise = filtfilt(filter_denominator,filter_numerator,no_modulation_output_noise);
% 
% 
% signal_power = bandpower(no_modulation_output,sampling_frequency,[0,1000*message_frequency]);
% noise_power = bandpower(no_modulation_output-no_modulation_output_noise,sampling_frequency,[0,1000*message_frequency]);
% %SNR_without_Modulation = sum(no_modulation_output.^2)/sum((no_modulation_output_noise-no_modulation_output).^2);
% SNR_without_Modulation = signal_power/noise_power;
% %disp(SNR_without_Modulation);

disp("Figure of Merit with Pre-Emphasis and De-Emphasis")
%disp(SNR_with_Modulation/SNR_without_Modulation);
% 
% disp("In Log")
% disp(10*log10(SNR_with_Modulation/SNR_without_Modulation))

disp("FOM")
k = fm_mod_amplitude^2/(4*noise_power_W*message_frequency);
disp(SNR_with_Modulation/k);
disp("FOM in Log");
disp(10*log10(SNR_with_Modulation/k));
