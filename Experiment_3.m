clc;
clear;
close all;






number_keys = 1:16;

row_addition = [1209,1336,1477,1633];
column_addition = [697,770,852,941];
frequency_list = zeros(1,length(number_keys));

for i = 1:16
    if i < 10
        r_index = ceil(i/3);
        col_index = mod(i,3);
        if col_index == 0
            col_index = 3;
        end
        frequency_list(i) = row_addition(r_index) + column_addition(col_index);
    elseif i <= 13
        frequency_list(i) = row_addition(end) + column_addition(i-9);
    else
        frequency_list(i) = column_addition(end) + row_addition(i-13);
    end
end



length_of_filter = 1024;

random_key_pressed = randi(length(frequency_list));

signal_pressed = frequency_list(random_key_pressed);


sampling_frequency = 8000;
time_axis = 0:1/sampling_frequency:0.1;
signal_generated = sin(2*pi*signal_pressed*time_axis);
actual_key_pressed = 0;
current_power = 0;
max_power = 0;
current_output = 0;
for i = 1:length(frequency_list)
    FIR_filter = 5*cos(2*pi*(frequency_list(i)/sampling_frequency)*(0:length_of_filter));
    signal_output = conv(FIR_filter,signal_generated);
    current_power = sum(signal_output.^2)/length(signal_output);
    if current_power >= max_power
        actual_key_pressed = i;
        max_power = current_power;
        current_output = signal_output;
    end
end

disp(actual_key_pressed);
disp(random_key_pressed);



     
pressed_signal = audioplayer(10*signal_generated,sampling_frequency);


obtained_signal = audioplayer(10*current_output,sampling_frequency);


play(pressed_signal);
pause(3);
play(obtained_signal); 



%player = audioplayer(signal,sampling_freqency);
%play(player);