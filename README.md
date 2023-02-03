<!---
geometry: "margin=2.5cm"
--->

# Progetto SDC - A.A. 2022-2023

Progetto di Sistemi di Comunicazione dell'Anno Accademico 2022-2023, relativo alle trasmissioni veicolari. I partecipanti del gruppo sono:

* Matteo Benzo - matteo.benzo@mail.polimi.it
* Alessia Gadda - alessia.gadda@mail.polimi.it
* Luca Moriondo - luca.moriondo@mail.polimi.it

I paper di riferimento per il progetto sono:

- [Performance of DSRC for V2V Communications in urban and highway environments](https://ieeexplore.ieee.org/abstract/document/6335027?casa_token=GUbaLT-9GMEAAAAA:eGuqNF_4uVOJGyble-5WCizXHkKZoeAraOJAwhtuDcCpooBP9ZVR2ZVIxsxmAE9-8kGT2qMl)
- [Vehicular Blockage Modelling and Performance Analysis for mmWave V2V Communications](https://ieeexplore.ieee.org/abstract/document/9838711?casa_token=tCe-ZCrgnSoAAAAA:iDeXXihvhmJ2rYX6IvGF9tHlCz9V_wQgAVnqdavT6jiiOrF05iUKiDT-SnLcFWNhJvwgtpow)

Sono stati usati a supporto del progetto anche i seguenti documenti:

- [Study on evaluation methodology of new vehicle-to-everything](https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=3209)

## Indice
- [Relazione](#relazione)
    1. [Introduzione](#introduzione)
    2. [Parametri e variabili della simulazione](#parametri)
        - [Sistema di comunicazione](#parsdc)
        - [Veicoli](#parveicoli)
        - [Scenario](#parscenario)
        - [Variabili](#parvariabili)
    3. [System Model](#systemmodel)
    4. [Vehicular Blockage Modelling](#blockage)
        - [Analisi Same Lane](#samelane)
        - [Analisi Different Lanes](#differentlane)
        - [Sintesi](#sintesi)
        - [Distribuzione SNR](#snr)
    5. [Numerical Simulations](#numerical)
- [Spiegazione del codice MATLAB](#codice)
    - [File `setup.m`](#matsetup)
    - [File `main.m`](#matmain)
    - [File `plots.m`](#matplots)
- [Risultati](#risultati)
    1. []()

<a name="relazione"></a>

# Relazione 

<a name="introduzione"></a>

## Introduzione
Il progetto ha come scopo la caratterizzazione e la simulazione di una trasmissione veicolare, con l'ausilio di un programma sviluppato in linguaggio MATLAB. In particolare, l'impatto che ha la presenza di un veicolo bloccante sul Signal-To-Noise Ratio relativo alla trasmissione tra due veicoli in uno scenario autostradale.<br>
Si andrà ad analizzare la situazione base, ovvero l’assenza di veicoli bloccanti tra il trasmettitore e il ricevitore sulla medesima corsia stradale, per poi studiare quelle più complesse prodotte dalla combinazione di diversi elementi:

- Uno o più veicoli bloccanti
- La posizione dell’antenna sul veicolo
- La presenza di traffico più o meno intenso
- La presenza di più corsie

<a name="parametri"></a>

## Parametri e variabili della simulazione

<a name="parsdc"></a>

### Sistema di comunicazione 
| Parametro                       | Simbolo |  Valore |
|---------------------------------|:-------:|:-------:|
| Potenza del trasmettitore       | $P_{t}$ |  0 dBm  |
| Guadagno antenna trasmettitore  | $G_{t}$ |  10 dB  |
| Guadagno antenna ricevitore     | $G_{r}$ |  10 dB  |
| Potenza di rumore               | $P_{n}$ | -85 dBm |
| Frequenza della portante        |  $f_c$  |  28 GHz |
| Lunghezza d'onda della portante |  $\lambda_c$  |  0.01 m |

<a name="parveicoli"></a>

### Veicoli 
| Parametro                           |   Simbolo  | Valore |
|-------------------------------------|:----------:|:------:|
| Lunghezza del veicoli               |    $l_v$   |   5 m  |
| Larghezza veicoli                   |    $w_v$   |  1.8 m |
| Altezza media veicoli               |   $\mu_v$  |  1.5 m |
| Deviazione standard altezza veicoli | $\sigma_v$ | 0.08 m |

<a name="parscenario"></a>

### Scenario 
| Parametro                       | Simbolo |     Valore     |
|---------------------------------|:-------:|:--------------:|
| Lunghezza scenario              |   $D$   |      200 m     |
| Numero di corsie                |   $M$   |        3       |
| Larghezza delle corsie          |  $W$    |      3.5 m     |
| Distanza di sicurezza           |  $d_s$  |      2.5 m     |
| Densità di traffico considerate | $\rho$  | 10 / 50 veh/km |

<a name="parvariabili"></a>

### Variabili 
| Parametro                         |  Simbolo |
|-----------------------------------|:--------:|
| Distanza Trasmettitore-Ricevitore | $d_{tr}$ |
| Distanza Trasmettitore-Bloccante  | $d_{tb}$ |
| Distanza Bloccante-Ricevitore     | $d_{br}$ |
| Numero di veicoli bloccanti       | $k$      |

#### Intervalli considerati per le variabili (*singola corsia*):
| Parametro        |       Rooftop      |       Bumper      |
|------------------|:------------------:|:-----------------:|
| $d_{tr}$         |   $7.5 \div 195$   |   $2.5 \div 190$  |
| $d_{tb}, d_{br}$ |  $7.5 \div 187.5$  |    $5 \div 185$   |

#### Intervalli considerati per le variabili (*differenti corsie*):

<a name="systemmodel"></a>

## System Model 
Vengono differenziati due scenari relativi a due modelli di canale:

- *Line-of-Sight* (LoS), ossia il canale in visibilità
- *Non-Line-of-Sight vehicle* (NLoSv), ossia il canale non in visibilità attenuato dalla presenza di veicoli bloccanti

Vengono considerate nell'attenuazione in spazio libero due componenti con distribuzione normale:

- Shadowing component: $\chi\sim \mathcal{N}(0,\sigma_{sh}^2)$
- Attenuazione da bloccaggio: $\mathcal{A}(k)\sim \mathcal{N}(\mu(k),\sigma^2(k))$

Il valore $k\in\mathbb{N}$ rappresenta il numero di veicoli bloccanti nella trasmissione. 
L'attenuazione per il primo veicolo è ottenuta tramite: 
$$9 + \max(0,15\cdot\log_{10}(d_{tb})-41)$$
Pertanto, osservando i risultati del secondo argomento della funzione, nello scenario considerato (200 metri) rimarrà sempre 9dB.<br>
La media dell'attenuazione in spazio libero è calcolata con la formula:
$$\mu_{LoS} = 32.4+20\log_{10}(d_{tr})+20\log_{10}(f_c)$$
da cui deriva quindi la più completa formula che tiene conto dalle attenuazioni introdotte dall'ambiente e dai bloccanti:
$$PL(k) = 32.4+20\log_{10}(d_{tr})+20\log_{10}(f_c) + \mathcal{A}(k) + \chi\ \sim\ \mathcal{N}(\mu_{LoS} + \mu(k), \sigma_{sh}^2) + \sigma^2(k)$$

<a name="blockage"></a>

## Vehicular Blockage Modelling 
La propagazione di un segnale viene ostacolata quando un corpo (nell’ambito di questo progetto, un veicolo) ostruisce il primo ellissoide di Fresnel. Le altezze dei veicoli sono assunte come variabili con distribuzione Gaussiana, con media $\mu_v$ e varianza $\sigma_v$.<br>
Il raggio dipendente dalla lunghezza del primo ellissoide di Fresnel viene calcolato come:
$$\tilde{r} = \sqrt{\lambda_c\frac{d_{tb}\cdot d_{tr}}{d_{tb}+d_{trx}}}\quad\quad \lambda_c=\frac{c}{f_c}$$
Viene inoltre calcolata l'altezza del primo ellissoide di Fresnel, il quale è rappresentabile da una distribuzione Gaussiana:
$$\tilde{h}=h_r\frac{d_{tb}}{d_{tr}}+h_t\frac{d_{br}}{d_{tr}}-0.6\tilde{r}\sim \mathcal{N}(\tilde{\mu},\tilde{\sigma}^2)$$
$$\to \tilde{\mu}=\mu_v-0.6\tilde{r}\quad\quad \tilde{\sigma}^2=\sigma^2_v$$
Per calcolare la probabilità di avere un bloccaggio è necessario definire altezza, media e varianza efficace per il bloccaggio:
$$h_{eff} = h_v-\tilde{h}\quad\quad \mu_{eff}=\mu_v-\tilde{\mu}\quad\quad \sigma^2_{eff}=\sigma_v^2+\tilde{\sigma}^2$$
Stabilito che un bloccaggio avviene nel momento in cui $h_{eff}>0$, possiamo calcolare la probabilità di avere un bloccaggio data la presenza di un veicolo potenzialmente bloccante:
$$\mathbb{P}(\textrm{NLoSv}|d_{tr},\mathcal{B})=Q\left(\frac{h_{eff}-\mu_{eff}}{\sigma_{eff}}\right)$$
La probabilità è dipendente dai parametri della simulazione, quali distanza $d_{tr}$ e densità di automobili $\rho$.<br>
 La probabilità che un veicolo sia su una determinata corsia è $\frac{1}{M}$, dove $M$ è il numero di corsie considerato.

<a name="samelane"></a>

### Analisi Same Lane 
Nel caso in cui trasmettitore, ricevitore e veicolo bloccante siano sulla stessa corsia, dividiamo lo spazio che intercorre tra trasmettitore e ricevitore in $N_s$ slot. Ogni slot è lungo quanto la somma della lunghezza media di un veicolo e la distanza di sicurezza.<br>
$$N_s = \frac{d_{eff}}{d_a} \quad\quad d_{eff} = d_{tr}-l_v \quad\quad d_a = l_v+d_s$$
Viene assegnato per questi slot il nome "tipo A", per distinguerli da quelli presenti nel caso "Different Lane".<br><br>
La probabilità che un singolo slot sia occupato da un bloccante viene calcolata assumendo che i veicoli siano distribuiti secondo un processo di Poisson lineare (o Linear Point Poisson Process):
$$\mathcal{P_\textrm{\textit{a}}} = \mathbb{P}(\textrm{NLoSv}|d_a,\mathcal{B})\cdot \mathbb{P}(\mathcal{B}) = Q\left(\frac{h_{eff}-\mu_{eff}}{\sigma_{eff}}\right)\Gamma e^{-\Gamma}\quad\quad \Gamma = \rho \cdot d_a$$
Viene infine calcolata la probabilità di avere un bloccaggio da parte di $k$ veicoli mediante una distribuzione di Bernoulli:
$$\mathbb{P_\textrm{\textit{SL}}}(\textrm{NLoSv}^{(k)}|d_{tr})={N_s\choose k}\mathcal{P_\textrm{\textit{a}}^\textrm{\textit{k}}}(1-\mathcal{P_\textrm{\textit{a}}})^{N_s-k}$$

<a name="differentlane"></a>

### Analisi Different Lanes 
Analizziamo ora il caso in cui trasmettitore e ricevitore siano su corsie differenti. Analogamente al caso “Same Lane” dividiamo lo spazio che intercorre tra trasmettitore e ricevitore in slot. Essi vengono suddivisi in due tipologie:

- Slot Tipo B: spazio che potrebbe essere occupato da un bloccante sulla stessa corsia di TX o RX;
- Slot Tipo C: spazio che potrebbe essere occupato da un bloccante sulle corsie esistenti tra TX e RX.

Definita $\Delta y$ la distanza tra i punti medi delle corsie di TX e RX, possiamo definire le lunghezze $d_b$ e $d_c$:
$$d_b = \frac{w_v\sqrt{d_{tr}^2-\Delta y^2}}{2\Delta y}\quad\quad d_b = \frac{w_v\sqrt{d_{tr}^2-\Delta y^2}}{\Delta y}+l_v$$
Si calcola la probabilità di avere TX e RX con uno scostamento laterale pari a $\Delta y = nW, \ n\in\{1,2,\ldots,M\}$:
$$\mathbb{P}(\Delta y = n W) = 2\frac{M-n}{M^2}\to \frac{2}{M^2}+\sum_{n=1}^{M-1}n = \frac{M-1}{M}$$
Si calcola inoltre la probabilità di avere $k$ bloccanti su un massimo di $M$ slot, poiché in questo caso si considera che non ci sia più di un veicolo bloccante per corsia:
$$\mathbb{P}(K=k)=\sum_{\mathcal{A}\in\mathcal{Q_\textrm{\textit{k}}}}\prod_{i\in\mathcal{A}}\mathcal{P_\textrm{\textit{i}}}\prod_{j\in\mathcal{A^\textrm{\textit{c}}}}(1-\mathcal{P_\textrm{\textit{j}}})$$
Ottenuti questi risultati numerici, possiamo unire le due formule per ottenere la probabilità di avere un bloccaggio da parte di $k$ veicoli:
$$\mathbb{P_\textrm{\textit{DL}}}(\textrm{NLoSv}^{(k)}|d_{tr}) = \frac{2(M-1)}{M^2}{n+1\choose k}\mathcal{P_\textrm{\textit{b}}^\textrm{\textit{k}}}(1-\mathcal{P_\textrm{\textit{b}}})^{n+1+k}+\sum_{n=2}^{M-1}\frac{2(M-n)}{M^2}\sum_{\mathcal{A}\in\mathcal{Q_\textrm{\textit{k}}}}\prod_{i\in\mathcal{A}}\mathcal{P_i}\prod_{j\in\mathcal{A^\textrm{\textit{c}}}}(1-\mathcal{P_\textrm{\textit{j}}})$$

<a name="sintesi"></a>

### Sintesi 
Sintetizzando il caso "Single Lane" con quello "Different Lanes", possiamo ottenere la probabilità di avere un bloccaggio da parte di $k$ veicoli in un contesto generale:
$$\mathbb{P}(\textrm{NLoSv}^{(k)}|d_{tr}) = \mathbb{P_\textrm{\textit{DL}}}(\textrm{NLoSv}^{(k)}|d_{tr}) + \frac{1}{M}\ \mathbb{P_\textrm{\textit{SL}}}(\textrm{NLoSv}^{(k)}|d_{tr})$$

<a name="snr"></a>

### Distribuzione SNR 
La densità di probabilità del rapporto segnale-rumore viene derivata da quella enunciata nella sezione "System Model". La versione generale è una mistura di distribuzioni Gaussiane, la cui funzione di densità di probabilità (PDF) è data da una media ponderata di funzioni di probabilità:
$$f_\gamma (\gamma|d_{tr}) = \mathbb{P}(\textrm{LoS}|d_{tr})\cdot f_{\gamma^{(0)}}(\gamma|d_{tr})+\sum_{k=1}^B\mathbb{P}(\textrm{NLoSv}^{(k)}|d_{tr})f_{\gamma^{(k)}}(\gamma|d_{tr})$$
$$\mathbb{P}(\textrm{LoS}|d_{tr})=1-\sum_k\mathbb{P}(\textrm{NLoSv}^{(k)}|d_{tr})\quad\quad B=\max(N_s,M)$$

<a name="numerical"></a>

## Numerical Simulations 

<a name="codice"></a>

# Spiegazione codice MATLAB 
Il codice è segmentato in diversi file, con la rispettiva funzione:

- `setup.m`: racchiude tutti i parametri dell'analisi e della simulazione [$\to$](#matsetup)
- `main.m`: comprende tutti i calcoli e gli algoritmi utili alle simulazioni [$\to$](#matmain)
- `plots.m`: fornisce tutte le istruzioni per i vari plot di grafici [$\to$](#matplots)

Per comodità dell'utente, si consiglia di visualizzare il progetto finale attraverso lo script matlab `exec.m`, che contiene dei comandi `run` nell'ordine corretto.<br>

```
>> run exec.m
```
Alternativamente, se non si vuole visualizzare i plot, si consiglia di eseguire nel seguente ordine:
``` 
>> run setup.m
>> run main.m
```

<a name="matsetup"></a>

## File `setup.m` 

```Matlab
clear all, close all, clc
```
Essendo il primo file ad essere eseguito contiene le uniche istruzioni nel progetto di pulizia di precedenti workspace MATLAB.

```Matlab
% parametri sistema di comunicazione
Pt_dBm = 0;
Gt_dB = 10; 
Gr_dB = 10;
Pn_dBm = -85;
Fc = 28 * 10 ^ 9; 
Lambda_c = 3e8 / Fc;

% parametri veicoli
LungVeicolo = 5; 
LargVeicolo = 1.8;
AltVeicoloMedia = 1.5;
AltVeicoloStdv = 0.08;

% parametri scenario analizzato
LungScenario = 200;
NumCorsie = 4;
LarghezzaCorsia = 3.5;
DensTraffico1 = 10;
DensTraffico2 = 50;
DistSicurezza = 2.5;

% attenuazione in spazio libero
MediaLoS = 32.4 + 20 * log10(DistanzaTxRxFissa) + 20 * log10(Fc / 10 ^ 9);
MediaSh = 0;
VarianzaSh = 3 ^ 2;
MediaAtt = 9 + max(0, 15 * log10(DistanzaTxRxFissa / 2) - 41);
VarianzaAtt = 4.5 ^ 2;
```
Integrazione delle tabelle viste nei [punti](#parametri) precedenti, suddivise per tipologia di variabile. Sono state scelte le unità di misura del paper di riferimento.

```Matlab
NumSimulazioni = 10 ^ 5;
DistanzaTxRxFissa = 50;
```
Parametri non definiti nel paper, usati nel progetto per poter effettuare diverse simulazioni. Dove non sarà indicato diversamente, sarà infatti considerata una distanza di 50 metri tra i veicoli.<br>
Il parametro ``NumSimulazioni`` è riferito a quante iterazioni sono state fatte di una determinata estrazione di una variabile gaussiana, relativamente alle distribuzioni normali presenti (SNR, Altezza dell'ellissoide di Fresnel).

<a name="matmain"></a>

## File `main.m`

### System Model

```Matlab
MediaPathLoss = MediaLoS + MediaAtt;
VarianzaPathLoss = VarianzaSh + VarianzaAtt;
```

```Matlab
PathLossLoS = VarianzaSh * randn(1, NumSimulazioni) + MediaLoS;
PathLossNLoSv = VarianzaPathLoss * randn(1, NumSimulazioni) + MediaPathLoss;
```

```Matlab
SNR = Pt_dBm + Gt_dB + Gr_dB - PathLossLoS - Pn_dBm;
SNRNLoSv = Pt_dBm + Gt_dB + Gr_dB - PathLossNLoSv - Pn_dBm;
```

```Matlab
DistanzaTxRxMobile = [DistSicurezza:0.625:LungScenario];
PathLossMobileLoS = 32.4 + 20 * log10(DistanzaTxRxMobile) + 20 * log10(Fc / 10 ^ 9);
SNRMobileLoS = Pt_dBm + Gt_dB + Gr_dB - PathLossMobileLoS - Pn_dBm;
PathLossMobileNLoSv = PathLossMobileLoS + 9 + max(0, 15 * log10(DistanzaTxRxMobile / 2) - 41);
SNRMobileNLoSv = Pt_dBm + Gt_dB + Gr_dB - PathLossMobileNLoSv - Pn_dBm;
```

```Matlab
SimSNRMobileLoS = SNRMobileLoS + randn(1, size(DistanzaTxRxMobile, 2)) * VarianzaSh;
SimSNRMobileNLoSv = SNRMobileNLoSv + randn(1, size(DistanzaTxRxMobile, 2)) * VarianzaPathLoss;
```
### Vehicular Blockage Modelling

```Matlab
LarghezzaTotLane = NumCorsie * LarghezzaCorsia;
LunghezzaSlotA = LungVeicolo + DistSicurezza;
delta_y = zeros(1, NumCorsie);
LunghezzaSlotB = zeros(1, NumCorsie);
LunghezzaSlotC = zeros(1, NumCorsie);
ProbSamelane = 1 / NumCorsie;
NumeroMaxSlot = floor(DistanzaTxRxFissa / LunghezzaSlotA);
```

```Matlab
for i = 2:NumCorsie
    delta_y(i) = (i - 1) * LarghezzaCorsia;
    LunghezzaSlotB(i) = (LargVeicolo * sqrt((DistanzaTxRxFissa ^ 2) -delta_y(i) ^ 2)) / (2 * delta_y(i));
    LunghezzaSlotC(i) = 2 * LunghezzaSlotB(i) + LungVeicolo;
end
```

```Matlab
GammaA = DensTraffico1 * 10 ^ -3 * LunghezzaSlotA;
GammaB = zeros(1, NumCorsie);
GammaC = zeros(1, NumCorsie);
```

```Matlab
for i = 2:NumCorsie
    GammaB(i) = DensTraffico1 * 10 ^ -3 * LunghezzaSlotB(i);
    GammaC(i) = DensTraffico1 * 10 ^ -3 * LunghezzaSlotC(i);
end
```

```Matlab
DistanzaTxB = rand(1, NumSimulazioni) * DistanzaTxRxFissa;
DistanzaBRx = DistanzaTxRxFissa - DistanzaTxB;
RaggioFresnel = sqrt(Lambda_c .* ((DistanzaTxB .* DistanzaBRx) ./ DistanzaTxRxFissa));
AltezzaFresnel = (AltVeicoloStdv ^ 2) * randn(1, NumSimulazioni) + (AltVeicoloMedia - 0.6 * RaggioFresnel);
```

```Matlab
AltezzaBloccante = (AltVeicoloStdv ^ 2) * randn(1, NumSimulazioni) + AltVeicoloMedia;
AltezzaEfficace = AltezzaBloccante - AltezzaFresnel;
MediaEfficace = 0.6 * RaggioFresnel;
DevstdEfficace = sqrt(2 * AltVeicoloStdv ^ 2);
Prob_NLoSv_B = qfunc((AltezzaEfficace - MediaEfficace) / DevstdEfficace);
```

```Matlab
ProbSingleSameLane = Prob_NLoSv_B * GammaA * exp(-GammaA);
ProbSameLane = zeros(NumeroMaxSlot, NumCorsie);
```

```Matlab
for k = 1:NumeroMaxSlot
    ProbSameLane(k) = (factorial(NumeroMaxSlot) / ((factorial(NumeroMaxSlot - k)) * (factorial(k)))) .* (mean(ProbSingleSameLane) .^ k) .* (mean(1 - ProbSingleSameLane) .^ (NumeroMaxSlot - k));
end
```

```Matlab
ProbSingleSlotB = zeros(1, NumCorsie);
ProbSingleSlotC = zeros(1, NumCorsie);
```

```Matlab
for i = 2:NumCorsie
    ProbSingleSlotB(i) = mean(Prob_NLoSv_B) * GammaB(i) * exp(-GammaB(i));
    ProbSingleSlotC(i) = mean(Prob_NLoSv_B) * GammaC(i) * exp(-GammaC(i));
end
```

```Matlab
P14 = zeros(NumeroMaxSlot, NumCorsie);
```

```Matlab
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
```

```Matlab
Binomiale = zeros(2, 2);

for k = 1:2
    n = 1;
    Binomiale(k, 2) = (factorial(n + 1) / ((factorial(n + 1 - k)) * (factorial(k))));
end
```

```Matlab
ProbDiffLane = zeros(NumeroMaxSlot, NumCorsie);
ProbDiffLane_Part1 = zeros(NumeroMaxSlot, NumCorsie);
ProbDiffLane_Part2 = zeros(NumeroMaxSlot, NumCorsie);
```

```Matlab
for k = 1:2
    n = 1;
    ProbDiffLane_Part1(k, n + 1) = ((2 * (NumCorsie - 1)) / (NumCorsie ^ 2)) .* Binomiale(k, 2) .* (ProbSingleSlotB(2)) .^ k .* (1 - ProbSingleSlotB(2)) .^ (n + 1 - k);
end
```

```Matlab
P16 = zeros(1, NumCorsie);

for n = 2:(NumCorsie - 1)
    P16(1, n + 1) = (2 * (NumCorsie - n)) / (NumCorsie ^ 2);

    for r = 1:4
        ProbDiffLane_Part2(r, n + 1) = P16(1, n + 1) .* P14(r, n + 1);
    end

end
```

```Matlab
ProbDiffLane = ProbDiffLane_Part1 + ProbDiffLane_Part2;
ProbTotale = ProbSameLane + ProbDiffLane;
```

### Numerical Simulations

<a name="matplots"></a>

## File `plots.m`
```Matlab
figure(1)
histogram(PathLossLoS, 'BinWidth', 1)
hold on
histogram(PathLossNLoSv, 'BinWidth', 1)
xlabel('dB');
ylabel('Densità di Probabilità');
title('Path loss caso LOS e NLoSv a dtr 50m');
legend('LoS', 'NLoSv')
```

```Matlab
figure(2)
histogram(SNR, 'BinWidth', 1)
hold on
histogram(SNRNLoSv, 'BinWidth', 1)
xlabel('dB');
ylabel('Densità di Probabilità');
title('SNR caso LOS e NLoSv a dtr 50m');
legend('LoS', 'NLoSv')
```

```Matlab
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
```

```Matlab
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
```

<a name="risultati"></a>

# Risultati 
```Matlab

```