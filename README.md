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
| Parametro                      | Simbolo |  Valore |
|--------------------------------|:-------:|:-------:|
| Potenza del trasmettitore      | $P_{t}$ |  0 dBm  |
| Guadagno antenna trasmettitore | $G_{t}$ |  10 dB  |
| Guadagno antenna ricevitore    | $G_{r}$ |  10 dB  |
| Potenza di rumore              | $P_{n}$ | -85 dBm |
| Frequenza della portante       |  $f_c$  |  28 GHz |

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

### 

## System Model
Vengono differenziati due scenari relativi a due modelli di canale:
- *Line-of-Sight* (LoS), ossia il canale in visibilità;
- *Non-Line-of-Sight vehicle* (NLoSv), ossia il canale non in visibilità attenuato dalla presenza di veicoli bloccanti.

Vengono considerate nell'attenuazione in spazio libero due componenti con distribuzione normale:
- Shadowing component: $\chi\sim \mathcal{N}(0,\sigma_{sh}^2)$
- Attenuazione da bloccaggio: $\mathcal{A}(k)\sim \mathcal{N}(\mu(k),\sigma^2(k))$

Il valore $k\in\mathbb{N}$ rappresenta il numero di veicoli bloccanti nella trasmissione. 
L'attenuazione per il primo veicolo è ottenuta tramite: 
$$ 9 + \textrm{max}(0,15\cdot\log_{10}(d_{tb})-41) $$
Pertanto, osservando i risultati del secondo argomento della funzione, nello scenario considerato (200 metri) rimarrà sempre 9dB.<br>
La formula per l'attenuazione in spazio libero è calcolata con la formula:
$$\mu_{LoS} = 32.4+20\log_{10}(d_{tr})+20\log_{10}(f_c)$$
da cui deriva quindi la più completa formula derivante dalle attenuazioni introdotte dall'ambiente e dai bloccanti:
$$ PL(k) = 32.4+20\log_{10}(d_{tr})+20\log_{10}(f_c) + \mathcal{A}(k) + \chi\ \sim\ \mathcal{N}(\mu_{LoS} + \mu(k), \sigma_{sh}^2) + \sigma^2(k) $$