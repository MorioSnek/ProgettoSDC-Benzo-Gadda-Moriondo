% Plot PathLoss LoS e NLoSv a 50m
figure(1)
histogram(PathLossLoS, 'BinWidth', 1)
hold on
histogram(PathLossNLoSv, 'BinWidth', 1)
xlabel('dB');
ylabel('Densit� di Probabilit�');
title('Path loss caso LOS e NLoSv a dtr 50m');
legend('LoS', 'NLoSv')

% Plot SNR LoS e NLoSv a 50m
figure(2)
histogram(SNR, 'BinWidth', 1)
hold on
histogram(SNRNLoSv, 'BinWidth', 1)
xlabel('dB');
ylabel('Densit� di Probabilit�');
title('SNR caso LOS e NLoSv a dtr 50m');
legend('LoS', 'NLoSv')

% Plot SNR e PathLoss a distanza variabile
figure(3)
hold on
grid on
xlabel('Distanza dtr');
ylabel('dB');
title('Path Loss e SNR a distanza variabile');
plot(DistanzaTxRxMobile, PathLossMobileLoS, 'LineWidth', 3);
plot(DistanzaTxRxMobile, PathLossMobileNLoSv, 'LineWidth', 3);
plot(DistanzaTxRxMobile, SNRMobileLoS, 'LineWidth', 3);
plot(DistanzaTxRxMobile, SNRMobileNLoSv, 'LineWidth', 3);
legend('Path loss LoS', 'Path loss NLoSv', 'SNR LoS', 'SNR NLoSv')

% Simulazione numerica distribuzione SNR a 50m LoS e NLoSv
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