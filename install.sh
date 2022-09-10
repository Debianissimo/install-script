#! /usr/bin/env bash

set -e







echo "!! I dati presenti sul disco potrebbero venir cancellati/corrotti, il team di Debianissimo non si prende la responsabilita per nessun tipo di danno !!"
echo ''

echo "!! Questo script NON controlla se il disco e' stato correttamente formattato, se ce un sistema debian 9, se hai una connessione ad internet funzionante,"
echo "    in ogni caso se un requisito per il funzionamento non dovesse essere presente l'installazione MOLTO PROVABILMENTE fallira' !!"
echo ''

echo "Il progetto Debianissimo è nato per poter consentire a tutti l'utilizzo del software Ordissimo, il quale dovrebbe rispettare la Licenza GNU/Linux."
echo " Debianissimo utilizza ed è stato costruito tramite repository pubbliche Debian-based, per questo motivo è del tutto legale."
echo " Debianissimo non è in nessun modo associata o correlata a Ordissimo SA. Tutti i diritti di Ordissimo SA e rispettivi loghi appartengono al legittimo proprietario."
echo ''

while true;
do
    read -p "Vuoi procedere? (y/N) " yn

    case $yn in
        [yY] )
            break;;
        * )
            echo " Quittando l'installazione di ordissimo";
            exit;;
    esac
done

echo " Proseguendo con l'installazione di Ordissimo..."
echo ''

if [ $EUID -ne 0 ]
    then echo "Questo script deve essere eseguito da root"
    echo " impossibile continuare."
    exit
fi

echo "Durante l'installazione potrebbe essere necessario una connessione internet"
echo " E sara' necessario un intervento manuale per installare corettamente il sistema"
echo ''

echo "Abilitando i repository di ordissimo..."
echo ''
sleep 1

echo "deb [arch=amd64] http://substantielwww.dyndns.org sr2018-stable main non-free" >> /etc/apt/sources.list
echo "deb-src http://substantielwww.dyndns.org          sr2018-stable main non-free" >> /etc/apt/sources.list

echo "!! Potresti vedere un errore a proposito di una 'public key', puoi ignorare l'errore !!"
echo ''

sleep 4
# https://askubuntu.com/questions/74345/how-do-i-bypass-ignore-the-gpg-signature-checks-of-apt
apt update -o Acquire::AllowInsecureRepositories=true

echo ''
echo ' Installando le chiavi criptografiche di ordissimo...'
echo ''

sleep 1
apt install apt-ordissimo-common apt-ordissimo-common-keyring apt-ordissimo-sr2018 apt-ordissimo-sr2018-keyring -y --allow-unauthenticated

apt update

echo ''
echo ' Installando il sistema di ordissimo...'
echo "  L'instllazione puo richiedere un po' di tempo..."
echo ''

echo "!! Dopo che il download sara terminato sara' necessario un intervento manuale per installare il sistema, apt chiedera' se mantere delle versioni dei file oppure se sovrascriverle"
echo "    quando chiesto rispondere sempre di installare la versione del mantenitore del pacchetto, e mantenere le opzioni di defaualt alle altre domande !!"

sleep 10

if [ "$1" = "--advanced" ] 
    then while true;
    do
        echo ''
        read -p "Hai selezionato l'installazione avanzata, percio' se vuoi in questo momento puoi mettere su /var/cache/apt/archives i pacchetti se li hai gia' scaricati, premere invio per continuare." yn

        case $yn in
            * )
                break;;
        esac
    done
fi

apt install o-base-debian ssmtp
apt install ordissimo ordissimo-langue-all neofetch

echo ''
echo "L'instllazione di ordissimo e terminata, installando il lilo"

lilo

echo ''
echo "L'instllazione di lilo e terminata."

echo ''
echo "Potrebbe essere necessario fare altre operazioni manuali"
