clc;
clear;
close all;
Noise_Level = -180:1:-170;

FOM = [47.61,47.69,47.65,47.56,47.63,47.66,47.6,47.73,47.75,47.84,47.77];
figure;

plot(Noise_Level,FOM);
ylim([40,50]);
title("FOM vs Input Power Spectral Density for k_f = 500000");
xlabel("Noise Level in dBm/Hz");
ylabel("FOM in dB");

%%
clc;
clear;
close all;
Noise_Level = -180:1:-170;
FOM_em = [47.667,47.617,47.604,47.603,47.687,47.634,47.69,47.66,47.86,47.65,47.77];
figure;
plot(Noise_Level,FOM_em);
ylim([40,50]);
title("FOM vs Input Power Spectral Density for k_f = 500000 after applying pre-emphasis and de-emphasis filters");
xlabel("Noise Level in dBm/Hz");
ylabel("FOM in dB");


%%
k_f = (3:8)*1e5;

FOM_with = [44.4158307202969,46.3094970531418,47.5217770473393,49.1714925884417,50.2039316443595,51.0275875737018];
FOM_without = [44.37,45.81,47.51,48.96,50.199,51.21];

figure;
plot(k_f,FOM_with);
xlabel("k_f values");
ylabel("FOM in dB");
title("FOM plots for with pre-emphasis and de-emphasis filters")
figure
plot(k_f,FOM_without);
xlabel("k_f values");
ylabel("FOM in dB");
title("FOM plots for without pre-emphasis and de-emphasis filters");


