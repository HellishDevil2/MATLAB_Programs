figure(1)
x_axis = [3e5,4e5,5e5,7e5,8e5];
y_axis_no_pre = [1433,3135,3474,9528,10543] ;
y_axis_pre = [1029,4016,5233,10539,13960];

plot(x_axis,y_axis_no_pre);
hold on;
plot(x_axis,y_axis_pre);
hold off;
legend(["No Preemphasis Filter","Preemphasis Filter"]);
xlabel("K_F Value");
ylabel("FOM");
xlim([3.5,8]*1e5);
title("k_f v/s Figure of Merit plot with and without pre-emphasis and de-emphasis filter")

