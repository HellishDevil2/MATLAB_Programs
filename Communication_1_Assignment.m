clc;
clear;
close all;


kf_list = (3:1:8)*1e5;
noise_list = -180:2:-170;

sampling_frequency = 300e6;
message_frequency = 1e3;
carrier_frequency = 100e6;
amplitude_of_message_signal = 1;
fm_mod_amplitude = 1;
number_of_points = 2e6;



time_axis = 0:1/sampling_frequency:(number_of_points-1)/sampling_frequency;

message_signal = amplitude_of_message_signal*sin(2*pi*message_frequency*time_axis);

f_0 = 15e3;
w_0 = 2*pi*f_0;
numerator = w_0/sampling_frequency;
denominator = [1+w_0/sampling_frequency,-1];
preemphasis_message = filter(denominator,numerator,message_signal);

number_of_runs = 10;

writematrix(["Number of Run","k_f","Noise Level","Output SNR","Baseband SNR","Figure of Merit"],"WithPremphasis.csv");



        k_f = 7e5;
        noise_power = -180;
        peak_frequency_deviation = amplitude_of_message_signal*k_f/(2*pi);
        bandwidth_of_fm = 2*(peak_frequency_deviation+message_frequency);


noise = wgn(1,length(message_signal),noise_power,'dBm');
            fm_modulated_wave = fm_mod_amplitude*fmmod(preemphasis_message,carrier_frequency,sampling_frequency,peak_frequency_deviation);
            fm_modulated_wave_with_noise = fm_modulated_wave + noise;
            fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);
            fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);
            output = fmdemod(fm_modulated_wave_without_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
            output_with_noise = fmdemod(fm_modulated_wave_with_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
            b = bandpower(output,sampling_frequency,[0,1200])/bandpower(output-output_with_noise,sampling_frequency,[0,1200]);
            c = bandpower(message_signal,sampling_frequency,[0,1200])/bandpower(noise,sampling_frequency,[0,1200]);
            figure(1);
            plot(time_axis,output)
            ylim([-5,5]);
            figure(2);
            plot(time_axis,output_with_noise)
            ylim([-5,5]);
            figure(3);
            plot(time_axis,preemphasis_message);
            hold on;
            plot(time_axis,message_signal);
            figure(4);
            freq_axis = linspace(-sampling_frequency/2,sampling_frequency/2,number_of_points);
            plot(freq_axis,abs(fftshift(fft(preemphasis_message))));
            hold on;
            plot(freq_axis,abs(fftshift(fft(message_signal))));

            xlim([-5e3,5e3]);
            disp(b/c)

%%


for kf_index = 1:length(kf_list)
    for noise_index = 1:length(noise_list)
        k_f = kf_list(kf_index);
        noise_power = noise_list(noise_index);
        peak_frequency_deviation = amplitude_of_message_signal*k_f/(2*pi);
        bandwidth_of_fm = 2*(peak_frequency_deviation+message_frequency);
        for run = 1:number_of_runs
            noise = wgn(1,length(message_signal),noise_power,'dBm',1,run+10);
            fm_modulated_wave = fm_mod_amplitude*fmmod(preemphasis_message,carrier_frequency,sampling_frequency,peak_frequency_deviation);
            fm_modulated_wave_with_noise = fm_modulated_wave + noise;
            fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);
            fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);
            output = fmdemod(fm_modulated_wave_without_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
            output_with_noise = fmdemod(fm_modulated_wave_with_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
            b = bandpower(output,sampling_frequency,[0,1200])/bandpower(output-output_with_noise,sampling_frequency,[0,1200]);
            c = bandpower(message_signal,sampling_frequency,[0,1200])/bandpower(noise,sampling_frequency,[0,1200]);
            writematrix([run,k_f,noise_power,b,c,b/c],"WithPremphasis.csv","WriteMode","append");
        end
    end
end


writematrix(["Number of Run","k_f","Noise Level","Output SNR","Baseband SNR","Figure of Merit"],"Withoutpremephasis.csv");
for kf_index = 1:length(kf_list)
    for noise_index = 1:length(noise_list)
        k_f = kf_list(kf_index);
        noise_power = noise_list(noise_index);
        peak_frequency_deviation = amplitude_of_message_signal*k_f/(2*pi);
        bandwidth_of_fm = 2*(peak_frequency_deviation+message_frequency);
        for run = 1:number_of_runs
            noise = wgn(1,length(message_signal),noise_power,'dBm',1,run+10);
            
            fm_modulated_wave = fm_mod_amplitude*fmmod(message_signal,carrier_frequency,sampling_frequency,peak_frequency_deviation);
            fm_modulated_wave_with_noise = fm_modulated_wave + noise;          
            fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);
            fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);
            output = fmdemod(fm_modulated_wave_without_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
            output_with_noise = fmdemod(fm_modulated_wave_with_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
            b = bandpower(output,sampling_frequency,[0,1200])/bandpower(output-output_with_noise,sampling_frequency,[0,1200]);
            c = bandpower(message_signal,sampling_frequency,[0,1200])/bandpower(noise,sampling_frequency,[0,1200]);
            writematrix([run,k_f,noise_power,b,c,b/c],"Withoutpremephasis.csv","WriteMode","append");
        end
    end
end


%%


k_f = 5e5;

% 
% 
% pre_fft = fftshift(fft(preemphasis_message));
% freq = linspace(-sampling_frequency/2,sampling_frequency/2,length(time_axis));
% figure(1);
% plot(freq,abs(freq));
% xlim([-2*f_0,2*f_0]);



fm_modulated_wave = fm_mod_amplitude*fmmod(preemphasis_message,carrier_frequency,sampling_frequency,peak_frequency_deviation);

noise_power = -180;

noise = wgn(1,length(message_signal),noise_power,'dBm');

fm_modulated_wave_with_noise = fm_modulated_wave + noise;


fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);
fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);


