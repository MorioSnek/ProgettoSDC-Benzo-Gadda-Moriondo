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

%% Simulazione numerica probabilità bloccaggio a distanza variabile
figure(5)
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
figure(6)
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
figure(7)
surf(ProbNLoSDoppia)
xlim([1 30])
ylim([4 20])
zlim([0 0.8])
xlabel('Densità veicolare [veh/km]')
ylabel('Distanza d_{tr} [10^1m]')
zlabel('Probabilità di bloccaggio')
title('Probabilità di bloccaggio con densità veicolare e distanza variabili (Rooftop)')

%% Simulazione numerica probabilità bloccaggio a densità e distanza variabile Bumper
figure(8)
surf(ProbNLoSDoppiaB)
xlim([1 30])
ylim([4 20])
zlim([0 0.8])
xlabel('Densità veicolare [veh/km]')
ylabel('Distanza d_{tr} [10^1m]')
zlabel('Probabilità di bloccaggio')
title('Probabilità di bloccaggio con densità veicolare e distanza variabili (Bumper)')

%% Plot della matrice di probabilità a 200 metri
figure(9)
bar(Dist200)
xlim([0.5 4.5])
title('Probabilità di bloccaggio da parte di n bloccanti (d_{tr} 200 = m, \rho = 20 veh/km)')
xlabel('Numero di bloccanti')
ylabel('Probabilità di bloccaggio')
xticks([1 2 3 4])
xticklabels({'k = 1','k = 2','k = 3', 'k=4'})

%% Plot della matrice di probabilità impilato 200 metri
figure(10)
bar(Dist200, 'stacked')
xlim([0.5 4.5])
title('Probabilità di bloccaggio da parte di n bloccanti (d_{tr} 200 = m, \rho = 20 veh/km)')
xlabel('Numero di bloccanti')
ylabel('Probabilità di bloccaggio')
xticks([1 2 3 4])
xticklabels({'k = 1','k = 2','k = 3', 'k=4'})
