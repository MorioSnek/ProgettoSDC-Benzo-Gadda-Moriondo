clear all, close all, clc

%% Parametri della simulazione

% parametri sistema di comunicazione
Pt_dBm = 0; % potenza trasmettitore [dBm]
Gt_dB = 10; % guadagno antenna trasmettitore [dB]
Gr_dB = 10; % guadagno antenna ricevitore [dB]
Pn_dB = -85; % potenza del rumore [dBm]
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

DistTxRx = [DistSicurezza:0.5:LungScenario]; % array di valori delle distanze considerate per la simulazione [m]
% Attenuazione in spazio libero
MediaLoS = 32.4 + 20 * log10(DistTxRx/10^3) + 20 * log10(Fc/10^9); % converto la distanza in km e la frequenza in GHz
% Shadowing component
MediaSh = 0;
VarianzaSh = 0;
% Attenuazione da bloccaggio
MediaAtt = 0;
VarianzaAtt = 0;
% Attenuazione complessiva
MediaPathLoss = MediaLoS + MediaAtt;
VarianzaPathLoss = VarianzaSh + VarianzaAtt;

% Modellazione ellissoide di Fresnel
LungOnda = (3*10^9)/(28*10^9);