
writematrix(["k_f","Noise Level","Average Figure of Merit"],"Withpremephasis_Average.csv");



for k_index = 1:10:length(k_f1)-1
      writematrix([k_f1(k_index),NoiseLevel(k_index),mean(FigureOfMerit(k_index:k_index+9,:))],"Withpremephasis_Average.csv","WriteMode","append");
end