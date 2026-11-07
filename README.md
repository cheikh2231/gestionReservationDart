#  Application de Gestion de Restaurant (PRBD)

Application  développée pour simplifier la prise de réservations et la gestion quotidienne d'un établissement. Ce projet intègre une architecture multi-rôles sécurisée séparant l'expérience client des outils d'administration.

##  Fonctionnalités principales

** Espace Client :**
* Recherche et consultation des restaurants disponibles.
* Système de prise de réservation.
* Système d'édition d'une réservation en respectant les créneaux et service pour un restaurant.

** Espace Manager :**
* Tableau de bord de gestion de l'établissement.
* Modifier les services de son restaurant.
* Gérer l'association des tables pour les restaurants.

##  Stack Technique
* **Framework :** Flutter
* **Langage :** Dart
* **Architecture :** Multiplateforme (Mobile/Web)

## 📸 Aperçu
** Espace Client :**
Mes réservations =>
*Tableau de bord avec filtres dynamiques (En attente, Confirmées, Terminées, Annulées).*
  <img width="800" alt=" les reservations en attentes " src="https://github.com/user-attachments/assets/dc6ecfe6-8769-4b64-b32c-298e0620007e" />

  <img width="800" alt=" les reservations confirmées" src="https://github.com/user-attachments/assets/c5ca5194-b7d0-4233-9de6-449b1112a636" />

 Nouvelle réservation =>
*Recherche de restaurants par nom ou description et affichage des détails restaurant selectionné*
  <img width="800" alt="recherche par nom,description" src="https://github.com/user-attachments/assets/3e6c88b4-6b6d-4ca3-994c-ce2e9c58cda8" />

  <img width="800" alt="détails restaurant et réservation d'une table" src="https://github.com/user-attachments/assets/82d8f9b9-a1a1-4c93-a71c-d60b9dcab7f3" />


Nouvelle réservation =>
*Formulaire avec sélection de créneau et validation des demandes spéciales.*
 <img width="800" alt="image" src="https://github.com/user-attachments/assets/33ff2998-139e-480a-a79f-77e90c999b19" />


Après création =>
*La liste des réservations en attentes de l'utilisateur se met automatiquement à jour après l'ajout*   
  <img width="800" alt="liste des reservations en attentes mise à jour" src="https://github.com/user-attachments/assets/5bb6d760-800b-4002-bc9f-31a18fca046a"     />

Edit réservation =>
*Un bouton pour edit les éléments de la réservation (date,heure,etc...) et un bouton d'annulation*   
  <img width="800" alt="modification ou annulation d'une reservation" src="https://github.com/user-attachments/assets/8925af32-898c-4c70-ae5f-94ceaec5c7a8" />

Annulation de la reservation =>
*Aprés annulation le statut change directement dans les details mais aussi dans la liste principale *   
  <img width="1000" alt="details" src="https://github.com/user-attachments/assets/f53cdee0-157d-4fee-892d-b9f4b0704cca" />
  <img width="1000"  alt="liste" src="https://github.com/user-attachments/assets/6069637c-c81c-4942-989d-f1faa2674e23" />



## ⚙️ Installation locale
1. Cloner le dépôt : `git clone https://github.com/cheikh2231/gestionReservationDart.git`
2. Installer les dépendances : `flutter pub get`
3. Lancer l'application : `flutter run`
