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
LarghezzaCorsia = 3.5;
DensTraffico1 = 10; % densità a cui sono distribuiti i veicoli [veicolo/km]
DensTraffico2 = 50;
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
NumSimulazioni = 10 ^ 5;
PathLossLoS = VarianzaSh * randn(1, NumSimulazioni) + MediaLoS; % conversione Hz->GHz
PathLossNLoSv = VarianzaPathLoss * randn(1, NumSimulazioni) + MediaPathLoss;

% Modello SNR
SNR = Pt_dBm + Gt_dB + Gr_dB - PathLossLoS - Pn_dBm;
SNRNLoSv = Pt_dBm + Gt_dB + Gr_dB - PathLossNLoSv - Pn_dBm;

% Modello PathLoss su distanza
DistanzaTxRxMobile = [DistSicurezza:0.625:LungScenario];
PathLossMobileLoS = 32.4 + 20 * log10(DistanzaTxRxMobile) + 20 * log10(Fc / 10 ^ 9);
SNRMobileLoS = Pt_dBm + Gt_dB + Gr_dB - PathLossMobileLoS - Pn_dBm;
PathLossMobileNLoSv = PathLossMobileLoS + 9 + max(0, 15 * log10(DistanzaTxRxMobile / 2) - 41);
SNRMobileNLoSv = Pt_dBm + Gt_dB + Gr_dB - PathLossMobileNLoSv - Pn_dBm;

% Simulazione vs Analitica SNR su distanza
SimSNRMobileLoS = SNRMobileLoS + randn(1, size(DistanzaTxRxMobile, 2)) * VarianzaSh;
SimSNRMobileNLoSv = SNRMobileNLoSv + randn(1, size(DistanzaTxRxMobile, 2)) * VarianzaPathLoss;

%% Vehicular Blockage Modelling

% Setup slot
LarghezzaTotLane = NumCorsie * LarghezzaCorsia;
LunghezzaSlotA = LungVeicolo + DistSicurezza; % Lunghezza degli slot di tipo A
LunghezzaSlotB = (LargVeicolo * sqrt(DistanzaTxRxFissa ^ 2) -LarghezzaTotLane ^ 2) / (2 * LarghezzaTotLane); % Lunghezza degli slot di tipo B
LunghezzaSlotC = 2 * LunghezzaSlotB + LungVeicolo; % Lunghezza degli slot di tipo C
ProbSamelane = 1 / NumCorsie;
ProbDifflane = 1 - ProbSamelane;
NumeroMaxSlot = floor(DistanzaTxRxFissa / LunghezzaSlotA);
% Variaibli PPP
GammaA = DensTraffico1 * 10 ^ -3 * LunghezzaSlotA;
GammaB = DensTraffico1 * 10 ^ -3 * LunghezzaSlotB;
GammaC = DensTraffico1 * 10 ^ -3 * LunghezzaSlotC;

% Definizione distanze dal bloccante
DistanzaTxB = rand(1, NumSimulazioni) * DistanzaTxRxFissa; % collocato in una posizione casuale tra TX e RX
DistanzaBRx = DistanzaTxRxFissa - DistanzaTxB;
% Modellazione primo ellissoide di Fresnel
RaggioFresnel = sqrt(Lambda_c .* ((DistanzaTxB .* DistanzaBRx) ./ DistanzaTxRxFissa));
AltezzaFresnel = (AltVeicoloStdv ^ 2) * randn(1, NumSimulazioni) + (AltVeicoloMedia - 0.6 * RaggioFresnel);

% Probabilità Bloccaggio dato veicolo presente
AltezzaBloccante = (AltVeicoloStdv ^ 2) * randn(1, NumSimulazioni) + AltVeicoloMedia;
AltezzaEfficace = AltezzaBloccante - AltezzaFresnel;
MediaEfficace = 0.6 * RaggioFresnel;
DevstdEfficace = sqrt(2 * AltVeicoloStdv ^ 2);
Prob_NLoSv_B = qfunc((AltezzaEfficace - MediaEfficace) / DevstdEfficace);

% Probabilità Same Lane
k = 3;
ProbSingleSameLane = Prob_NLoSv_B * GammaA * exp(-GammaA);
ProbMultiSameLane = (factorial(NumeroMaxSlot) / (factorial(NumeroMaxSlot - k) .* factorial(k))) .* ProbSingleSameLane .^ k .* (1-ProbSingleSameLane).^(NumeroMaxSlot-k);
