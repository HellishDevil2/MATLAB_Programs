clc;
clear;
close all;

row_frequencies = [1209,1336,1477,1633];
column_frequencies = [697,770,852,941];
keys = ['1','2','3','A','4','5','6','B','7','8','9','C','*','0','#','D'];

all_frequencies = [row_frequencies column_frequencies];

T_d = (2:30)*0.001;
sampling_frequency = 8000;
figure_index = 1;
filter_length = 1024;
time_axis = 0:1/sampling_frequency:0.1;

for key_pressed = 1:length(keys)    
    figure(figure_index);
    location = 1;
    row_number = ceil(key_pressed/4);
    column_number = mod(key_pressed,4);
    if column_number == 0
        column_number = 4;
    end
    signal_generated = sin(2*pi*row_frequencies(row_number)*time_axis) + sin(2*pi*column_frequencies(column_number)*time_axis) ;
    for i = 1:length(all_frequencies)
        FIR_filter = 5*cos(2*pi*(all_frequencies(i)/sampling_frequency)*(1:filter_length));
        output_signal = conv(FIR_filter,signal_generated);
        frequency_axis = linspace(-sampling_frequency/2,sampling_frequency/2,length(output_signal));
        subplot(2,4,location);
        plot(frequency_axis,abs(fftshift(fft(output_signal)))/length(output_signal));
        xlabel("Frequency Axis");
        ylabel("Magnitude");
        title(["FFT of Signal with key press = ",keys(key_pressed), "Convolved with BPF of Center Frequency = ",num2str(all_frequencies(i))]);
        location = location + 1;        
    end

    file_name = sprintf("BPF Output for %d Key Pressed.png",key_pressed);
    saveas(gcf,file_name);
    figure_index = figure_index + 1; 

end

