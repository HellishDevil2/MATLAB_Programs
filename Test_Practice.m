%Design a high pass filter using all the methods 
clc;
clear;
close all;
number_of_points = 129;
cutoff_frequency = 0.2*pi;

n_index = -(number_of_points-1)/2:1:(number_of_points-1)/2;

high_pass_ideal_coefficients = zeros(1,number_of_points);

for i = 1:number_of_points
    if n_index(i) == 0
        high_pass_ideal_coefficients(i) = 1-cutoff_frequency/pi;
    else
        high_pass_ideal_coefficients(i) = -sin(cutoff_frequency*n_index(i))/(pi*n_index(i));
    end
end

plot(high_pass_ideal_coefficients);
%Hamming Window

window = hann(number_of_points)';

final_filter = window.*high_pass_ideal_coefficients;

freqz(final_filter,1);
title("Windowing");
legend("show");

%%
%Least Squares

filter_order = 32;
lower_transistion = 0.2*pi;
upper_transisiton = 0.3*pi;

attenuation = 1e-5;

least_squares_filter = firls(filter_order,[0,lower_transistion/pi,upper_transisiton/pi,1],[attenuation,attenuation,1,1]);

freqz(least_squares_filter,1);
title("Least Squares Filter");

%%
%PM Filter
filter_order = 32;
lower_transistion = 0.2*pi;
upper_transisiton = 0.3*pi;

attenuation = 1e-5;

least_squares_filter = firpm(filter_order,[0,lower_transistion/pi,upper_transisiton/pi,1],[attenuation,attenuation,1,1]);

freqz(least_squares_filter,1);
title("PM Filter");


%%

clc;
clear;
close all;
pole_1 = 1.2532322+j;
pole_2 = -1.2532322-j;

word_length = 6;
fraction_length = 4;

new_pole_1 = quantizenumeric(pole_1,1,word_length,fraction_length);

f1 = [1,-pole_1];
f2 = [1,-pole_2];

denominator = conv(f1,f2);
disp(denominator)
quantized_denominator = quantizenumeric(denominator,1,word_length,fraction_length);
disp(quantized_denominator);

%to find roots
root = roots(quantized_denominator);
disp(root);

[h1,f1] = freqz(1,quantized_denominator);
[h,f] = freqz(1,denominator);

plot(f1,abs(h1));
hold on;
plot(f,abs(h));
legend(["With Quantisation","Without Quantisation"])


%%
clc;

close all;

[r,p,k] = residue(1,flip(denominator));

r_1 = -r(1)/p(1);
new_den1 = [1,-1/p(1)];
r_2 = -r(2)/p(2);
new_den2 = [1,-1/p(2)];

disp(r_1);
disp(new_den1);
disp(r_2);
disp(new_den2);


quantised_r1 = quantizenumeric(r_1,1,word_length,fraction_length);
quantised_r2 = quantizenumeric(r_2,1,word_length,fraction_length);

quantised_denominator1 = quantizenumeric(new_den1,1,word_length,fraction_length);
quantised_denominator2 = quantizenumeric(new_den2,1,word_length,fraction_length);


[h1,f1] = freqz(quantised_r1,quantised_denominator1);
[h2,f2] = freqz(quantised_r2,quantised_denominator2);
[h,f] = freqz(1,denominator);

plot(f1,abs(h1+h2));
hold on;
plot(f,abs(h));
legend(["With Quantisation","Without Quantisation"])

%%
clc;

close all;

[r,p,k] = residue(1,flip(denominator));

r_1 = -r(1)/p(1);
new_den1 = [1,-1/p(1)];
r_2 = -r(2)/p(2);
new_den2 = [1,-1/p(2)];

disp(r_1);
disp(new_den1);
disp(r_2);
disp(new_den2);


quantised_r1 = quantizenumeric(r_1,1,word_length,fraction_length);
quantised_r2 = quantizenumeric(r_2,1,word_length,fraction_length);

quantised_denominator1 = quantizenumeric(new_den1,1,word_length,fraction_length);
quantised_denominator2 = quantizenumeric(new_den2,1,word_length,fraction_length);


[h1,f1] = freqz(quantised_r1,quantised_denominator1);
[h2,f2] = freqz(quantised_r2,quantised_denominator2);
[h,f] = freqz(1,denominator);

plot(f1,abs(h1+h2));
hold on;
plot(f,abs(h));
legend(["With Quantisation","Without Quantisation"])


