figure(1);
plot(NoiseLevel,AverageFigureOfMerit);
ylim([3400,3500]);
xlabel("Noise Level (dBm)");
ylabel("Figure of Merit")
title("Figure of Merit v/s Noise Level without pre-emphasis and de-emphasis filter");


figure(2);
plot(NoiseLevel1,AverageFigureOfMerit1);
xlabel("Noise Level (dBm)");
ylabel("Figure of Merit");
ylim([5200,5300]);
title("Figure of Merit v/s Noise Level with pre-emphasis and de-emphasis filter");