output = fmdemod(fm_modulated_wave_without_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
output_with_noise = fmdemod(fm_modulated_wave_with_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
% 
% figure(2);
% plot(freq,abs(fftshift(fft(output))));
% xlim([-5*message_frequency,5*message_frequency]);
% 
% figure(3);
% plot(freq,abs(fftshift(fft(output_with_noise))));
% xlim([-5*message_frequency,5*message_frequency]);
% 
% 
% figure(4);
% subplot(2,1,1);
% x = lowpass(output,f_0,sampling_frequency);
% plot(freq,abs(fftshift(fft(x))));
% xlim([-5*message_frequency,5*message_frequency]);
% 
% subplot(2,1,2);
% y = lowpass(output_with_noise,f_0,sampling_frequency);
% plot(freq,abs(fftshift(fft(y))));
% xlim([-5*message_frequency,5*message_frequency]);



b = bandpower(output,sampling_frequency,[0,1200])/bandpower(output-output_with_noise,sampling_frequency,[0,1200]);
c = bandpower(message_signal,sampling_frequency,[0,1200])/bandpower(noise,sampling_frequency,[0,1200]);



disp(b);
disp(c);
disp(b/c);






% sampling_frequency = 300e6;
% message_frequency = 1e3;
% carrier_frequency = 100e6;
% amplitude_of_message_signal = 1;
% fm_mod_amplitude = 1;
% number_of_points = 2e6;
% 
% k_f = 5e5;
% 
% peak_frequency_deviation = amplitude_of_message_signal*k_f/(2*pi);
% bandwidth_of_fm = 2*(peak_frequency_deviation+message_frequency);
% 
% time_axis = 0:1/sampling_frequency:(number_of_points-1)/sampling_frequency;
% 
% message_signal = amplitude_of_message_signal*sin(2*pi*message_frequency*time_axis);

% w_0 = 2*pi*1e3;
% numerator = w_0/sampling_frequency;
% denominator = [1+w_0/sampling_frequency,-1];
% preemphasis_message = filter(numerator,denominator,message_signal);

% noise_power = -180;


fm_modulated_wave = fm_mod_amplitude*fmmod(message_signal,carrier_frequency,sampling_frequency,peak_frequency_deviation);





fm_modulated_wave_with_noise = fm_modulated_wave + noise;
% figure(5);
% subplot(2,1,1);
% plot(time_axis,fm_modulated_wave);
% %xlim([0.08,0.09]);
% subplot(2,1,2);
% plot(time_axis,fm_modulated_wave_with_noise);
% %xlim([0.08,0.0801]);

fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);
fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency);

output = fmdemod(fm_modulated_wave_without_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);
output_with_noise = fmdemod(fm_modulated_wave_with_noise_after_bpf,carrier_frequency,sampling_frequency,peak_frequency_deviation);


b = bandpower(output,sampling_frequency,[0,1200])/bandpower(output-output_with_noise,sampling_frequency,[0,1200]);
c = bandpower(message_signal,sampling_frequency,[0,1200])/bandpower(noise,sampling_frequency,[0,1200]);


disp(b);
disp(c);
disp(b/c)




