# RNCP DevOps System Administrator
[Evaluation en cours de Formation ECF8](RNCP_DEVOPS-ECF8.pdf)

#  🛡️ Automatiser Mise en production d’une application - KUBERNETES

## ✅ Mise en place cluster KUBERNETES avec VAGRANT

### ⚙️ Pré-Requis
- Vagrant : Version: 2.4.7
- VirtualBox : Version 7.1.10 platform packages
- Ubuntu/bionic64 : Ubuntu 20.04 64-bit operating system (chargé dans le vagrantfile)

### 🏗️ Création VAGRANTFILE (création de 2 VMs)
- master node
- worker node

### 🏗️ Initialisation KUBERNETES
- Création script kubernetes_install.sh
- Utilisation réseau FLANNEL

## ✅ MISE EN PLACE SCALING APPLICATION NGINX***
1. Mettre en place un pod Nginx
2. Créer un service nodeport tcp avec redirection sur le port 80 (8080:80)
   Vérifier que votre service a bien été créé avec la commande : kubectl get svc
4. Accéder au pod via le navigateur. Vous aurez besoin de l’IP du master:port du pod
   Vous pouvez lire le port avec un : kubectl get pods
6. Créer deux instances de réplica de votre pod
7. Modifier le contenu des pages html des 2 réplicas, vous noterez réplica1 dans la 1ère instance et réplica2 sur la page de la 2ème instance
8. Vérifier en rafraîchissant la page ipmaster:port que le scaling est bien en place
9. Exporter la sortie de la commande : "kubectl describe deploy"
