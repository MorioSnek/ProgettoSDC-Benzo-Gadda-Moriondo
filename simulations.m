%% Simulazione Probabilità di Bloccaggio a distanza variabile

AltBloccanteMedia = 1.5;
DensTraffico = 10;
ProbNLoSDistVar10 = zeros(20, 1);
for j = 1:20
    DistanzaTxRxFissa = (j + 3) * 10;
    run("main.m")
    ProbNLoSDistVar10(j, 1) = ProbNLoS;
end

DensTraffico = 20;
ProbNLoSDistVar50 = zeros(20, 1);
for j = 1:20
    DistanzaTxRxFissa = (j + 3) * 10;
    run("main.m")
    ProbNLoSDistVar50(j, 1) = ProbNLoS;
end

% Bumper antenna
AltBloccanteMedia = 0.3;
DensTraffico = 10;
ProbNLoSDistVar10B = zeros(20, 1);
for j = 1:20
    DistanzaTxRxFissa = (j + 3) * 10;
    run("main.m")
    ProbNLoSDistVar10B(j, 1) = ProbNLoS;
end

DensTraffico = 20;
ProbNLoSDistVar50B = zeros(20, 1);
for j = 1:20
    DistanzaTxRxFissa = (j+3) * 10;
    run("main.m")
    ProbNLoSDistVar50B(j, 1) = ProbNLoS;
end

ProbNLoSDistVar10 = ProbNLoSDistVar10/2;
ProbNLoSDistVar50 = ProbNLoSDistVar50/2;
ProbNLoSDistVar10B = ProbNLoSDistVar10B/2;
ProbNLoSDistVar50B = ProbNLoSDistVar50B/2;

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

ProbNLoSDensVar = ProbNLoSDensVar/2;
ProbNLoSDensVarB = ProbNLoSDensVarB/2;

%% Simulazione doppia

AltBloccanteMedia = 1.5;
ProbNLoSDoppia = zeros(20, 30);
for CountDist = 1:20
    DistanzaTxRxFissa = (CountDist + 3) * 10;
    for CountDens = 1:30
        DensTraffico = CountDens;
        run("main.m")
        ProbNLoSDoppia(CountDist,CountDens) = ProbNLoS;
    end
end
ProbNLoSDoppia = ProbNLoSDoppia/2;