# ExploitApp – Démonstrateur de persistance iOS via LSApplicationWorkspace

## ⚠️ AVERTISSEMENT

**Ce projet est strictement réservé à la recherche en sécurité interne, sur des appareils dont vous êtes propriétaire. Toute utilisation hors de ce cadre est interdite et illégale.**

---

## 📚 Contexte

Ce projet démontre une vulnérabilité théorique dans iOS (MobileCoreServices.framework, LSApplicationWorkspace) permettant la persistance d'une app via une race condition du Launch Services Daemon (LSD). L'exploit consiste à relancer l'app en boucle sans vérification d'identité du processus appelant.

## 🎯 Objectif

- App iOS Swift qui :
  - Exploite la persistance via LSApplicationWorkspace (appel en boucle, auto-terminaison)
  - Envoie les infos système à un serveur Flask local
  - UI minimaliste
- Serveur Flask pour recevoir les infos
- Script de build pour générer l'IPA

## 🏗️ Structure du projet

```
ExploitApp/
├── ExploitApp.xcodeproj
├── ExploitApp/
│   ├── AppDelegate.swift
│   ├── ViewController.swift
│   ├── Info.plist
├── Server/
│   └── server.py
├── export/
│   └── ExportOptions.plist
├── build.sh
├── README.md
```

## 🚀 Installation & Utilisation

### 1. Serveur Flask

```bash
cd Server
pip install flask
python server.py
```

### 2. App iOS

- Ouvrez `ExploitApp.xcodeproj` dans Xcode
- Modifiez l'adresse IP dans `AppDelegate.swift` (ligne `http://<ADRESSE_IP_SERVEUR>:5000/info`)
- Configurez le provisioning profile (manuel, équipe Apple Developer)
- Compilez et installez sur un appareil iOS 14+

### 3. Génération de l'IPA

```bash
chmod +x build.sh
./build.sh
```

## 🔬 Détails techniques

- Exploit via réflexion sur LSApplicationWorkspace (aucun entitlement requis)
- Boucle d'ouverture + exit(0) pour exploiter la race condition du LSD
- Envoi d'infos système (modèle, nom, version iOS, UUID) au serveur Flask

## 🛡️ Sécurité & Limites

- **Aucune obfuscation, aucun payload malveillant**
- **Usage strictement éthique et interne**
- Peut ne pas fonctionner sur iOS récents (sandbox renforcée)
- Ne fonctionne que sur appareils ARM64, iOS 14+

## 📝 Explications de la vulnérabilité

- LSD (Launch Services Daemon) ne vérifie pas correctement l'identité du processus appelant lors de l'ouverture d'une app via `openApplicationWithBundleID:`.
- En appelant cette méthode en boucle dans un thread de fond, puis en quittant rapidement l'app (`exit(0)`), on exploite une race condition : LSD relance l'app même après sa terminaison.
- L'utilisateur ne peut plus fermer l'app normalement, ni la désinstaller facilement.

## 📢 Limites & Éthique

- **Ce projet ne doit jamais être utilisé à des fins malveillantes.**
- Testez uniquement sur vos propres appareils, dans un cadre de recherche responsable.
- Aucune responsabilité n'est assumée en cas de mauvaise utilisation.

## 📂 Fichiers principaux

- `AppDelegate.swift` : logique de l'exploit et envoi des infos
- `ViewController.swift` : UI minimaliste
- `server.py` : serveur Flask de réception
- `build.sh` : script de génération IPA
- `ExportOptions.plist` : options d'export Xcode

---

**Projet pour démonstration et recherche en sécurité.** 
