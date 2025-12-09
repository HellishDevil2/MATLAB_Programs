clc
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

z = hilbert(fm_modulated_wave_with_noise_after_bpf);
r = [z(2:end).*conj(z(1:end-1)),1];
angular_frequency = angle(r)*sampling_frequency;
frequency = angular_frequency/(2*pi);
baseband_with_noise = (frequency-k_f)/(2*pi);
baseband_with_noise = lowpass(baseband_with_noise,1.2*message_frequency,sampling_frequency);
baseband_with_noise = baseband_with_noise - mean(baseband_with_noise);


z = hilbert(fm_modulated_wave_without_noise_after_bpf);
r = [z(2:end).*conj(z(1:end-1)),1];
angular_frequency = angle(r)*sampling_frequency;
frequency = angular_frequency/(2*pi);
baseband_without_noise = (frequency-k_f)/(2*pi);
baseband_without_noise = lowpass(baseband_without_noise,1.2*message_frequency,sampling_frequency);
baseband_without_noise = baseband_without_noise - mean(baseband_without_noise);

SNR_out = bandpower(baseband_without_noise,sampling_frequency,[0,1000*message_frequency])/bandpower(baseband_without_noise-baseband_with_noise,sampling_frequency,[0,1000*message_frequency]);
SNR_in = amplitude_of_message_signal^2/(4*noise_power_W*message_frequency);

disp(10*log10(SNR_out/SNR_in));

%%

w_0 = 2*pi*15e3;
filter_numerator = [1+w_0/sampling_frequency,-1];
filter_denominator = w_0/sampling_frequency;

premphasis_signal = filter(filter_numerator,filter_denominator,message_signal);

fm_modulated_wave = fm_mod_amplitude*fmmod(premphasis_signal,carrier_frequency,sampling_frequency,peak_frequency_deviation);

fm_modulated_wave_with_noise = fm_modulated_wave + noise;


fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency,"ImpulseResponse","iir");
fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency,"ImpulseResponse","iir");


z = hilbert(fm_modulated_wave_with_noise_after_bpf);
r = [z(2:end).*conj(z(1:end-1)),1];
angular_frequency = angle(r)*sampling_frequency;
frequency = angular_frequency/(2*pi);
baseband_with_noise = (frequency-k_f)/(2*pi);
baseband_with_noise = lowpass(baseband_with_noise,1.2*message_frequency,sampling_frequency);
baseband_with_noise = filter(filter_denominator,filter_numerator,baseband_with_noise);
baseband_with_noise = baseband_with_noise - mean(baseband_with_noise);


z = hilbert(fm_modulated_wave_without_noise_after_bpf);
r = [z(2:end).*conj(z(1:end-1)),1];
angular_frequency = angle(r)*sampling_frequency;
frequency = angular_frequency/(2*pi);
baseband_without_noise = (frequency-k_f)/(2*pi);
baseband_without_noise = lowpass(baseband_without_noise,1.2*message_frequency,sampling_frequency);
baseband_without_noise = filter(filter_denominator,filter_numerator,baseband_without_noise);

baseband_without_noise = baseband_without_noise - mean(baseband_without_noise);

SNR_out = bandpower(baseband_without_noise,sampling_frequency,[0,1000*message_frequency])/bandpower(baseband_without_noise-baseband_with_noise,sampling_frequency,[0,1000*message_frequency]);
SNR_in = bandpower(message_signal,sampling_frequency,[0,1000*message_frequency])/2*noise_power_W*message_frequency;

disp(10*log10(SNR_out/SNR_in));