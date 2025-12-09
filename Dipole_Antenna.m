close all;

%Dipole_Antenna Magnitude Charecterstics

figure(1);


subplot(2,2,1);
plot(FREQ1_GHZ,LOGMAG1);
xlabel("Frequency (GHz)");
ylabel("20Log(|S11|)");
title("Dipole Antenna S11 Amplitude");

subplot(2,2,2);
plot(FREQ1_GHZ,LOGMAG2);
xlabel("Frequency (GHz)");
ylabel("20Log(|S12|)");
title("Dipole Antenna S12 Amplitude");

subplot(2,2,3);
plot(FREQ1_GHZ,LOGMAG3);
xlabel("Frequency (GHz)");
ylabel("20Log(|S21|)");
title("Dipole Antenna S21 Amplitude");

subplot(2,2,4);
plot(FREQ1_GHZ,LOGMAG4);
xlabel("Frequency (GHz)");
ylabel("20Log(|22|)");
title("Dipole Antenna S22 Amplitude");

%BandPass Phase Charecterstics

figure(2);
subplot(2,2,1);
plot(FREQ1_GHZ,PHASE1_DEG);
xlabel("Frequency (GHz)");
ylabel("Phase of S11 in Degrees");
title("Dipole Antenna S11 Phase");

subplot(2,2,2);
plot(FREQ1_GHZ,PHASE2_DEG);
xlabel("Frequency (GHz)");
ylabel("Phase of S12 in Degrees");
title("Dipole Antenna S12 Phase");

subplot(2,2,3);
plot(FREQ1_GHZ,PHASE3_DEG);
xlabel("Frequency (GHz)");
ylabel("Phase of S21 in Degrees");
title("Dipole Antenna S21 Phase");

subplot(2,2,4);
plot(FREQ1_GHZ,PHASE4_DEG);
xlabel("Frequency (GHz)");
ylabel("Phase of S22 in Degrees");
title("Dipole Antenna S22 Phase");

frequency = find(LOGMAG1-min(LOGMAG1)<=10);
disp(FREQ1_GHZ(frequency));
