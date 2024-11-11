
# Script pour sécuriser les entrées de GRUB

## Explication de pourquoi le faire :

Dans le **GRUB** (le bootloader), nous avons une option de modification des entrées en faisant 'E' au moment de choisir l'entrée voulue pour booter. Par la suite, sur la ligne Linux, à la fin, il y a 'ro quiet'. Si vous changez cela par 'rw init=/bin/bash' puis que vous sortez de là en faisant soit 'CTRL+X' ou 'F10', cela vous lancera une interface ligne de commande qui vous donnera un accès ROOT à la machine.

Donc, afin d'endiguer cette faille présente sur pas mal de PC qui utilisent GRUB ou GRUB2, voici un script (le .sh du repo) qui permettra de paramétrer un utilisateur et un mot de passe pour les entrées GRUB.

Afin d'empêcher les malveillants de jouer avec mon système, je mets donc un mot de passe dans le fichier `/etc/grub.d/40_custom`.

Pour ce faire, je dois avoir un mot de passe chiffré pour GRUB, j'utilise donc :

```bash
sudo grub-mkpasswd-pbkdf2
```

Cela me demande un mot de passe que je vais entrer, puis lorsqu'il va me le redemander, je vais le réécrire et j'aurai un mot de passe chiffré. Maintenant, je vais garder uniquement cette partie : 

```bash
grub.pbkdf2.sha512.10000.1DF8F1F08BFD6BC5C17A6614578472011EFACC41495710840AC894448EFB951A0A549A838E9B9BF92F4FAB078DE47352C43B19849AC88B3B42FC0A9EB64B9A92.FEE7E740B6173510A2241E84E99183BDDCF34B15C23BC82852027BF8DA52DB0D581C5FB8ACFD0A952C179564BCCAD75C4CA56B0E04176E7685FEA9A371BAE8E6
```

Maintenant, je fais un :

```bash
sudo update-grub
```

Maintenant, je vais changer une ligne du fichier `/boot/grub/grub.cfg` afin d'utiliser de manière normale les OS.

Pour ce faire, dans le `/boot/grub/grub.cfg`, je vais rajouter '--unrestricted' à la ligne d'appel des `menuentry` de chaque OS géré par GRUB qui doit se lancer normalement (pour ce script Debian/GNU Linux et Windows Boot Manager). Cela afin de permettre une utilisation normale des OS.

Maintenant, vous avez un GRUB (je pense) mieux protégé. Après, si vous voulez encore plus de sécurité, ne faites pas l'étape du `grub.cfg` et votre GRUB sera hermétique.

LE MOT DE PASSE MIS DANS LE `grub.d/40_custom` DOIT ÊTRE RETENU, AUCUN BYPASS N'EST POSSIBLE SI VOUS L'OUBLIEZ !!!

