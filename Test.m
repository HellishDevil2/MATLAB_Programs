
clear;
close all;


sampling_frequency = 300e6;
message_frequency = 1e3;
carrier_frequency = 100e6;
amplitude_of_message_signal = 1;
fm_mod_amplitude = 1;
number_of_points = 2e6;

k_f = 5e5;

peak_frequency_deviation = amplitude_of_message_signal*k_f/(2*pi);
bandwidth_of_fm = 2*(peak_frequency_deviation+message_frequency);

time_axis = 0:1/sampling_frequency:(number_of_points-1)/sampling_frequency;

message_signal = amplitude_of_message_signal*sin(2*pi*message_frequency*time_axis);

% w_0 = 2*pi*1e3;
% numerator = w_0/sampling_frequency;
% denominator = [1+w_0/sampling_frequency,-1];
% preemphasis_message = filter(numerator,denominator,message_signal);

fm_modulated_wave = fm_mod_amplitude*fmmod(message_signal,carrier_frequency,sampling_frequency,peak_frequency_deviation);



noise_power = -180;

noise = wgn(1,length(message_signal),noise_power,'dBm');

fm_modulated_wave_with_noise = fm_modulated_wave + noise;
figure(1);
subplot(2,1,1);
plot(time_axis,fm_modulated_wave);
%xlim([0.08,0.09]);
subplot(2,1,2);
plot(time_axis,fm_modulated_wave_with_noise);
%xlim([0.08,0.0801]);

fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);
fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);

output = fmdemod(fm_modulated_wave_without_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
output_with_noise = fmdemod(fm_modulated_wave_with_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);

a = sum(output.^2) / sum((output-output_with_noise).^2);
b = bandpower(output,sampling_frequency,[0,1200])/bandpower(output-output_with_noise,sampling_frequency,[0,1200]);
c = bandpower(message_signal,sampling_frequency,[0,1200])/bandpower(noise,sampling_frequency,[0,1200]);


disp(b);
disp(c);
disp(b/c)


