clc;
clear;
close all;
a = [-10,-8,-6, -4, -2,0,2,4,6,8,10];
b = [60,80,85,80,100,100,100,100,100,100,100];
figure(1)
plot(a,b);
xlabel('SNR');
ylabel('Accuracy');
title('SNR vs Accuracy at N=160');
a = [-10,-8,-6, -4, -2,0,2,4,6,8,10];
b = [30,30,90,95,100,100,100,100,100,100,100];
figure(2)
plot(a,b);
xlabel('SNR');
ylabel('Accuracy');
title('SNR vs Accuracy at N=176');
a = [-10,-8,-6, -4, -2,0,2,4,6,8,10];
b = [65,45,75,95,100,100,100,100,100,100,100];
figure(3)
plot(a,b);
xlabel('SNR');
ylabel('Accuracy');
title('SNR vs Accuracy at N=192');
a = [-10,-8,-6, -4, -2,0,2,4,6,8,10];
b = [35,85,80,95,100,100,100,100,100,100,100];
figure(4)
plot(a,b);
xlabel('SNR');
ylabel('Accuracy');
title('SNR vs Accuracy at N=208');
a = [-10,-8,-6, -4, -2,0,2,4,6,8,10];
b = [30,75,75,90,100,100,100,100,100,100,100];
figure(5)
plot(a,b);
xlabel('SNR');
ylabel('Accuracy');
title('SNR vs Accuracy at N=224');
a = [-10,-8,-6, -4, -2,0,2,4,6,8,10];
b = [30,75,80,90,100,100,100,100,100,100,100];
figure(6)
plot(a,b);
xlabel('SNR');
ylabel('Accuracy');
title('SNR vs Accuracy at N=240');