%%
clc;

close all;

[r,p,k] = residue(1,flip(denominator));

r_1 = -r(1)/p(1);
new_den1 = [1,-1/p(1)];
r_2 = -r(2)/p(2);
new_den2 = [1,-1/p(2)];

disp(r_1);
disp(new_den1);
disp(r_2);
disp(new_den2);


quantised_r1 = quantizenumeric(r_1,1,word_length,fraction_length);
quantised_r2 = quantizenumeric(r_2,1,word_length,fraction_length);

quantised_denominator1 = quantizenumeric(new_den1,1,word_length,fraction_length);
quantised_denominator2 = quantizenumeric(new_den2,1,word_length,fraction_length);


[h1,f1] = freqz(quantised_r1,quantised_denominator1);
[h2,f2] = freqz(quantised_r2,quantised_denominator2);
[h,f] = freqz(1,denominator);

plot(f1,abs(h1+h2));
hold on;
plot(f,abs(h));
legend(["With Quantisation","Without Quantisation"])

%%

clc;
clear;
close all;
pole_1 = 1.2532322+j;
pole_2 = -1.2532322-j;

word_length = 6;
fraction_length = 4;

new_pole_1 = quantizenumeric(pole_1,1,word_length,fraction_length);

f1 = [1,-pole_1];
f2 = [1,-pole_2];

denominator = conv(f1,f2);

quantised_f1 = quantizenumeric(f1,1,word_length,fraction_length);

quantised_f2 = quantizenumeric(f2,1,word_length,fraction_length);

[h1,f1] = freqz(1,quantised_f1);
[h2,f2] = freqz(1,quantised_f2);
[h,f] = freqz(1,denominator);

plot(f,abs(h));
hold on;
plot(f1,abs(h1.*h2));
legend(["Without quantisation","With Quantisation"]);

%%
clc;
clear;
close all;


p1 = [1,-0.9];
p2 = [1,-0.9*j];
p3 = [1,+0.9*j];

denominator = conv(p1,p2);
denominator = conv(denominator,p3);

number_of_points = 512;

input_noise_power = 0.5;
input_noise = wgn(1,number_of_points,input_noise_power,'linear');

output_sequence = filter(1,denominator,input_noise);

output_total_autocorrelation = xcorr(output_sequence,output_sequence,'biased');

output_right_half_autocorrelation = output_total_autocorrelation(number_of_points:end);

output_power_spectral_density = fftshift(fft(output_right_half_autocorrelation));
frequency_axis = linspace(-pi,pi,number_of_points);

p = 3;
coefficient_matrix = zeros(p,p);
for row = 1:p
    for column = 1:p
        coefficient_matrix(row,column) = output_right_half_autocorrelation(abs(row-column)+1);
    end
end

c_vector = output_right_half_autocorrelation(2:p+1)';
a_vector = -coefficient_matrix\c_vector;

predicted_variance = output_right_half_autocorrelation(1) + dot(c_vector,a_vector);
disp(predicted_variance);

new_transfer_function = [1 a_vector'];

[h1,f1] = freqz(1,denominator);
[h2,f2] = freqz(1,new_transfer_function);

plot(f1,input_noise_power*abs(h1).^2);
hold on;
plot(f2,predicted_variance*abs(h2).^2);
legend(["Actual","Predicted"]);

disp(new_transfer_function);

%%
close all;
number_of_blocks = 8;
number_of_elements_in_each_block = number_of_points/number_of_blocks;
overlap = 16;

x_matrix = zeros(number_of_blocks,number_of_points);

for row = 1:number_of_blocks
    for column = 1:number_of_elements_in_each_block
        if row == 1
            x_matrix(row,column) = output_right_half_autocorrelation(column+ (row-1)*number_of_elements_in_each_block);
        else
            x_matrix(row,column) = output_right_half_autocorrelation(column+(row-1)*number_of_elements_in_each_block-overlap);
        end
        
    end
end


PSD_matrix = zeros(number_of_blocks,number_of_points);

window = hamming(number_of_elements_in_each_block)';
U = var(window);
window = [window,zeros(1,number_of_points-length(window))];
for i = 1:number_of_blocks
    PSD_matrix(i,:) = abs(fftshift(fft(x_matrix(i,:).*window))).^2/(number_of_elements_in_each_block*U);
end

PSD_mean = mean(PSD_matrix,1);

plot(PSD_mean);




