clear all, close all, clc

%% Parametri della simulazione

% parametri sistema di comunicazione
Pt_dBm = 0; % potenza trasmettitore [dBm]
Gt_dB = 10; % guadagno antenna trasmettitore [dB]
Gr_dB = 10; % guadagno antenna ricevitore [dB]
Pn_dBm = -85; % potenza del rumore [dBm]
Fc = 28 * 10^9; % frequenza della portante [Hz]

% parametri veicoli
LungVeicolo = 5; % lunghezza del veicolo [m]
LargVeicolo = 1.8; % larghezza del veicolo [m]
AltVeicolo = 1.5; % altezza del veicolo [m]
AltVeicoloStdv = 0.08; % deviazione standard delle altezze dei veicoli [m]

% parametri scenario analizzato
LungScenario = 200; % lunghezza dello scenario analizzato [m]
NumCorsie = 3; % numero di corsie considerate nello scenario
DensTraffico = 10; % densità a cui sono distribuiti i veicoli [veicolo/m]
DistSicurezza = 2.5; % distanza di sicurezza (distanza minima) [Km]

%% System Model

DistTxRxFissa = 50;
% Attenuazione in spazio libero
MediaLoS = 32.4 + 20 * log10(DistTxRxFissa) + 20 * log10(Fc / 10^9); % conversione Hz->GHz
% Shadowing component
MediaSh = 0;
VarianzaSh = 3^2;
% Attenuazione da bloccaggio
MediaAtt = 9 + max(0, 15 * log10(DistTxRxFissa / 2) - 41);
VarianzaAtt = 4.5^2;
% Attenuazione complessiva
MediaPathLoss = MediaLoS + MediaAtt;
VarianzaPathLoss = VarianzaSh + VarianzaAtt;

% Modello PathLoss
NumSimulazioni = 10^5;
PathLossLoS = VarianzaSh * randn(1, NumSimulazioni) + MediaLoS; % conversione Hz->GHz
PathLossNLoSv = VarianzaPathLoss * randn(1, NumSimulazioni) + MediaPathLoss;
% Simulazione numerica
figure(1)
histogram(PathLossLoS, 'BinWidth', 1)
hold on
histogram(PathLossNLoSv, 'BinWidth', 1)
xlabel('dB');
ylabel('Densità di Probabilità');
title('Path loss caso LOS e NLoSv');
legend('LoS', 'NLoSv')

legend

% Modello SNR
SNR = Pt_dBm + Gt_dB + Gr_dB - PathLossLoS - Pn_dBm;
SNRNLoSv = Pt_dBm + Gt_dB + Gr_dB - PathLossNLoSv - Pn_dBm;
% Simulazione numerica
figure(2)
histogram(SNR, 'BinWidth', 1)
hold on
histogram(SNRNLoSv, 'BinWidth', 1)
xlabel('dB');
ylabel('Densità di Probabilità');
title('SNR caso LOS e NLoSv');
legend('LoS', 'NLoSv')

% Modello PathLoss su distanza
DistanzaTxRxMobile = [DistSicurezza:2.5:LungScenario];
PathLossMobile = 32.4 + 20 * log10(DistanzaTxRxMobile) + 20 * log10(Fc / 10^9);
SNRMobile = Pt_dBm + Gt_dB + Gr_dB - PathLossMobile - Pn_dBm;
PathLossMobileNLoSv = 32.4 + 20 * log10(DistanzaTxRxMobile) + 20 * log10(Fc / 10^9) + 9 + max(0, 15 * log10(DistTxRxFissa / 2) - 41);
SNRMobileNLoSv = Pt_dBm + Gt_dB + Gr_dB - PathLossMobileNLoSv - Pn_dBm;
% Simulazione numerica
figure(3)
plot(DistanzaTxRxMobile, PathLossMobile, 'LineWidth', 3);
hold on
plot(DistanzaTxRxMobile, SNRMobile, 'LineWidth', 3);
hold on
plot(DistanzaTxRxMobile, PathLossMobileNLoSv, 'LineWidth', 3);
hold on
plot(DistanzaTxRxMobile, SNRMobileNLoSv, 'LineWidth', 3);
xlabel('Distanza dr');
ylabel('dB');
title('Path Loss e SNR a distanza variabile');
grid on
legend('Path loss LoS', 'SNR LoS', 'Path loss NLoSv', 'SNR NLoSv')
