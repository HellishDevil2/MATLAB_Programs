%Creating a unit impulse response
clc;
clear;
close all;
n = -20:120;
impulse_input= n==0;
numerator = [1];
denominator = [1,-1,0.9];

impulse_response = filter(numerator,denominator,impulse_input);
stem(impulse_response,'Filled','markersize',4);
grid on;

z = roots(denominator);

grid off;
compassplot(z);
