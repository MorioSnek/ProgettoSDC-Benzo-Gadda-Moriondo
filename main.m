%% System Model

% Attenuazione complessiva
MediaPathLoss = MediaLoS + MediaAtt;
VarianzaPathLoss = VarianzaSh + VarianzaAtt;

% Modello PathLoss
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
delta_y = zeros(1, NumCorsie);
LunghezzaSlotB = zeros(1, NumCorsie); % Lunghezza degli slot di tipo B
LunghezzaSlotC = zeros(1, NumCorsie); % Lunghezza degli slot di tipo C
ProbSamelane = 1 / NumCorsie;
NumeroMaxSlot = floor(DistanzaTxRxFissa / LunghezzaSlotA);
% definizione distanza orizzontale veicoli
for i = 2:NumCorsie
    delta_y(i) = (i - 1) * LarghezzaCorsia;
    LunghezzaSlotB(i) = (LargVeicolo * sqrt((DistanzaTxRxFissa ^ 2) -delta_y(i) ^ 2)) / (2 * delta_y(i));
    LunghezzaSlotC(i) = 2 * LunghezzaSlotB(i) + LungVeicolo;
end

% Variaibli PPP
GammaA = DensTraffico1 * 10 ^ -3 * LunghezzaSlotA;
GammaB = zeros(1, NumCorsie);
GammaC = zeros(1, NumCorsie);

for i = 2:NumCorsie
    GammaB(i) = DensTraffico1 * 10 ^ -3 * LunghezzaSlotB(i);
    GammaC(i) = DensTraffico1 * 10 ^ -3 * LunghezzaSlotC(i);
end

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
ProbSingleSameLane = Prob_NLoSv_B * GammaA * exp(-GammaA);
ProbSameLane = zeros(NumeroMaxSlot, NumCorsie);

for k = 1:NumeroMaxSlot
    ProbSameLane(k) = (factorial(NumeroMaxSlot) / ((factorial(NumeroMaxSlot - k)) * (factorial(k)))) .* (mean(ProbSingleSameLane) .^ k) .* (mean(1 - ProbSingleSameLane) .^ (NumeroMaxSlot - k));
end

% Probabilità Different Lanes
ProbSingleSlotB = zeros(1, NumCorsie); %prob. che uno slot sia occupato da un bloccante caso B
ProbSingleSlotC = zeros(1, NumCorsie); %prob. che uno slot sia occupato da un bloccante caso C

for i = 2:NumCorsie
    ProbSingleSlotB(i) = mean(Prob_NLoSv_B) * GammaB(i) * exp(-GammaB(i));
    ProbSingleSlotC(i) = mean(Prob_NLoSv_B) * GammaC(i) * exp(-GammaC(i));
end

P14 = zeros(NumeroMaxSlot, NumCorsie);

