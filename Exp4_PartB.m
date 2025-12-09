clc;
clear;
close all;

noise_power = 0.5;
number_of_points = 512;

white_noise = wgn(1,number_of_points,noise_power,'linear');


digital_filter_numerator = 1;
digital_filter_denominator = [1,-0.9,0.81,-0.729];

output = filter(digital_filter_numerator,digital_filter_denominator,white_noise);

[output_autocorrelation,lags] = xcorr(output,number_of_points,'normalized');
frequency_axis = linspace(-pi,pi,length(output_autocorrelation));

figure(1);
plot(frequency_axis,abs(fftshift(fft(output_autocorrelation))))
right_half_auto_correlation = output_autocorrelation(number_of_points+1:2*number_of_points+1);

number_of_blocks = 8;
block_length = 64;
overlap = 32;
x_list = zeros(number_of_blocks,number_of_points);

for i = 1:number_of_blocks
    for j = 1:block_length
        index = (i-1)*block_length+j;
        if i == 1
            x_list(i,j) = output(index);
        else
            x_list(i,j) = output(index-overlap);
        end

    end
end

hamm = hamming(block_length)';
normalise_hamm = sum(hamm.^2)/number_of_points;
hamm = [hamm,zeros(1,number_of_points-block_length)];

psd_list = zeros(number_of_blocks,number_of_points);

for i = 1:number_of_blocks
    psd_list(i,:) = abs(fftshift(fft(x_list(i,:).*hamm))).^2/(block_length*normalise_hamm);
end

final_estimate = sum(psd_list,1)/number_of_blocks;
freq_axis = linspace(-pi,pi,number_of_points);
figure(2);
plot(freq_axis,final_estimate);









