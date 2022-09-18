# Installazione di Ordissimo

## Disclaimer

Il progetto Debianissimo è nato per poter consentire a tutti l'utilizzo del software Ordissimo, il quale *dovrebbe* rispettare la Licenza GNU/Linux.

Debianissimo utilizza ed è stato costruito tramite repository pubbliche Debian-based, per questo motivo è del tutto legale.

Debianissimo non è in nessun modo associata o correlata a Ordissimo SA. Tutti i diritti di Ordissimo SA e rispettivi loghi appartengono al legittimo proprietario.

Il team di Debianissimo **non si prende responsabilità per qualsiasi tipo di danno** che possa provocare l'installazione o l'utilizzo del sistema Ordissimo.

---

## Requisiti
- [Debian 9 "stretch"](https://www.debian.org/releases/stretch/debian-installer/) Base per l'installazione di ordissimo
- Internet
- una CPU a 64bit (`AMD64` o `x86_64`), CPU a 32bit (`i386`, `x86`) e ARM non sono supportate
- 2GB di RAM
- Capire come funziona un minimo Debian poiché è necessario editare a mano alcuni file, e potrebbero verificarsi alcuni problemi

## Installazione

# Viene altamente scoraggiato l'uso di Hardware vero, quindi si consiglia di utilizzare una macchina virtuale, fatta con VirtualBox.



1. Installare Debian 9
    1. Usare un disco da minimo 64 GB
        - Creare una partizione da minimo 15 GB di tipo tipo `ext4`, con label `root`, punto di montaggio `/`, e avviabile
        - Creare una partizione da 2 GB (opzionale, grandezza variabile) di tipo `linux swap`
        - Create una partizione da minimo 30 GB come logica di tipo `ext4`, con label `var`, punto di montaggio `/var`
        - Creare una partizione da minimo 1 GB come logica di tipo `ext4`, con label `secours`, punto di montaggio custom `/mnt/secours`
        - Creare una partizione con lo spazio rimanente come logica di tipo `ext4`, con label `home`, punto di montaggio `/home`
    1. Usare come hostname `ordissimo`
    1. Usare come domain name `ordissimo`
    1. Usare come nome utente `ordissimo`
    1. Usare come password `ordissimo`
1. Scaricare lo script `install.sh`
    - lo si puo scaricare da riga di comando, se non sono installati si possono installare da `apt`
        - curl: `curl https://raw.githubusercontent.com/Debianissimo/install-script/main/install.sh -o install.sh`
        - wget `wget https://raw.githubusercontent.com/Debianissimo/install-script/main/install.sh`
1. Eseguire il comando `chmod +x install.sh` per rendere eseguibile lo script
1. Eseguire lo script `install.sh` come root
    - Alla domanda sul keymap, rispondere di non toccare la keymap
    - Alle domande per sovrascrivere i file di configurazione rispondere sempre di si
    - Alle domande di `rEFInd` rispondere no
    - Alle domande di `lilo` rispondere `Ok` oppure si in base alle opzioni
1. Seguire le istruzioni, e accettare il disclaimer
    - Sono richiesti 2 GB di download per l'installazione
1. Aggiungere l'utente `ordissimo` al gruppo `sudo` e impostare la seguente regola, sostituendo quella per `%sudo` presente di default con `%sudo   ALL=(ALL) NOPASSWD:ALL` nel file fornito dal comando `visudo`
    - per usare nano/vim/micro con `visudo` usare `EDITOR=<editor> visudo`
1. Riavviare, attendere che compaia la scelta della lingua, selezionarne una a scelta, aspettare il riavvio, e fare il login nell'utente
    - La tastiera sarà con il layout AZERTY in automatico, **non** lo si può cambiare in base alle nostre conoscenze, perciò la password sarà: `ordissiòo` (la `ò` sarebbe la `m` in AZERTY)
    - Sarà necessario fare 2 volte il login

## Installazione di un terminale

Non e presente un terminale by-default su ordissimo, però è installabile seguendo le istruzioni qui sotto.

1. Avviare la iso dell'installazione di Debian 9
1. Andare nel menu avanzato
1. Premere su `Rescue mode`
1. Quando arrivati sul menu che chiede la scelta di una partizione selezionare `/dev/sda1`
    - Se vengono mostrati avvisi, premere su `Yes`
1. Premere su `Execute a shell in /dev/sda1`
    - Se vengono mostrati avvisi, premere su `Continue`
1. Eseguire i comandi:

```sh
mount /dev/sda5 /var
mount /dev/sda7 /home
apt install xfce4-terminal

# Si puo usare l'editor a scelta, se non e installato si puo installare con apt
# Bisogna trovare la riga che dice
#  Categories=GTK;System;TerminalEmulator;
#  e aggiungere dopo "TerminalEmulator;" la categoria "OrdissimoDefault"
nano /usr/share/applications/xfce4-terminal.desktop
```

<!-- purtroppo non posso mettere un code block su una lista quindi mi tocca fare cosi -->

<!-- markdownlint-disable-next-line -->
7. salvare e uscire dal editor di testo, fare exit e riavviare
<!-- markdownlint-disable-next-line -->
8. Una volta riavviato sul desktop dovrebbe esserci il terminale
    - Per impostare il layout italiano **sul terminale** usare `setxkbmap it`
        - Opzionalmente si puo metterlo nel file `.bashrc`
    - Se mostrato un errore perché il filesystem è Read-Only guarda [**FileSystem Read-Write**](#filesystem-read-write)

## FileSystem Read-Write

Dato che ordissimo mette il sistema readonly (ro) by-default per qualche motivo lo si può rimettere Read/Write (r/w) in 2 modi principali.

Per controllare se il sistema e stato avviato in ro o r/w un modo e provare a scrivere su una directory tipo /usr (da sudo), oppure facendo `cat /proc/cmdline` che mostrerà i parametri del kernel in cui c'è o `ro` o `rw`.

Eseguire un comando ogni volta tramite bash oppure modificare la configurazione del bootloader (lilo)

### Metodo 1 (non permanente):
- eseguire `for m in $(ls /); do mount -o remount,rw /$m; done`
  - Il comando esegue `ls /`,
  per ogni file / cartella che trova prova a rimontare la suddetta cartella in r/w, pertanto quanto tenta di montare un file ci sara un errore

### Metodo 2 (permanente):
1. Prendere un text editor (nano/vim/micro/ecc) ed aprire il file `/etc/lilo.conf`
1. Ci saranno 3 `Read-Only` nel file in totale, vanno cambiati tutti e 3 con `Read-Write`
1. Salvare ed uscire
1. Eseguire `sudo lilo`
1. Riavviare
1. Verificare che si possa scrivere

Se avete usato GRUB o qualsiasi altro bootloader ci sono 2 possibilità, il sistema sia gia r/w oppure ci siano dei parametri per metterlo ro, provate a controllare il file di configurazione del bootloader che state usando.

---

## FAQ

> Non ho seguito tutta la guida / non ho formattato il disco come scritto nella guida e adesso ho un problema

Se non hai seguito la guida penso che è quello che ti meriti.

Puoi provare a reinstallare seguendo le istruzioni.

> Voglio tenere Windows e Ordissimo in dual boot

Non abbiamo mai provato a fare un dual boot con Ordissimo pero ricordati che Ordissimo viene installato come BIOS non come UEFI in questa guida, perciò potresti aver problemi

In ogni caso noi **NON** siamo disposti ad aiutarti.

> Ho un raspberry pi e voglio installare Ordissimo

Ordissimo non fornisce tutti i pacchetti per installare Ordissimo su ARM, e i processori dei raspberry pi sono di tipo ARM, quindi non è possibile installare Ordissimo su questi sistemi.

Se vuoi provare lo stesso, noi **NON** siamo disposti ad aiutarti.

> Non ho abbastanza spazio per una VM con un disco da 64 GB

Il disco deve essere da 64 GB per problemi riscontrati con dischi piu piccoli, tuttavia alla fine il peso del disco dopo l'installazione è di circa 11/12 GB.

Se vuoi provare con dischi piu piccoli, noi **NON** siamo disposti ad aiutarti.

> Usare Hardware vero per installare ordissimo

**Non** consigliamo di farlo.

> VMware

VMware può essere usato per installare Ordissimo, tuttavia...

- Viene **richiesto** l'uso di un disco `SATA`
- Quando si installa Ordissimo che usa il BootLoader `lilo` il boot può richiedere anche **20 minuti** di minimo

> Guest addictions / VMware tools

I guest additions o i vmware tools NON sono necessari e non sono raccomandati, poiché non è garantito che funzionino.

L'unico problema è che la risoluzione dello schermo è un po impazzita.

Per cambiare risoluzione puoi usare guardare la FAQ per la risoluzione dello schermo

> Risoluzione dello schermo

Per cambiare la risoluzione (ammesso che sei in una VM) fai sudo nano /etc/X11/xorg.conf e scrivi questo:

<!-- markdownlint-disable-next-line -->
```
Section "Monitor"
 Identifier "Virtual1"
 Option "PreferredMode" "1360x768"
EndSection
```

Questo cambierà la risoluzione a 1360x768. Credo sia evidente come cambiarla a una di tuo piacimento.
