clc;
clear;
close all;


keypad = ['1','2','3','A','4','5','6','B','7','8','9','C','*','0','#','D'];
length_of_keypad = length(keypad);

row_frequencies = [1209,1336,1477,1633];
column_frequencies = [697,770,852,941];


T_d = (2:30)*0.001;
SNR_list = [-10,-4,2,0,2,4,6,8,10];
sampling_frequency = 8000;
Number_of_runs = 20;
time_axis = 0:1/sampling_frequency:0.1;
record_note = table(["Current SNR","Current N","Accuracy"]);
writematrix(["Current SNR","Current N","Accuracy"], 'mydata.csv', 'Delimiter', ',', 'WriteMode', 'append');

for SNR_index = 1:length(SNR_list)
    accuracy_list = zeros(1,length(T_d));
    current_SNR = SNR_list(SNR_index);
    for filter_length_index = 1:length(T_d)
        current_filter_length = T_d(filter_length_index)*sampling_frequency;
        random_key_presses = zeros(1,Number_of_runs);
        predicted_key_presses = zeros(1,Number_of_runs);        
        for run = 1:Number_of_runs
            random_key_pressed = randi(length_of_keypad);
            random_key_presses(run) = random_key_pressed;
            row_number = ceil(random_key_pressed/4);
            column_number = mod(random_key_pressed,4);
            if column_number == 0
                column_number = 4;
            end
            signal_generated = sin(2*pi*row_frequencies(row_number)*time_axis) + sin(2*pi*column_frequencies(column_number)*time_axis) ;
            signal_generated_with_noise = awgn(signal_generated,SNR_list(SNR_index),'measured');
            predicted_row = 0;
            current_power = 0;
            max_power = 0;
            current_output = 0;
            for i = 1:length(row_frequencies)
                FIR_filter = 5*cos(2*pi*(row_frequencies(i)/sampling_frequency)*(1:current_filter_length));
                signal_output = conv(FIR_filter,signal_generated_with_noise);
                current_power = sum(signal_output.^2)/length(signal_output);
                if current_power >= max_power
                    predicted_row = i;
                    max_power = current_power;
                    current_output = signal_output;
                end
            end
            predicted_column = 0;
            current_power = 0;
            max_power = 0;
            current_output = 0;
            for i = 1:length(column_frequencies)
                FIR_filter = 5*cos(2*pi*(column_frequencies(i)/sampling_frequency)*(1:current_filter_length));
                signal_output = conv(FIR_filter,signal_generated_with_noise);
                current_power = sum(signal_output.^2)/length(signal_output);
                if current_power >= max_power
                    predicted_column = i;
                    max_power = current_power;
                    current_output = signal_output;
                end
            end 
            predicted_key_presses(run) = 4*(predicted_row - 1)+predicted_column;
        end
        accuracy = sum(predicted_key_presses==random_key_presses)*100/length(predicted_key_presses);
        accuracy_list(filter_length_index) = accuracy;

        fprintf("Current SNR =  %d, Current Filterlength =  %0.2f, Current Accuracy = %0.2f\n",current_SNR,current_filter_length,accuracy);
        
        writematrix([current_SNR,current_filter_length,accuracy], 'mydata.csv', 'Delimiter', ',', 'WriteMode', 'append');
    end
    figure(SNR_index);
    plot(T_d*sampling_frequency,accuracy_list,'--o');
    xlabel("N");
    ylabel("Accuracy");
    title(["N vs Accuracy for SNR =  ",num2str(current_SNR)]);
end


