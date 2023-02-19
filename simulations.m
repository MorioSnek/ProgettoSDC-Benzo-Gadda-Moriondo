%% Simulazione Probabilità di Bloccaggio a distanza variabile

AltBloccanteMedia = 1.5;
DensTraffico = 10;
ProbNLoSDistVar10 = zeros(20, 1);
for j = 4:20
    DistanzaTxRxFissa = j * 10;
    run("main.m")
    ProbNLoSDistVar10(j, 1) = ProbNLoS;
end

DensTraffico = 30;
ProbNLoSDistVar50 = zeros(20, 1);
for j = 4:20
    DistanzaTxRxFissa = j * 10;
    run("main.m")
    ProbNLoSDistVar50(j, 1) = ProbNLoS;
end

% Bumper antenna
AltBloccanteMedia = 0.3;
DensTraffico = 10;
ProbNLoSDistVar10B = zeros(20, 1);
for j = 4:20
    DistanzaTxRxFissa = j * 10;
    run("main.m")
    ProbNLoSDistVar10B(j, 1) = ProbNLoS;
end

DensTraffico = 30;
ProbNLoSDistVar50B = zeros(20, 1);
for j = 4:20
    DistanzaTxRxFissa = j * 10;
    run("main.m")
    ProbNLoSDistVar50B(j, 1) = ProbNLoS;
end

%% Simulazione Probabilità di Bloccaggio a densità di veicoli variabile

DistanzaTxRxFissa = 50;
AltBloccanteMedia = 1.5;
ProbNLoSDensVar = zeros(30, 1);
for j = 1:30
    DensTraffico = j;
    run("main.m")
    ProbNLoSDensVar(j, 1) = ProbNLoS;
end

AltBloccanteMedia = 0.3;
ProbNLoSDensVarB = zeros(30, 1);
for j = 1:30
    DensTraffico = j;
    run("main.m")
    ProbNLoSDensVarB(j, 1) = ProbNLoS;
end

%% Simulazione doppia

AltBloccanteMedia = 1.5;
ProbNLoSDoppia = zeros(20, 30);
for CountDist = 4:20
    DistanzaTxRxFissa = CountDist * 10;
    for CountDens = 1:30
        DensTraffico = CountDens;
        run("main.m")
        ProbNLoSDoppia(CountDist,CountDens) = ProbNLoS;
    end
end

AltBloccanteMedia = 0.3;
ProbNLoSDoppiaB = zeros(20, 30);
for CountDist = 4:20
    DistanzaTxRxFissa = CountDist * 10;
    for CountDens = 1:30
        DensTraffico = CountDens;
        run("main.m")
        ProbNLoSDoppiaB(CountDist,CountDens) = ProbNLoS;
    end
end

%% Simulazioni Parte 3
AltBloccanteMedia = 1.5;
DensTraffico = 20;
DistanzaTxRxFissa = 200;
run("main.m")
Dist200 = ProbTotale;

ProbCum = flip(Dist200);
ProbCum = cumsum(ProbCum);
ProbCum = flip(ProbCum);

%% SNR
Servizio = zeros(20, 30);
for SNRCountDist = 4:20
    DistanzaTxRxFissa = SNRCountDist * 10;
    for SNRCountDens = 1:30
        DensTraffico = SNRCountDens;
        run("main.m")
        Servizio(SNRCountDist,SNRCountDens) = ResServizio;
    end
end

%% SNR Bumper
AltBloccanteMedia = 0.3;
ServizioBumper = zeros(20, 30);
for SNRCountDist = 4:20
    DistanzaTxRxFissa = SNRCountDist * 10;
    for SNRCountDens = 1:30
        DensTraffico = SNRCountDens;
        run("main.m")
        ServizioBumper(SNRCountDist,SNRCountDens) = ResServizio;
    end
end