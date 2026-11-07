# 🍽️ Application de Gestion de Restaurant (Dart | Flutter)

Application développée pour simplifier la prise de réservations et la gestion quotidienne d'un établissement. Ce projet intègre une architecture multi-rôles sécurisée séparant l'expérience client des outils d'administration.

## 🚀 Fonctionnalités principales

**👤 Espace Client :**
- Recherche et consultation des restaurants disponibles.
- Système de prise de réservation.
- Système d'édition d'une réservation en respectant les créneaux et services du restaurant.

**👨‍💼 Espace Manager :**
- Tableau de bord de gestion de l'établissement.
- Modification des services du restaurant.
- Gestion et assignation des tables.

## 🛠️ Stack Technique
- **Framework :** Flutter
- **Langage :** Dart
- **Architecture :** Multiplateforme (Mobile/Web)

## 📸 Aperçu

### Espace Client

*Tableau de bord avec filtres dynamiques (En attente, Confirmées, Terminées, Annulées).*
| Réservations en attente | Réservations confirmées |
| :---: | :---: |
| <img width="400" alt="Les réservations en attente" src="https://github.com/user-attachments/assets/dc6ecfe6-8769-4b64-b32c-298e0620007e" /> | <img width="400" alt="Les réservations confirmées" src="https://github.com/user-attachments/assets/c5ca5194-b7d0-4233-9de6-449b1112a636" /> |

*Recherche de restaurants et détails du restaurant sélectionné.*
| Recherche (Nom/Description) | Détails et réservation |
| :---: | :---: |
| <img width="400" alt="Recherche par nom, description" src="https://github.com/user-attachments/assets/3e6c88b4-6b6d-4ca3-994c-ce2e9c58cda8" /> | <img width="400" alt="Détails restaurant" src="https://github.com/user-attachments/assets/82d8f9b9-a1a1-4c93-a71c-d60b9dcab7f3" /> |

*Formulaire de réservation et mise à jour de la liste après création.*
| Formulaire de création | Liste mise à jour automatiquement |
| :---: | :---: |
| <img width="400" alt="Formulaire" src="https://github.com/user-attachments/assets/33ff2998-139e-480a-a79f-77e90c999b19" /> | <img width="400" alt="Liste mise à jour" src="https://github.com/user-attachments/assets/5bb6d760-800b-4002-bc9f-31a18fca046a" /> |

*Modification ou annulation avec mise à jour immédiate du statut.*
| Édition de la réservation | Statut après annulation |
| :---: | :---: |
| <img width="400" alt="Modification" src="https://github.com/user-attachments/assets/8925af32-898c-4c70-ae5f-94ceaec5c7a8" /> | <img width="400" alt="Statut annulé" src="https://github.com/user-attachments/assets/f53cdee0-157d-4fee-892d-b9f4b0704cca" /> |

---

### Espace Manager

*Tableau de bord des restaurants gérés et affichage des réservations.*
| Liste des restaurants | Réservations du restaurant |
| :---: | :---: |
| <img width="400" alt="Restaurants manager" src="https://github.com/user-attachments/assets/2abe124b-eb24-4962-a81c-bdee721fd545" /> | <img width="400" alt="Réservations restaurant" src="https://github.com/user-attachments/assets/9f781cfa-a84a-431e-aac5-ff21112a9e20" /> |

*Détails de la réservation et validation de la capacité des tables.*
| Boutons d'action | Erreur : Capacité insuffisante |
| :---: | :---: |
| <img width="400" alt="Détails réservation" src="https://github.com/user-attachments/assets/2235132b-f446-493b-a6af-8ae84fd2a075" /> | <img width="400" alt="Erreur capacité" src="https://github.com/user-attachments/assets/edc1cb40-48be-4aee-8a11-8cbf3471ab47" /> |

*Vérification des disponibilités et confirmation.*
| Erreur : Table déjà occupée | Assignation validée |
| :---: | :---: |
| <img width="400" alt="Table occupée" src="https://github.com/user-attachments/assets/72aa093c-261e-4a6c-9bd9-8e90e2965f94" /> | <img width="400" alt="Assignation réussie" src="https://github.com/user-attachments/assets/6c46abdb-9b72-4ceb-8f18-c67a19e54d72" /> |

*Gestion des services et des tables de l'établissement.*
| Édition/Ajout d'un service | Erreur : Réservations actives |
| :---: | :---: |
| <img width="400" alt="Gestion service" src="https://github.com/user-attachments/assets/d58c5a63-e1a0-4aa4-891a-07ee73087d30" /> | <img width="400" alt="Erreur service actif" src="https://github.com/user-attachments/assets/9f14f199-9830-4d45-b9b5-0953daf13190" /> |

*Gestion du plan de salle.*
| Édition/Ajout d'une table |
| :---: |
| <img width="400" alt="Édition table" src="https://github.com/user-attachments/assets/cdd9f5cd-86f2-4213-b8b5-8a156c4507e0" /> |

## ⚙️ Installation locale
1. Cloner le dépôt : 
```bash
git clone [https://github.com/cheikh2231/gestionReservationDart.git](https://github.com/cheikh2231/gestionReservationDart.git)

## ⚙️ Installation locale
1. Cloner le dépôt : `git clone https://github.com/cheikh2231/gestionReservationDart.git`
2. Installer les dépendances : `flutter pub get`
3. Lancer l'application : `flutter run`
