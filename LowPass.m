close all;

%Lowpass Magnitude Charecterstics

figure(1);


subplot(2,2,1);
plot(FREQ1_GHZ,LOGMAG1);
xlabel("Frequency (GHz)");
ylabel("20Log(|S11|)");
title("Lowpass S11 Amplitude");

subplot(2,2,2);
plot(FREQ1_GHZ,LOGMAG2);
xlabel("Frequency (GHz)");
ylabel("20Log(|S12|)");
title("Lowpass S12 Amplitude");

subplot(2,2,3);
plot(FREQ1_GHZ,LOGMAG3);
xlabel("Frequency (GHz)");
ylabel("20Log(|S21|)");
title("Lowpass S21 Amplitude");

subplot(2,2,4);
plot(FREQ1_GHZ,LOGMAG4);
xlabel("Frequency (GHz)");
ylabel("20Log(|22|)");
title("Lowpass S22 Amplitude");

%BandPass Phase Charecterstics

figure(2);
subplot(2,2,1);
plot(FREQ1_GHZ,PHASE1_DEG);
xlabel("Frequency (GHz)");
ylabel("Phase of S11 in Degrees");
title("Lowpass S11 Phase");

subplot(2,2,2);
plot(FREQ1_GHZ,PHASE2_DEG);
xlabel("Frequency (GHz)");
ylabel("Phase of S12 in Degrees");
title("Lowpass S12 Phase");

subplot(2,2,3);
plot(FREQ1_GHZ,PHASE3_DEG);
xlabel("Frequency (GHz)");
ylabel("Phase of S21 in Degrees");
title("Lowpass S21 Phase");

subplot(2,2,4);
plot(FREQ1_GHZ,PHASE4_DEG);
xlabel("Frequency (GHz)");
ylabel("Phase of S22 in Degrees");
title("Lowpass S22 Phase");

cutoff_frequency = find(max(LOGMAG2)-LOGMAG2>3);
disp(FREQ1_GHZ(cutoff_frequency(1)));

