%% Plot PathLoss LoS e NLoSv a 50m
figure(1)
histogram(PathLossLoS, 'BinWidth', 2,'normalization', 'probability')
hold on
histogram(PathLossNLoSv, 'BinWidth', 2,'normalization', 'probability')
xlabel('dB');
ylabel('Densità di Probabilità');
title('Path loss caso LOS e NLoSv a d_{tr} = 50m');
legend('LoS', 'NLoSv')

%% Plot SNR LoS e NLoSv a 50m
figure(2)
histogram(SNR, 'BinWidth', 2,'normalization', 'probability')
hold on
histogram(SNRNLoSv, 'BinWidth', 2,'normalization', 'probability')
xlabel('dB');
ylabel('Densità di Probabilità');
title('SNR caso LOS e NLoSv a d_{tr} = 50m');
legend('LoS', 'NLoSv')

%% Plot SNR e PathLoss a distanza variabile
figure(3)
hold on
grid on
xlabel('Distanza d_{tr}');
ylabel('dB');
title('Path Loss e SNR a distanza variabile');
plot(DistanzaTxRxMobile, PathLossMobileLoS, 'LineWidth', 3);
plot(DistanzaTxRxMobile, PathLossMobileNLoSv, 'LineWidth', 3);
plot(DistanzaTxRxMobile, SNRMobileLoS, 'LineWidth', 3);
plot(DistanzaTxRxMobile, SNRMobileNLoSv, 'LineWidth', 3);
legend('Path Loss LoS', 'Path Loss NLoSv', 'SNR LoS', 'SNR NLoSv')

%% Simulazione numerica distribuzione SNR a 50m LoS e NLoSv
figure(4)
subplot(2, 1, 1)
hold on
grid on
xlim([0 200])
ylim([-10 50])
xlabel('Distanza dtr');
ylabel('dB');
title('Simulazione SNR LoS a distanza variabile');
plot(DistanzaTxRxMobile, SNRMobileLoS, 'LineWidth', 3);
stem(DistanzaTxRxMobile, SimSNRMobileLoS, 'filled', 'LineStyle', 'none');
subplot(2, 1, 2)
hold on
grid on
xlim([0 200])
ylim([-20 40])
xlabel('Distanza dtr');
ylabel('dB');
title('Simulazione SNR NLoSv a distanza variabile');
plot(DistanzaTxRxMobile, SNRMobileNLoSv, 'LineWidth', 3);
stem(DistanzaTxRxMobile, SimSNRMobileNLoSv, 'filled', 'LineStyle', 'none');

%% Plot della matrice di probabilità a 200 metri
figure(5)
bar(Dist200)
xlim([0.5 4.5])
title('Probabilità di bloccaggio da parte di k bloccanti (d_{tr} 200 = m, \rho = 20 veh/km)')
xlabel('Numero di bloccanti')
ylabel('Probabilità di bloccaggio')
xticks([1 2 3 4])
xticklabels({'k = 1','k = 2','k = 3', 'k=4'})
legend('c = 0', 'c = 1', 'c = 2', 'c = 3')

%% Plot della matrice di probabilità impilato 200 metri
figure(6)
bar(Dist200, 'stacked')
xlim([0.5 4.5])
title('Probabilità di bloccaggio da parte di k bloccanti (d_{tr} 200 = m, \rho = 20 veh/km)')
xlabel('Numero di bloccanti')
ylabel('Probabilità di bloccaggio')
xticks([1 2 3 4])
xticklabels({'k = 1','k = 2','k = 3', 'k=4'})
legend('c = 0', 'c = 1', 'c = 2', 'c = 3')

%% Plot della matrice di probabilità impilato 200 metri cumulata
figure(7)
bar(ProbCum,'stacked')
title('Probabilità di bloccaggio da parte di almeno k bloccanti (d_{tr} 200 = m, \rho = 20 veh/km)')
xlabel('Numero di bloccanti')
ylabel('Probabilità di bloccaggio')
xlim([0.5 4.5])
xticks([1 2 3 4])
xticklabels({'k \geq 1','k \geq 2','k \geq 3', 'k \geq 4'})
legend('c = 0', 'c = 1', 'c = 2', 'c = 3')

