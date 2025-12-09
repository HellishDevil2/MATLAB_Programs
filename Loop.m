clc;
clear;
close all
sampling_frequency = 300e6;
message_frequency = 1e3;
carrier_frequency = 100e6;
amplitude_of_message_signal = 1;
fm_mod_amplitude = 1;
number_of_points = 5e6;
number_of_runs = 10;


time_axis = 0:1/sampling_frequency:(number_of_points-1)/sampling_frequency;

message_signal = amplitude_of_message_signal*sin(2*pi*message_frequency*time_axis);

k_f_list = (3:8)*1e5;

noise_power_list = -180:-170;

writematrix(["Number of Run","k_f","Noise Level","Figure of Merit"],"WithPremphasis.csv");

w_0 = 2*pi*15e3;
filter_numerator = [1+w_0/sampling_frequency,-1];
filter_denominator = w_0/sampling_frequency;

premphasis_signal = filter(filter_numerator,filter_denominator,message_signal);



for k_f_index = 1:length(k_f_list)
    k_f = k_f_list(k_f_index);
    peak_frequency_deviation = amplitude_of_message_signal*k_f/(2*pi);
    bandwidth_of_fm = 2*(peak_frequency_deviation+message_frequency);
    fm_modulated_wave = fm_mod_amplitude*fmmod(premphasis_signal,carrier_frequency,sampling_frequency,peak_frequency_deviation);
    for noise_power_index = 1:length(noise_power_list)
        noise_power_dBm = noise_power_list(noise_power_index);
        noise_power_W = 10^((noise_power_dBm-30)/10);
        for run = 1:number_of_runs
            noise = wgn(1,length(message_signal),noise_power_W*sampling_frequency/number_of_points,'linear');
            fm_modulated_wave_with_noise = fm_modulated_wave + noise;
            fm_modulated_wave_with_noise_after_bpf = bandpass(fm_modulated_wave_with_noise,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency,"ImpulseResponse","iir");
            fm_modulated_wave_without_noise_after_bpf = bandpass(fm_modulated_wave,[carrier_frequency-bandwidth_of_fm/2,carrier_frequency+bandwidth_of_fm/2],sampling_frequency,"ImpulseResponse","iir");
                        
            
            analytic = hilbert(fm_modulated_wave_with_noise_after_bpf);
            inst_phase = unwrap(angle(analytic));
            inst_freq = diff(inst_phase) * sampling_frequency / (2*pi);
            inst_freq = [inst_freq inst_freq(end)]; % pad one sample
            baseband_with_noise = inst_freq - carrier_frequency; % remove carrier
            
            %baseband_with_noise = filter(filter_denominator,filter_numerator,baseband_with_noise);
            baseband_with_noise = baseband_with_noise-mean(baseband_with_noise);
            
            
            baseband_with_noise = lowpass(baseband_with_noise,1.2*message_frequency,sampling_frequency);
            
            analytic = hilbert(fm_modulated_wave_without_noise_after_bpf);
            inst_phase = unwrap(angle(analytic));
            inst_freq = diff(inst_phase) * sampling_frequency / (2*pi);
            inst_freq = [inst_freq inst_freq(end)]; % pad one sample
            baseband_without_noise = inst_freq - carrier_frequency; % remove carrier
            %baseband_without_noise = filter(filter_denominator,filter_numerator,baseband_without_noise);
            baseband_without_noise = baseband_without_noise-mean(baseband_without_noise);
            baseband_without_noise = lowpass(baseband_without_noise,1.2*message_frequency,sampling_frequency);
            
            signal_power = bandpower(baseband_without_noise,sampling_frequency,[0,100*message_frequency]);
            noise_power = bandpower(baseband_with_noise-baseband_without_noise,sampling_frequency,[0,100*message_frequency]);
            SNR_with_Modulation = signal_power/noise_power;
            k = fm_mod_amplitude^2/(4*noise_power_W*message_frequency);
            FOM = 10*log10(SNR_with_Modulation/k);
            disp(FOM);
            writematrix([run,k_f,noise_power_dBm,FOM],"WithPremphasis.csv","WriteMode","append");
        end
    end
end
