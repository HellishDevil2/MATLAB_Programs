clc;
clear;
close all;
N = 32;
wp1 = 0.3;
wp2 = 0.5;
wp3 = 0.65;
wp4 = 0.75;
ws1 = 0.25;
ws2 = 0.55;
ws3 = 0.62;
ws4 = 0.8;
magnitude = [0.1,0.6,0.017,1,0.056];
A = [0.25*pi, 0.1 *pi, 0.035*pi,0.05*pi, 0.1*pi];
B = [0,0.4*pi,0.585*pi,0.7*pi,0.9*pi];
function output = compute(n,A,B,magnitude)
  if n==0
      n=1e-7;
  end
  output = 2*magnitude*sin(n*A) * cos(B*n)/(n*pi);
end


h_n = zeros(1,N);
for i = -N/2 : N/2 - 1 
    for j = 1:5
        h_n(i+N/2+1) =  h_n(i+N/2+1) + compute(i,A(j),B(j),magnitude(j));

    end
end
kaiser_window = kaiser(N,2.5)';
kaiser_window_h_n = kaiser_window.*h_n;
freqz(kaiser_window_h_n,1);
title("Kaiser Window");