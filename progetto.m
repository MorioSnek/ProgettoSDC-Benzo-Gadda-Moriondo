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
DensTraffico1 = 10; % densità a cui sono distribuiti i veicoli [veicolo/m]
DensTraffico2 = 50; % densità a cui sono distribuiti i veicoli [veicolo/m]
DistSicurezza = 2.5; % distanza di sicurezza (distanza minima) [Km]

%% System Model

DistTxRxFissa = 50;
% Attenuazione in spazio libero
MediaLoS = 32.4 + 20 * log10(DistTxRxFissa / 10^3) + 20 * log10(Fc / 10^9); % conversione m->Km e Hz->GHz
% Shadowing component
MediaSh = 0;
VarianzaSh = 3;
% Attenuazione da bloccaggio
MediaAtt = 0;
VarianzaAtt = 0;
% Attenuazione complessiva
MediaPathLoss = MediaLoS + MediaAtt;
VarianzaPathLoss = VarianzaSh + VarianzaAtt;
% Modello PathLoss
PathLoss = VarianzaPathLoss * randn(1, 100000) + MediaPathLoss;
SNR = (Pt_dBm - 30) + Gt_dB + Gr_dB - PathLoss - (Pn_dBm - 30);

%% Simulazioni numeriche

histogram(PathLoss, 'BinWidth', 0.5)
xlabel('dB');
ylabel('Occorrenze nella simulazione');
title('Confronto Path Loss e SNR');
hold on
histogram(SNR, 'BinWidth', 0.5)
legend