function season_mean=PROCESS_RESULT(location)
% 预测未来50年location区域海水温度变化最好、最坏、最可能情况
% 示例: PROCESS_RESULT('Scotland')
n=161:360;
nt=1:360;
nmod1=161:4:360;
nmod2=162:4:360;
nmod3=163:4:360;
nmod4=164:4:360;
fname=['./iac/',location,' (1).xlsx'];
[season_mean,p_mean,G_mean]=PROCESS_FOR_USE(fname);
writematrix([n',p_mean],['./iac/',location,'_TempPredictMean.xlsx']); %海水温度预测的most likely situation
fname=['./iac/',location,' min.xlsx'];
[season_min,p_min,G_min]=PROCESS_FOR_USE(fname);
writematrix([n',p_min],['./iac/',location,'_TempPredictMin.xlsx']); %海水温度预测的best situation
fname=['./iac/',location,' max.xlsx'];
[season_max,p_max,G_max]=PROCESS_FOR_USE(fname);
writematrix([n',p_mean],['./iac/',location,'_TempPredictMax.xlsx']); %海水温度预测的最坏情况
%%
close all
h = figure;
subplot(1,3,1)
xlim([1 360])
ylim([3 17])
hold on
plot(nmod1,season_min(1,:),'r','LineWidth',2)
hold on
plot(nmod2,season_min(2,:),'g','LineWidth',2)
hold on
plot(nmod3,season_min(3,:),'y','LineWidth',2)
hold on
plot(nmod4,season_min(4,:),'m','LineWidth',2)
hold on

plot(nt,[G_min(161:end);p_min],'k');
title('Minimal change')
xlabel('season')
ylabel('seawater tempreature(unit: °C)')
%%
subplot(1,3,2)
xlim([1 360])
ylim([3 17])
hold on
plot(nmod1,season_mean(1,:),'r','LineWidth',2)
hold on
plot(nmod2,season_mean(2,:),'g','LineWidth',2)
hold on
plot(nmod3,season_mean(3,:),'y','LineWidth',2)
hold on
plot(nmod4,season_mean(4,:),'m','LineWidth',2)
hold on

plot(nt,[G_mean(161:end);p_mean],'k');
title(['Most likely change'])
xlabel('season')
ylabel('seawater tempreature(unit: °C)')
%%
subplot(1,3,3)
xlim([1 360])
ylim([3 17])
hold on
plot(nmod1,season_max(1,:),'r','LineWidth',2)
hold on
plot(nmod2,season_max(2,:),'g','LineWidth',2)
hold on
plot(nmod3,season_max(3,:),'y','LineWidth',2)
hold on
plot(nmod4,season_max(4,:),'m','LineWidth',2)
hold on

plot(nt,[G_max(161:end);p_max],'k');
title(['Maximal change'])
xlabel('season')
ylabel('seawater tempreature(unit: °C)')
%%
legend({'1st quarter','2nd quarter','3rd quarter','4th quarter','seawater temperature'},...
    'Location','southeast')
legend('boxoff')
sgt = sgtitle(['Changes in seawater temperature in ',location,' over the next 50 years'],'Color','red');
sgt.FontSize = 20;
