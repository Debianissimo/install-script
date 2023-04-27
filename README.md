# Installazione di Ordissimo

## Disclaimer

Il progetto Debianissimo è nato per poter consentire a tutti l'utilizzo del software Ordissimo, il quale *dovrebbe* rispettare la Licenza GNU/Linux.

Debianissimo utilizza ed è stato costruito tramite repository pubbliche Debian-based, per questo motivo è del tutto legale.

Debianissimo non è in nessun modo associata o correlata a Ordissimo SA. Tutti i diritti di Ordissimo SA e rispettivi loghi appartengono al legittimo proprietario.

Il team di Debianissimo **non si prende responsabilità per qualsiasi tipo di danno** che possa provocare l'installazione o l'utilizzo del sistema Ordissimo.

---

## Requisiti
- [Debian 9 "stretch"](https://www.debian.org/releases/stretch/debian-installer/) Base per l'installazione di ordissimo, l'immagine da scaricare è la "netinst"
    - [Link diretto per il file .iso della `netinst`](https://cdimage.debian.org/cdimage/archive/9.13.0/amd64/iso-cd/debian-9.13.0-amd64-netinst.iso)
- Internet
- una CPU a 64bit (`AMD64` o `x86_64`), CPU a 32bit (`i386`, `x86`) e ARM non sono supportate
- 2GB di RAM
- Capire come funziona un minimo Debian poiché è necessario editare a mano alcuni file, e potrebbero verificarsi alcuni problemi

## Installazione

Viene altamente scoraggiato l'uso di [Hardware fisico](#--hardware-fisico), quindi si consiglia di utilizzare una macchina virtuale, fatta con VirtualBox. Per maggiori infomazioni controlla il [FAQ](#--software-di-vm)

1. Installare Debian 9
    1. Usare un disco da minimo [64 GB](#--disco)
        - Creare una partizione da minimo 15 GB come primaria di tipo `ext4`, con label `root`, punto di montaggio `/`, e avviabile
        - Creare una partizione da 2 GB come primaria di tipo `linux swap`
            - La partizione swap e opzionale e la si puo fare grante quanto si vuole a patto che resta spazio per il resto delle partizioni
        - Create una partizione da minimo 30 GB come logica di tipo `ext4`, con label `var`, punto di montaggio `/var`
        - Creare una partizione da minimo 1 GB come logica di tipo `ext4`, con label `secours`, punto di montaggio custom `/mnt/secours`
        - Creare una partizione con lo spazio rimanente come logica di tipo `ext4`, con label `home`, punto di montaggio `/home`
    1. Usare come hostname `ordissimo`
    1. Usare come domain name `ordissimo`
    1. Usare come password dell'utente "root" la password `root` o qualcosa che ci si ricorda
    1. Usare come nome utente `ordissimo`
    1. Usare come password `ordissimo`
    1. Durante il setup, l'installer chiederà di configurare il gestore dei pacchetti, una delle domande durante questo passaggio è se si vuole configurare un altro cd, rispondere di no, successivamente sarà chiesto di impostare una nazione da cui impostare i mirror, fare indietro, premere continua se si presenta e un errore, e alla domanda se si vuole continuare __senza__ un mirror di rete rispondere si
        - Questi errori che si presentano vanno sistemati a mano successivamente
    1. Se dovesse chiedere se si vuole installare un "Desktop Enviroment", o "Ambiente desktop", selezionarlo poichè causa problemi con l'installazione di ordissimo, in caso non si presenta la scelta, **NON** e un problema
1. Una volta che si e avviato il sistema ci si trovera nella `tty`, effettuare il login con le credenziali dell'utente root, quindi come username "root" e come password quella inserita precentemente
    1. Usando il editor di testo, nano e vi sono già installati, modificare il file `/etc/apt/souces.list` e fare le seguenti modifiche:
        - Aggiungere un `#` all'inizio delle righe che iniziano con `deb cdrom:[`, se non sono gia presenti
        - Aggiungere una riga con scritto `deb http://archive.debian.org/debian stretch contrib main non-free`
    1. Eseguire `apt update`
1. Scaricare lo script `install.sh`
    - lo si puo scaricare da riga di comando, se non sono installati si possono installare da `apt`
        - curl: `curl https://raw.githubusercontent.com/Debianissimo/install-script/main/install.sh -o install.sh`
        - wget `wget https://raw.githubusercontent.com/Debianissimo/install-script/main/install.sh`
1. Eseguire il comando `chmod +x install.sh` per rendere eseguibile lo script
1. Eseguire lo script `install.sh`, sempre dall'utente root, seguire le istruzioni, e accettare il disclaimer (possibilmente leggendolo prima)
    - Sono richiesti 2 GB di download per l'installazione
    - Se dovesse bloccarsi mentre cerca di connetersi `substantielwww.dyndns.org` e successivamente da un errore provare con questi passaggi:
        1. Spegnere la macchina virtuale
        2. Riavviare il computer, si seriamente
        3. Accendere la macchina virtuale, fare il login come root e ri-eseguire lo script con il parametro `--skip-mirror`, ad esempio il comando diventa `./install.sh --skip-mirror`
        - NOTA: non sappiamo perche questi passaggi sono necessari, pero per ora sembrano funzionare, se si dovessero verificare problemi potete venire su [Telegram](https://t.me/Debianissinauta) e cerchiamo di risolvere il problema
    - Alla domanda sul keymap, rispondere di non toccare la keymap
    - Alle domande per sovrascrivere i file di configurazione rispondere sempre di si
    - Alle domande di `rEFInd` rispondere no
    - Alle domande di `lilo` rispondere `Ok` oppure `Si` in base alle opzioni
1. Aggiungere l'utente `ordissimo` al gruppo `sudo` e impostare la seguente regola, sostituendo quella per `%sudo` presente di default con `%sudo   ALL=(ALL) NOPASSWD:ALL` nel file fornito dal comando `visudo`
    - Per usare nano/vim/micro con `visudo` usare `EDITOR=<editor> visudo`
    - il comando per aggiungere l'utente ordissimo al gruppo sudo è: `usermod -aG sudo ordissimo`
1. Potrebbe essere oppurtuno installare un terminale per poi poter, ad esempio, sistemare la risoluzione dello schermo, per quello controllare il [FAQ](#--cambio-risoluzione)
1. Riavviare, attendere che compaia la scelta della lingua, selezionarne una a scelta, aspettare il riavvio, e fare il login nell'utente
    - La tastiera sarà con il layout AZERTY in automatico, **non** lo si può cambiare in base alle nostre conoscenze, perciò la password sarà: `ordissiòo` (la `ò` sarebbe la `m` in AZERTY)
    - Sarà necessario fare 2 volte il login

---

## FAQ

### - **Cambio Risoluzione**

> **WARNING**:
> Per poter cambiare la risoluzione e necessario aver installato il [terminale](#--installazione-del-terminale) ed avere il sistema in [Read-Write](#--filesystem-read-write)

Per cambiare la risoluzione (ammesso che sei in una VM) fai `sudo nano /etc/X11/xorg.conf` e scrivi questo:

<!-- markdownlint-disable-next-line -->
```
Section "Monitor"
 Identifier "Virtual1"
 Option "PreferredMode" "1360x768"
EndSection
```

Questo cambierà la risoluzione a `1360x768`. Dovrebbe essere evidente come cambiare la risuluzione, in ogni caso basta cambiare la riga dove ce scritto `Option "PreferredMode"` e cambiare `1360x768` con la risoluzione a scelta

### - **Installazione del terminale**

> **Warning**:
> Per poter installare il terminale e necessario avere il sistema in [Read-Write](#--filesystem-read-write)

Il terminale NON è installato by-default su ordissimo, perciò bisogna installarlo a mano, il procedimento cambia in base alla situazione corrente del sistema.

#### - Da sistema pre-riavvio dopo l'esecuzione di install.sh

> **Warning**:
> Questo sistema NON funziona se si e gia effettuato il riavvio dopo aver eseguito lo script di installazione, per installare il terminale in questa situazione fare riferimento alla [sezione sotto](#da-sistema-post-riavvio-dopo-installsh)

1. Eseguire `apt install xfce4-terminal`
1. Editare il file `/usr/share/applications/xfce4-terminal.desktop` e apportare la seguente modifica
    - Trovare la riga con su scritto `Categories=GTK;System;TerminalEmulator;` e aggiungere `OrdissimoDefault;` alla fine di essa
    - Salvare il file
1. Ora quando si riavvia e si fa il setup iniziale di ordissimo, aka lingua, si dovrebbe trovare il terminale tra le applicazioni
    - Per impostare il layout italiano **sul terminale** usare `setxkbmap it`
        - Opzionalmente si puo metterlo nel file `.bashrc`
            - Potrebbe essere necessario impostare di nuovo il systema in [Read-Write](#--filesystem-read-write)

#### - Da sistema post-riavvio dopo install.sh

> **Note**:
> Questo sistema funziona anche pre-riavvio, ma è piu lungo

1. Avviare la iso dell'installazione di Debian 9
1. Andare nel menu avanzato
1. Premere su `Rescue mode`
1. Quando arrivati sul menu che chiede la scelta di una partizione selezionare `/dev/sda1`
    - Se vengono mostrati avvisi, premere su `Yes`
1. Premere su `Execute a shell in /dev/sda1`
    - Se vengono mostrati avvisi, premere su `Continue`
1. Eseguire i segunti comandi comandi per l'installazione:

```sh
mount /dev/sda5 /var
mount /dev/sda7 /home
apt install xfce4-terminal
```

7. Inoltre bisogna editare il file `/usr/share/applications/xfce4-terminal.desktop` e apportare la seguente modifica
    - Trovare la riga con su scritto `Categories=GTK;System;TerminalEmulator;` e aggiungere `OrdissimoDefault;` alla fine di essa
    - Salvare il file
7. Una volta riavviato sul desktop dovrebbe esserci il terminale
    - Per impostare il layout italiano **sul terminale** usare `setxkbmap it`
        - Opzionalmente si puo metterlo nel file `.bashrc`
            - Potrebbe essere necessario impostare di nuovo il systema in [Read-Write](#--filesystem-read-write)

### - **FileSystem Read-Write**

Ordissimo imposta il sistema in readonly (RO) by-default, per qualche motivo a noi ignoto, tuttavia lo si puo impostare Read-Write (RW) in 2 modi

Per controllare se il sistema e stato avviato in RO oppure RW si puo provare a scrivere un file su una directory tipo /usr (usando sudo altrimenti da un permesso negato) oppure facendo `cat /proc/cmdline`, che mostrerà i parametri dati al kernel, tra questi ci dovrebbe essere `ro` o `rw`

#### - Metodo 1, non permanente

Utilizzando il comando seguente da bash e possibile rendere il filesystem in RW, questa modifica pero non e permanente e va rifatta ogni riavvio 

1. Eseguire il comando `for m in $(ls /); do mount -o remount,rw /$m; done`
    - Il comando esegue `ls /`, per ogni file / cartella che trova prova a rimontare la suddetta cartella in r/w, pertanto quanto tenta di montare un file ci sara un errore, questi errori possono essere ignorati e non succede nulla

- Questo metodo da cio che abbiamo notato sembra mettere sempre il sistema in RW senza problemi

#### - Metodo 2, permanente

Editando la configuratione di lilo e possibile fare in modo che LILO non imposti il filesystem come RO al boot, questa modifica viene conservata tra i riavii del sistema

1. Editare il file `/etc/lilo.conf` con le seguenti modifiche
    - Ci saranno 3 `Read-Only` nel file in totale, ogniuna di queste volte che compare questa voce bisogna cambiarla con `Read-Write`
    - Salvare il file
1. Eseguire `sudo lilo`
1. Riavviare
1. Verificare che si possa scrivere

- Questo metodo potrebbe non sembre mettere tutto il sistema in RW per motivazioni a noi sconosciute, quindi ogni tanto potrebbe essere necessario dover fare comunque il metodo non permanente

### - **Errore durante l'installazione**

Se hai seguito tutte le indicazioni in questo file e lo stesso un errore, puoi venire su [Telegram](https://t.me/Debianissinauta) e possiamo provare a vedere se riusciamo a capire il problema e a risolverlo successivamente

Se invence non hai seguito tutta la guida, non hai formattato il disco come e scritto in questa guida allora non e strano che hai degli errori durante l'installazione, ordissimo e un sistema molto delicato da cio che abbiamo potuto osservare

Noi siamo disposti ad aiutarti solo se segui la guida presente in questo file.
 
### - **Aggiornamenti**

Nelle impostazioni di Ordissimo e presente un tasto per aggiornare il sistema, quel tasto e noto per rompere il sistema / non far nulla, quindi e meglio evitare di cliccarlo per quanto inteoria non dovrebbe rompere nulla

Se lo vuoi premere lo stesso ti prendi la responsabilità di ciò e noi non siamo disposti ad aiutarti
 
### - **Dual boot con windows**

Non abbiamo mai provato a fare un dual boot con Ordissimo pero ricordati che Ordissimo viene installato come BIOS non come UEFI in questa guida, perciò potresti aver problemi con il boot di windows, inoltre ordissimo e consigliato che venga installato soltanto in macchina virtuale poiche su hardware fisico da problemi e ci sono parecchi problemi dagli esperimenti che abbiamo fatto

Noi **non** siamo disposti ad aiutarti per il dual boot

### - **Raspepberry PI**

I raspberry pi hanno dei processori di tipo ARM, come gia detto nei requisiti i processori ARM **NON** sono supportati poiche mancano i pacchetti per far funzionare tutto cio che serve, perciò non e possibile installare Ordissimo su questi sistemi

Se vuoi provare lo stesso, noi **NON** siamo disposti ad aiutarti.

### - **Disco**

Il requisito per l'installazione di debianissimo RICHIEDE 64 GB come dimensione del disco virtuale, tuttavia all'atto pratico, se si usa un disco non pre-allocato, la dimensione del disco e di 10.2 GB circa

Partizionare un disco piu piccolo può essere problematico poiche durante l'installazione dei pacchetti ordissimo potrebbe andare out-of-space su alcune delle partizioni necessarie

Se vuoi provare con dischi piu piccoli, noi **NON** siamo disposti ad aiutarti.

### - **Hardware fisico**

Per quanto **__tecnicamente__** possibile non raccomandiamo di farlo poichè causa problemi su problemi, tra impostazioni del BIOS da cambiare e altri problemi con l'installazione in se del sistema Debian e/o Ordissimo

Per questo motivo **NON** consigliamo di farlo

### - **Software di VM**

Noi raccomandiamo l'uso di VirtualBox per l'installazione, poichè e il software che abbiamo usato per testare che tutto funzionasse

VmWare e un altra opzione per fare la macchina virtuale, pero ci sono dei requisiti in più che su VirtualBox non ci sono:

- Il disco usato per l'installazione DEVE essere di tipo `SATA`
    - Se non sai come impostarlo di tipo `SATA` bisogna usare Vmware Workstation Pro con il setup avanzato durante la creazione oppure su Vmware Workstation Player devi rimuovere il disco per poi ri-aggiungerlo come `SATA`, dovrebbe esserci l'opzione nel wizard di aggiunta disco
- Armarsi di TANTA pazienza poichè per motivi a noi sconosiuti a `lilo` non sembra piacere vmware, e quindi durante il boot resta alla schermata di boot anche per **__20 minuti__** 

### - **Guest Addictions**

Le VirtualBox guest addictions o i VmWare tools NON sono necessario per il funzionamento della macchina virtuale, e non sono nemmeno raccomandati da installare per via che non è garantito che funzionino correttamente

Un motivo per cui potresti voler installare le guest addictions o i vmware tools e per la risoluzione dello schermo, ma per questo problema e meglio che si fa a mano controllando il [FAQ corrispondente](#--cambio-risoluzione)
