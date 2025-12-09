
writematrix(["k_f","Noise Level","Average Figure of Merit"],"Withoutpremephasis_Average.csv");



for k_index = 1:10:length(k_f)-1
      writematrix([k_f(k_index),NoiseLevel(k_index),mean(FigureOfMerit(k_index:k_index+9,:))],"Withoutpremephasis_Average.csv","WriteMode","append");
end