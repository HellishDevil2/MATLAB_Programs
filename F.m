
%plot(InputPower_dBm_,Vdc_V_*1000);
%plot(Vdc_V_,I_A_);
plot(InputPower_dBm_,Vpp_V_*1000);

yscale log;


%plot(InputPower_W_,Vdc_V_);

%%
plot(InputPower_dBm_,Vdc_V_*1000);

yscale log;

%%
A = [0.005 0.006 0.016 0.031];
B = [0.000140291 0.130271301 0.169386977 0.190387445];
plot(A,B);