for NumCorsie = 2:4

    for k = 1:NumCorsie

        if NumCorsie == 2 && k == 1
            P_M2k1_a = ProbSingleSlotB(2) .* (1 - ProbSingleSlotB(2)); %{1}
            P_M2k1_b = (1 - ProbSingleSlotB(2)) .* ProbSingleSlotB(2); %{2}
            P14(1, 2) = (P_M2k1_a + P_M2k1_b);

        elseif NumCorsie == 2 && k == 2
            P14(2, 2) = ProbSingleSlotB(2) .* ProbSingleSlotB(2); %{1,2}

        elseif NumCorsie == 3 && k == 1
            P_M3k1_a = ProbSingleSlotB(3) .* (1 - ProbSingleSlotC(3)) .* (1 - ProbSingleSlotB(3)); %{1}
            P_M3k1_b = (1 - ProbSingleSlotB(3)) .* ProbSingleSlotC(3) .* (1 - ProbSingleSlotB(3)); %{2}
            P_M3k1_c = (1 - ProbSingleSlotB(3)) .* (1 - ProbSingleSlotC(3)) .* ProbSingleSlotB(3); %{3}
            P14(1, 3) = (P_M3k1_a + P_M3k1_b + P_M3k1_c);

        elseif NumCorsie == 3 && k == 2
            P_M3k2_a = ProbSingleSlotB(3) .* ProbSingleSlotC(3) .* (1 - ProbSingleSlotB(3)); %{1,2}
            P_M3k2_b = ProbSingleSlotB(3) .* ProbSingleSlotC(3) .* (1 - ProbSingleSlotB(3)); %{2,3}
            P_M3k2_c = ProbSingleSlotB(3) .* (1 - ProbSingleSlotC(3)) .* ProbSingleSlotB(3); %{1,3}
            P14(2, 3) = (P_M3k2_a + P_M3k2_b + P_M3k2_c);

        elseif NumCorsie == 3 && k == 3
            P14(3, 3) = ProbSingleSlotB(3) .* ProbSingleSlotC(3) .* ProbSingleSlotB(3); %{1,2,3}

        elseif NumCorsie == 4 && k == 1
            P_M4k1_a = ProbSingleSlotB(4) .* (1 - ProbSingleSlotC(4)) .* (1 - ProbSingleSlotC(4)) .* (1 - ProbSingleSlotB(4)); %{1}
            P_M4k1_b = (1 - ProbSingleSlotB(4)) .* ProbSingleSlotC(4) .* (1 - ProbSingleSlotC(4)) .* (1 - ProbSingleSlotB(4)); %{2}
            P_M4k1_c = (1 - ProbSingleSlotB(4)) .* (1 - ProbSingleSlotC(4)) .* ProbSingleSlotC(4) .* (1 - ProbSingleSlotB(4)); %{3}
            P_M4k1_d = (1 - ProbSingleSlotB(4)) .* (1 - ProbSingleSlotC(4)) .* (1 - ProbSingleSlotC(4)) .* ProbSingleSlotB(4); %{4}
            P14(1, 4) = (P_M4k1_a + P_M4k1_b + P_M4k1_c + P_M4k1_d);

        elseif NumCorsie == 4 && k == 2
            P_M4k2_a = ProbSingleSlotB(4) .* ProbSingleSlotC(4) .* (1 - ProbSingleSlotC(4)) .* (1 - ProbSingleSlotB(4)); %{1,2}
            P_M4k2_b = ProbSingleSlotB(4) .* (1 - ProbSingleSlotC(4)) .* ProbSingleSlotC(4) .* (1 - ProbSingleSlotB(4)); %{1,3}
            P_M4k2_c = ProbSingleSlotB(4) .* (1 - ProbSingleSlotC(4)) .* (1 - ProbSingleSlotC(4)) .* ProbSingleSlotB(4); %{1,4}
            P_M4k2_d = (1 - ProbSingleSlotB(4)) .* ProbSingleSlotC(4) .* ProbSingleSlotC(4) .* (1 - ProbSingleSlotB(4)); %{2,3}
            P_M4k2_e = (1 - ProbSingleSlotB(4)) .* ProbSingleSlotC(4) .* (1 - ProbSingleSlotC(4)) .* ProbSingleSlotB(4); %{2,4}
            P_M4k2_f = (1 - ProbSingleSlotB(4)) .* (1 - ProbSingleSlotC(4)) .* ProbSingleSlotC(4) .* ProbSingleSlotB(4); %{3,4}
            P14(2, 4) = (P_M4k2_a + P_M4k2_b + P_M4k2_c + P_M4k2_d + P_M4k2_e + P_M4k2_f);

        elseif NumCorsie == 4 && k == 3
            P_M4k3_a = ProbSingleSlotB(4) .* ProbSingleSlotC(4) .* ProbSingleSlotC(4) .* (1 - ProbSingleSlotB(4)); %{1,2,3}
            P_M4k3_b = ProbSingleSlotB(4) .* ProbSingleSlotC(4) .* (1 - ProbSingleSlotC(4)) .* ProbSingleSlotB(4); %{1,2,4}
            P_M4k3_c = ProbSingleSlotB(4) .* (1 - ProbSingleSlotC(4)) .* ProbSingleSlotC(4) .* ProbSingleSlotB(4); %{1,3,4}
            P_M4k3_d = (1 - ProbSingleSlotB(4)) .* ProbSingleSlotC(4) .* ProbSingleSlotC(4) .* ProbSingleSlotB(4); %{2,3,4}
            P14(3, 4) = (P_M4k3_a + P_M4k3_b + P_M4k3_c + P_M4k3_d);

        elseif NumCorsie == 4 && k == 4
            P14(4, 4) = ProbSingleSlotB(4) .* ProbSingleSlotC(4) .* ProbSingleSlotC(4) .* ProbSingleSlotB(4); %{1,2,3,4}
        end

    end

end

Binomiale = zeros(2, 2);

for k = 1:2
    n = 1;
    Binomiale(k, 2) = (factorial(n + 1) / ((factorial(n + 1 - k)) * (factorial(k))));
end

%FORMULA 18
ProbDiffLane = zeros(NumeroMaxSlot, NumCorsie);
ProbDiffLane_Part1 = zeros(NumeroMaxSlot, NumCorsie);
ProbDiffLane_Part2 = zeros(NumeroMaxSlot, NumCorsie);

for k = 1:2
    n = 1;
    ProbDiffLane_Part1(k, n + 1) = ((2 * (NumCorsie - 1)) / (NumCorsie ^ 2)) .* Binomiale(k, 2) .* (ProbSingleSlotB(2)) .^ k .* (1 - ProbSingleSlotB(2)) .^ (n + 1 - k);
end

P16 = zeros(1, NumCorsie);

for n = 2:(NumCorsie - 1)
    P16(1, n + 1) = (2 * (NumCorsie - n)) / (NumCorsie ^ 2);

    for r = 1:4
        ProbDiffLane_Part2(r, n + 1) = P16(1, n + 1) .* P14(r, n + 1);
    end

end

ProbDiffLane = ProbDiffLane_Part1 + ProbDiffLane_Part2;
ProbTotale = ProbSameLane + ProbDiffLane;