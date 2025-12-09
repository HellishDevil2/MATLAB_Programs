clc;
clear;
close all;

noise_power = 0.5;
number_of_points = 128;

white_noise = wgn(1,number_of_points,noise_power,'linear');


digital_filter_numerator = 1;
digital_filter_denominator = [1,-0.9,0.81,-0.729];

output = filter(digital_filter_numerator,digital_filter_denominator,white_noise);

[output_autocorrelation,lags] = xcorr(output,number_of_points,'biased');
frequency_axis = linspace(-pi,pi,length(output_autocorrelation));


figure(1);
plot(frequency_axis,abs(fftshift(fft(output_autocorrelation))))
right_half_auto_correlation = output_autocorrelation(number_of_points+1:2*number_of_points+1);
figure(2);
plot(right_half_auto_correlation);

coefficient_length = 3;

coefficient_matrix =zeros(coefficient_length,coefficient_length);

for i = 1:coefficient_length
    for j = 1:coefficient_length
        coefficient_matrix(i,j) = right_half_auto_correlation(abs(i-j)+1);
    end
end
disp(coefficient_matrix);
c = right_half_auto_correlation(:,2:coefficient_length+1)';
disp(c);

a_vector = -coefficient_matrix\c;
disp(a_vector);

expected_variance = right_half_auto_correlation(1) + dot(a_vector,c);
disp(expected_variance);

final_denominator = [1,a_vector'];

figure(3);
[h,w] = freqz(1,final_denominator);
plot(w,abs(h));
[a,b] = freqz(digital_filter_numerator,digital_filter_denominator);
hold on;
plot(b,abs(a));
legend(["Predicted","Actual"]);
hold off;

new_noise = white_noise*(expected_variance.^0.5)/(noise_power.^0.5);

new_output = filter(1,final_denominator,new_noise);

r_xx_0 = xcorr(output,new_output,'normalized');
disp(max(r_xx_0));







