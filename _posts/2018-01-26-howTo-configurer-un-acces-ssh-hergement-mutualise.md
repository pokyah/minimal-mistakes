---
title: "Configurer un accès SSH à un hébergement mutualisé"
header:
  overlay_image: /assets/images/ssh_access.jpg
  og_image: /assets/images/ssh_access.jpg
  caption: "Photo credit: [**pixabay**](https://pixabay.com)"
  cta_url: "https://pixabay.com"
classes: "wide"
toc: false
toc_label: "Table des matières"
toc_icon: "cog"
categories:
  - howTo
tags:
  - unix
  - web
  - tools
  - ssh
  - standard
---

Disposer d’un d’accès 
[SSH](https://code.tutsplus.com/tutorials/ssh-what-and-how--net-25138) 
vous permet de réellement avoir la main sur votre hébergement mutualisé (qui n’est rien d’autre qu’un accès limité à certains dossiers et programmes stockés sur un serveur tournant généralement sous Linux).  

Grâce à votre accès SSH, vous pourrez notamment y exécuter des commandes  [unix](https://www.tutorialspoint.com/unix/) et  [git](https://confluence.atlassian.com/bitbucketserver/basic-git-commands-776639767.html)  directement depuis le terminal de votre ordinateur personnel. C'est l’outil idéal pour la maintenance de votre site WordPress par exemple !

Avant de vous lancer dans la configuration de votre accès SSH, vérifiez d’abord que votre hébergeur offre cette possibilité. Ce tutoriel a été  élaboré via un hébergement [Infomaniak](https://www.infomaniak.com/)  mais rien ne devrait être fort différent si vous êtes chez un autre hébergeur offrant cette possibilité.

Ce tutoriel est uniquement valable pour les utilisateurs Linux et Mac.  Pour ce qui est de Windows, référez-vous à un autre tutoriel (faites une recherche sur "putty").

### Etape 1 :  Créez un compte d’accès FTP/SSH à votre espace mutualisé.

Via l’interface d’administration de votre hébergeur, créez un compte d’accès FTP/SSH avec mot de passe. Pour Infomaniak, tout est expliqué [ici](https://www.infomaniak.com/fr/support/faq/1982/creermodifiersupprimer-un-compte-ftp-gerer-les-comptesacces-ftp).

### Etape 2 : Créez une clef SSH sur votre ordinateur personnel.

Sur votre ordinateur, ouvrez le terminal (shell) et lancez la commande  de création d’une clef SSH :

```bash
myUserName:~$ ssh -keygen -t dsa
```

Le shell vous demandera dans quel répertoire vous souhaitez enregistrer votre clef. Appuyez simplement sur enter.

```bash
Generating public /private dsa key pair. Enter file in which to save the 
key (/home/clients/randomStringOfNumbersAndLetters/.ssh/id_dsa): Enter 
passphrase (empty for no passphrase):
```

L’invite de commande vous demandera ensuite de créer un mot de passe.  Pensez à un mot de passe facile à taper car vous serez souvent invités à l’entrer :

```bash
Enter passphrase (empty for no passphrase):
```

Le shell vous précisera alors quelle est l’empreinte de votre clef et  son *randomart*. La définition de ces termes barbares sort un peu du contexte de ce tutoriel. Je vous invite à vous documenter par vous-même si vous souhaitez en apprendre un peu plus sur les différentes subtilités sous-jacentes.

```bash
Your identification has been saved in 
/home/clients/myClientIDNumber/.ssh/id_dsa.
Your public key has been saved in 
/home/clients/myClientIDNumber/.ssh/id_dsa.pub. The key fingerprint is: 
xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx uid68541@h2web77 The 
key's randomart image is: +--[ DSA 1024]----+ | | | | | | | | | | | | | 
| | | | | +-----------------+
```

Récupérez la chaine de caractère correspondant à votre clef publique :

```bash
myUserName:~$ cat /Users/myUserName/.ssh/id_rsa.pub
```

Copiez la clef publique que vous fournit le shell. Exemple de clef 
fournie :

```bash
ssh -dss 
AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSUGPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XAt3FaoJoAsncM1Q9x5+3V0Ww68``/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/EnmZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbxNrRFi9wrf+M7Q== myUserName@mycomputer.local
```

Ouvrez un éditeur de texte (Vim, Nano, Emacs, Atom, gedit, etc), collez-y la clef et enregistrez le fichier sous le nom _authorized_keys_ (sans extension).

### Etape 3 : Créez, sur l’hébergement mutualisé, le répertoire dans lequel enregistrer les clefs SSH autorisées

A la racine de votre répertoire, créez un dossier .ssh dans lequel vous uploadez en FTP ou via l’interface en ligne de gestions de fichiers, le fichier _authorized_keys_ fraichement créé sur votre ordinateur personnel.

### Etape 4 : Testez votre connexion SSH

Ca y est, votre ordinateur est maintenant autorisé à accéder en SSH à votre espace partagé. Afin de vous connecter, entrez la commande suivante :

```bash
myComputerName:~ myUserName$ ssh hostFTPSSHlogin@hostServer
```

Remplacez `_hostFTPSSHlogin_` et `_hostServer_` par les infos qui vous sont fournis par votre hébergeur. Chez infomaniak, vous trouverez ces informations dans votre panneau d’administration à la rubrique :

> *Accueil/Domaine & Hébergement/Gestion De sHébergements/mon Nom de 
Domaine/Comptes FT*

Vous serez ensuite invités à entrer votre mot de passe de connection 
FTP/SSH créé à l’étape 1 :

```bash
hostFTPSSHlogin@hostServerName's password:
```

Entrez-le, validez en appuyant sur enter et si tout ce passe bien, vous devriez maintenant être connecté en SSH à votre hébergement mutualisé. Un moyen rapide de voir si votre connection est bien effective, est que votre invite de commande ne commence plus par
```bash
myComputerName:~ myUserName$
```

mais plutôt par  quelque chose ressemblant à ce ceci :

```bash
userName@hostName: /home/clients/randomStringOfNumbersAndLetters $
```

Si c’est le cas, __félicitations__ ! Vous disposez maintenant d’un accès SSH  à votre espace mutualisé. Grâce à cet accès, vous serez par exemple en  mesure de _puller_ les derniers _commits_ du développement de votre site  web hébergés en privé sur Bitbucket. Dans un prochain post, nous verrons d’ailleurs comment configurer un workflow de mise en production et mise  à jour de votre site web à l’aide de git et SSH.

### Etape 5 : Changez les permissions du dossier .ssh et du fichier _authorized_keys_

Pour des raisons de sécurité, réglez les [permissions](http://www.thinkplexx.com/learn/article/unix/command/chmod-permissions-flags-explained-600-0600-700-777-100-etc) de votre dossier .ssh à 700 et celles du fichier _authorized_keys _à 600\. Ces recommandations proviennent d’[Infomaniak](https://www.infomaniak.com/en/support/faq/2054/logging-into-your-hosting-with-an-ssh-key).

Commencez par vous rendre à la racine de votre hébergement mutualisé

```bash
userName@hostName: /home/clients/randomStringOfNumbersAndLetters $ 
cd ~/
```

Réglez la permission de votre répertoire .ssh à 700

```bash
userName@hostName:~/$ chmod 700 .ssh
```

Allez dans le répertoire .ssh contenant le fichier __authorized_keys__

```bash
userName@hostName:~/$ cd .ssh
```

Réglez la permission de votre fichier authorized_keys à 600

```bash
userName@hostName:~/.ssh $ chmod 600 authorized_keys
```

### Etape 6 (en option) : Changez le mot de passe de votre clef SSH

Si à l’usage, vous vous rendez compte que  votre mot de passe est trop 
fastidieux à entrer, vous pouvez le changer voire le supprimer (non recommandé). Pour ce, lorsque vous êtes connectés en SSH à votre espace mutualisé (voir étape 4) , entrez la commande suivante :

```bash
userName@hostName:/home/clients/randomStringOfNumbersAndLetters $ 
ssh -keygen -p
```

Vous serez alors invités à entrer le chemin de destination de votre clef :

```bash
Enter file in which the key is 
(/home/clients/randomStringOfNumbersAndLetters/.ssh/id_rsa):
```

Entrez le chemin suivant :

```bash
/home/clients/randomStringOfNumbersAndLetters/.ssh/id_dsa
```

Vous serez invités à taper l’ancien mot de passe :

```bash
Enter old passphrase:
Key has comment` 
'/home/clients/randomStringOfNumbersAndLetters/.ssh/id_dsa'
```
Entrez-le et validez en tapant enter.

L’invite de commande vous demandera alors d’entrer un nouveau mot de  passe :

```bash
Enter new passphrase (empty for no passphrase):
```

Choisissez votre nouveau mot de passe ou taper simplement enter pour désactiver l’utilisation d’un mot de passe (non recommandé).

Si le fait de devoir entrez un mot de passe trop souvent vous ennuie, 
vous pouvez [créer un __agent__](https://unix.stackexchange.com/questions/12195/how-to-avoid-being-asked-passphrase-each-time-i-push-to-bitbucket) qui le retiendra pour vous lors de la session active.
