# ProgettoSDC-Benzo-Gadda-Moriondo

Progetto di Sistemi di Comunicazione dell'Anno Accademico 2022-2023, relativo alle trasmissioni veicolari. I partecipanti del gruppo sono:

* Matteo Benzo - matteo.benzo@mail.polimi.it
* Alessia Gadda - alessia.gadda@mail.polimi.it
* Luca Moriondo - luca.moriondo@mail.polimi.it

I paper di riferimento per il progetto sono:

- [Performance of DSRC for V2V Communications in urban and highway environments](https://ieeexplore.ieee.org/abstract/document/6335027?casa_token=GUbaLT-9GMEAAAAA:eGuqNF_4uVOJGyble-5WCizXHkKZoeAraOJAwhtuDcCpooBP9ZVR2ZVIxsxmAE9-8kGT2qMl)
- [Vehicular Blockage Modelling and Performance Analysis for mmWave V2V Communications](https://ieeexplore.ieee.org/abstract/document/9838711?casa_token=tCe-ZCrgnSoAAAAA:iDeXXihvhmJ2rYX6IvGF9tHlCz9V_wQgAVnqdavT6jiiOrF05iUKiDT-SnLcFWNhJvwgtpow)

Sono stati usati a supporto del progetto anche i seguenti documenti:
- [Study on evaluation methodology of new vehicle-to-everything](https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=3209)

## Introduzione
Il progetto ha come scopo la caratterizzazione e la simulazione di una trasmissione veicolare. In particolare, l'impatto che ha la presenza di un veicolo bloccante sul Signal-To-Noise Ratio relativo alla trasmissione tra due veicoli in uno scenario autostradale.<br>
Si andrà ad analizzare la situazione base, ovvero l’assenza di veicoli bloccanti tra il trasmettitore e il ricevitore sulla medesima corsia stradale, per poi studiare quelle più complesse prodotte dalla combinazione di diversi elementi:
- Uno o più veicoli bloccanti;
- La posizione dell’antenna sul veicolo;
- La presenza di traffico più o meno intenso;
- La presenza di più corsie.

## Parametri e variabili della simulazione
### Sistema di comunicazione
| Parametro                       | Simbolo |  Valore |
|---------------------------------|:-------:|:-------:|
| Potenza del trasmettitore       | $P_{t}$ |  0 dBm  |
| Guadagno antenna trasmettitore  | $G_{t}$ |  10 dB  |
| Guadagno antenna ricevitore     | $G_{r}$ |  10 dB  |
| Potenza di rumore               | $P_{n}$ | -85 dBm |
| Frequenza della portante        |  $f_c$  |  28 GHz |
| Lunghezza d'onda della portante |  $\lambda_c$  |  0.01 m |

### Veicoli
| Parametro                           |   Simbolo  | Valore |
|-------------------------------------|:----------:|:------:|
| Lunghezza del veicoli               |    $l_v$   |   5 m  |
| Larghezza veicoli                   |    $w_v$   |  1.8 m |
| Altezza media veicoli               |   $\mu_v$  |  1.5 m |
| Deviazione standard altezza veicoli | $\sigma_v$ | 0.08 m |

### Scenario considerato
| Parametro                       | Simbolo |     Valore     |
|---------------------------------|:-------:|:--------------:|
| Lunghezza scenario              |   $D$   |      200 m     |
| Numero di corsie                |   $M$   |        3       |
| Larghezza delle corsie          |  $W$    |      3.5 m     |
| Distanza di sicurezza           |  $d_s$  |      2.5 m     |
| Densità di traffico considerate | $\rho$  | 10 / 50 veh/km |

### Variabili considerate
| Parametro                         |  Simbolo |
|-----------------------------------|:--------:|
| Distanza Trasmettitore-Ricevitore | $d_{tr}$ |
| Distanza Trasmettitore-Bloccante  | $d_{tb}$ |
| Distanza Bloccante-Ricevitore     | $d_{br}$ |
| Numero di veicoli bloccanti       | $k$      |


#### Intervalli considerati per le variabili (*singola corsia*)
| Parametro        | Intervallo Rooftop | Intervallo Bumper |
|------------------|:------------------:|:-----------------:|
| $d_{tr}$         |   $7.5 \div 195$   |   $2.5 \div 190$  |
| $d_{tb}, d_{br}$ |  $7.5 \div 187.5$  |    $5 \div 185$   |

## System Model
Vengono differenziati due scenari relativi a due modelli di canale:
- *Line-of-Sight* (LoS), ossia il canale in visibilità;
- *Non-Line-of-Sight vehicle* (NLoSv), ossia il canale non in visibilità attenuato dalla presenza di veicoli bloccanti.

Vengono considerate nell'attenuazione in spazio libero due componenti con distribuzione normale:
- Shadowing component: $\chi\sim \mathcal{N}(0,\sigma_{sh}^2)$
- Attenuazione da bloccaggio: $\mathcal{A}(k)\sim \mathcal{N}(\mu(k),\sigma^2(k))$

Il valore $k\in\mathbb{N}$ rappresenta il numero di veicoli bloccanti nella trasmissione. 
L'attenuazione per il primo veicolo è ottenuta tramite: 
$$9 + \max(0,15\cdot\log_{10}(d_{tb})-41)$$
Pertanto, osservando i risultati del secondo argomento della funzione, nello scenario considerato (200 metri) rimarrà sempre 9dB.<br>
La formula per l'attenuazione in spazio libero è calcolata con la formula:
$$\mu_{LoS} = 32.4+20\log_{10}(d_{tr})+20\log_{10}(f_c)$$
da cui deriva quindi la più completa formula derivante dalle attenuazioni introdotte dall'ambiente e dai bloccanti:
$$PL(k) = 32.4+20\log_{10}(d_{tr})+20\log_{10}(f_c) + \mathcal{A}(k) + \chi\ \sim\ \mathcal{N}(\mu_{LoS} + \mu(k), \sigma_{sh}^2) + \sigma^2(k)$$

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

### Analisi Same Lane
Nel caso in cui trasmettitore, ricevitore e veicolo bloccante siano sulla stessa corsia, dividiamo lo spazio che intercorre tra trasmettitore e ricevitore in $N_s$ slot. Ogni slot è lungo quanto la somma della lunghezza media di un veicolo e la distanza di sicurezza.<br>
$$N_s = \frac{d_{eff}}{d_a} \quad\quad d_{eff} = d_{tr}-l_v \quad\quad d_a = l_v+d_s$$
Viene assegnato per questi slot il nome "tipo A", per distinguerli da quelli presenti nel caso "Different Lane".<br><br>
La probabilità che un singolo slot sia occupato da un bloccante viene calcolata assumendo che i veicoli siano distribuiti secondo un processo di Poisson lineare (o Linear Point Poisson Process):
$$\mathcal{P_a} = \mathbb{P}(\textrm{NLoSv}|d_a,\mathcal{B})\cdot \mathbb{P}(\mathcal{B}) = Q\left(\frac{h_{eff}-\mu_{eff}}{\sigma_{eff}}\right)\Gamma e^{-\Gamma}\quad\quad \Gamma = \rho \cdot d_a$$
Viene infine calcolata la probabilità di avere un bloccaggio da parte di $k$ veicoli:
$$\mathbb{P}_{\textrm{SL}}(\textrm{NLoSv}^{(k)}|d_{tr})= {N_s \choose k}\mathcal{P_a^k}(1-\mathcal{P_a})^{N_s-k}$$

### Analisi Different Lane

## Numerical Simulations