%% Simulazione numerica probabilità bloccaggio a distanza variabile
figure(8)
hold on
grid on
xlim([4 20])
ylim([0.1 0.9])
xlabel('Distanza d_{tr} [10^1m]')
ylabel('Probabilità di bloccaggio')
title('Probabilità di bloccaggio a distanza variabile')
% Rooftop antenna
stem(ProbNLoSDistVar10,'filled','LineStyle','none','color','#0072BD')
plot(ProbNLoSDistVar10,'color','#0072BD')
stem(ProbNLoSDistVar50,'filled','LineStyle','none','color','#0072BD')
plot(ProbNLoSDistVar50,'color','#0072BD')

% Bumper antenna
stem(ProbNLoSDistVar10B,'filled','LineStyle','none','color','#A2142F')
plot(ProbNLoSDistVar10B,'color','#A2142F')
stem(ProbNLoSDistVar50B,'filled','LineStyle','none','color','#A2142F')
plot(ProbNLoSDistVar50B,'color','#A2142F')

%% Simulazione numerica probabilità bloccaggio a densità variabile
figure(9)
hold on
grid on
xlim([1 30])
ylim([0 0.7])
xlabel('Densità veicolare [veh/km]')
ylabel('Probabilità di bloccaggio')
title('Probabilità di bloccaggio a densità veicolare variabile')
% Rooftop antenna
stem(ProbNLoSDensVar,'filled','LineStyle','none','color','#0072BD')
plot(ProbNLoSDensVar,'color','#0072BD')
stem(ProbNLoSDensVarB,'filled','LineStyle','none','color','#A2142F')
plot(ProbNLoSDensVarB,'color','#A2142F')

%% Simulazione numerica probabilità bloccaggio a densità e distanza variabile
figure(10)
surf(ProbNLoSDoppia)
xlim([1 30])
ylim([4 20])
zlim([0 0.8])
xlabel('Densità veicolare [veh/km]')
ylabel('Distanza d_{tr} [10^1m]')
zlabel('Probabilità di bloccaggio')
title('Probabilità di bloccaggio con densità veicolare e distanza variabili (Rooftop)')
colorbar('eastoutside')

%% Simulazione numerica probabilità bloccaggio a densità e distanza variabile Bumper
figure(11)
surf(ProbNLoSDoppiaB)
xlim([1 30])
ylim([4 20])
zlim([0 0.8])
xlabel('Densità veicolare [veh/km]')
ylabel('Distanza d_{tr} [10^1m]')
zlabel('Probabilità di bloccaggio')
title('Probabilità di bloccaggio con densità veicolare e distanza variabili (Bumper)')
colorbar('eastoutside')

%% Simulazione numerica probabilità di servizio a densità variabile e distanza variabile
figure(12)
surf(Servizio)
set(gca,'XDir','rev','YDir','rev')
xlabel('Densità veicolare [veh/km]')
ylabel('Distanza d_{tr} [10^1m]')
zlabel('Probabilità di servizio')
title('Probabilità di servizio con densità veicolare e distanza variabili (Rooftop)')
xlim([1 30])
ylim([4 20])
zlim([0.5 1])
colorbar('eastoutside')

%% Simulazione numerica probabilità di servizio a densità variabile e distanza variabile (Bumper)
figure(13)
surf(ServizioBumper)
set(gca,'XDir','rev','YDir','rev')
xlabel('Densità veicolare [veh/km]')
ylabel('Distanza d_{tr} [10^1m]')
zlabel('Probabilità di servizio')
title('Probabilità di servizio con densità veicolare e distanza variabili (Bumper)')
xlim([1 30])
ylim([4 20])
zlim([0.5 1])
colorbar('eastoutside')
