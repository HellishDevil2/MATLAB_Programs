clc;
clear;
close all;






number_keys = 1:16;
length_of_number_case = 16;

row_addition = [1209,1336,1477,1633];
column_addition = [697,770,852,941];


length_of_filter = 1024;

random_key_pressed = randi(length_of_number_case);



row_number = ceil(random_key_pressed/4);
column_number = mod(random_key_pressed,4);
if column_number == 0
    column_number = 4;
end

sampling_frequency = 8000;
time_axis = 0:1/sampling_frequency:0.1;
signal_generated = sin(2*pi*row_addition(row_number)*time_axis) + sin(2*pi*column_addition(column_number)*time_axis) ;
actual_row = 0;
current_power = 0;
max_power = 0;
current_output = 0;
for i = 1:length(row_addition)
    FIR_filter = 5*cos(2*pi*(row_addition(i)/sampling_frequency)*(0:length_of_filter));
    signal_output = conv(FIR_filter,signal_generated);
    current_power = sum(signal_output.^2)/length(signal_output);
    if current_power >= max_power
        actual_row = i;
        max_power = current_power;
        current_output = signal_output;
    end
end
actual_column = 0;
current_power = 0;
max_power = 0;
current_output = 0;
for i = 1:length(column_addition)
    FIR_filter = 5*cos(2*pi*(column_addition(i)/sampling_frequency)*(0:length_of_filter));
    signal_output = conv(FIR_filter,signal_generated);
    current_power = sum(signal_output.^2)/length(signal_output);
    if current_power >= max_power
        actual_column = i;
        max_power = current_power;
        current_output = signal_output;
    end
end
key_list = ['1','2','3','A','4','5','6','B','7','8','9','C','*','0','#','D'];


actual_key_pressed = 4*(actual_row - 1)+actual_column;
disp("Key Predicted");
disp(key_list(actual_key_pressed));
disp("Actual Key Pressed");
disp(key_list(random_key_pressed));


     
%pressed_signal = audioplayer(10*signal_generated,sampling_frequency);


%obtained_signal = audioplayer(10*current_output,sampling_frequency);


%play(pressed_signal);
%pause(3);
%play(obtained_signal); 



%player = audioplayer(signal,sampling_freqency);
%play(player);