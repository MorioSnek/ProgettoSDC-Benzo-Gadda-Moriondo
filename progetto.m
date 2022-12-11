clear all, close all, clc

%% Parametri della simulazione

% parametri sistema di comunicazione
Pt_dBm = 0; % potenza trasmettitore [dBm]
Gt_dB = 10; % guadagno antenna trasmettitore [dB]
Gr_dB = 10; % guadagno antenna ricevitore [dB]
Pn_dBm = -85; % potenza del rumore [dBm]
Fc = 28 * 10 ^ 9; % frequenza della portante [Hz]
Lambda_c = 3e8 / Fc; % lunghezza d'onda della portante [m]

% parametri veicoli
LungVeicolo = 5; % lunghezza del veicolo [m]
LargVeicolo = 1.8; % larghezza del veicolo [m]
AltVeicoloMedia = 1.5; % altezza del veicolo [m]
AltVeicoloStdv = 0.08; % deviazione standard delle altezze dei veicoli [m]

% parametri scenario analizzato
LungScenario = 200; % lunghezza dello scenario analizzato [m]
NumCorsie = 3; % numero di corsie considerate nello scenario
DensTraffico = 10; % densità a cui sono distribuiti i veicoli [veicolo/m]
DistSicurezza = 2.5; % distanza di sicurezza (distanza minima) [m]

%% System Model

DistanzaTxRxFissa = 50;
% Attenuazione in spazio libero
MediaLoS = 32.4 + 20 * log10(DistanzaTxRxFissa) + 20 * log10(Fc / 10 ^ 9); % conversione Hz->GHz
% Shadowing component
MediaSh = 0;
VarianzaSh = 3 ^ 2;
% Attenuazione da bloccaggio
MediaAtt = 9 + max(0, 15 * log10(DistanzaTxRxFissa / 2) - 41);
VarianzaAtt = 4.5 ^ 2;
% Attenuazione complessiva
MediaPathLoss = MediaLoS + MediaAtt;
VarianzaPathLoss = VarianzaSh + VarianzaAtt;

% Modello PathLoss
NumSimulazioni = 10 ^ 6;
PathLossLoS = VarianzaSh * randn(1, NumSimulazioni) + MediaLoS; % conversione Hz->GHz
PathLossNLoSv = VarianzaPathLoss * randn(1, NumSimulazioni) + MediaPathLoss;
% Simulazione numerica
figure(1)
histogram(PathLossLoS, 'BinWidth', 1)
hold on
histogram(PathLossNLoSv, 'BinWidth', 1)
xlabel('dB');
ylabel('Densità di Probabilità');
title('Path loss caso LOS e NLoSv a dtr 50m');
legend('LoS', 'NLoSv')

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
title('SNR caso LOS e NLoSv a dtr 50m');
legend('LoS', 'NLoSv')

% Modello PathLoss su distanza
DistanzaTxRxMobile = [DistSicurezza:0.625:LungScenario];
PathLossMobileLoS = 32.4 + 20 * log10(DistanzaTxRxMobile) + 20 * log10(Fc / 10 ^ 9);
SNRMobileLoS = Pt_dBm + Gt_dB + Gr_dB - PathLossMobileLoS - Pn_dBm;
PathLossMobileNLoSv = PathLossMobileLoS + 9 + max(0, 15 * log10(DistanzaTxRxMobile / 2) - 41);
SNRMobileNLoSv = Pt_dBm + Gt_dB + Gr_dB - PathLossMobileNLoSv - Pn_dBm;
% Simulazione numerica
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

% Simulazione vs Analitica SNR su distanza
SimSNRMobileLoS = SNRMobileLoS + randn(1, size(DistanzaTxRxMobile, 2)) * VarianzaSh;
SimSNRMobileNLoSv = SNRMobileNLoSv + randn(1, size(DistanzaTxRxMobile, 2)) * VarianzaPathLoss;
% Simulazione numerica
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

%% Vehicular Blockage Modelling

% Definizione distanze dal bloccante
DistanzaTxB = DistanzaTxRxFissa / 2; % in questo caso collocato a metà tra TX e RX
DistanzaBRx = DistanzaTxB;

% Modellazione primo ellissoide di Fresnel
RaggioFresnel = sqrt(Lambda_c * (DistanzaTxB * DistanzaBRx) / (DistanzaTxB + DistanzaBRx));
AltezzaFresnel = AltVeicoloStdv^2 * randn(1, NumSimulazioni) + (AltVeicoloMedia - 0.6 * RaggioFresnel);

% Probabilità Bloccaggio dato veicolo presente
AltezzaBloccante = AltVeicoloStdv^2 * randn(1,NumSimulazioni) + AltVeicoloMedia;

AltezzaEfficace = AltezzaBloccante - AltezzaFresnel;
MediaEfficace = 0.6 * RaggioFresnel;

% DevstdEfficace = 

Prob_NLoSv_B = qfunc((AltezzaEfficace-MediaEfficace)/DevstdEfficace);