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
NumCorsie = 4; % numero di corsie considerate nello scenario
LarghezzaCorsia = 3.5;
DensTraffico1 = 10; % densità a cui sono distribuiti i veicoli [veicolo/km]
DensTraffico2 = 50;
DistSicurezza = 2.5; % distanza di sicurezza (distanza minima) [m]

% Parametri generici simulazione
NumSimulazioni = 10 ^ 5;
DistanzaTxRxFissa = 50;

% Attenuazione in spazio libero
MediaLoS = 32.4 + 20 * log10(DistanzaTxRxFissa) + 20 * log10(Fc / 10 ^ 9); % conversione Hz->GHz
% Shadowing component
MediaSh = 0;
VarianzaSh = 3 ^ 2;
% Attenuazione da bloccaggio
MediaAtt = 9 + max(0, 15 * log10(DistanzaTxRxFissa / 2) - 41);
VarianzaAtt = 4.5 ^ 2;