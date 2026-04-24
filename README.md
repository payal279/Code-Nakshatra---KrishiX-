# KrishiX - Krishi Mitra Flutter Web App

## 📌 Overview

KrishiX (Krishi Mitra) is a Flutter-based web application designed to help users with agriculture-related services and information.
This project is built using **Flutter Web** and can run in browsers like Chrome, Edge, and Firefox.

---

## 🚀 Requirements

Before running this project, make sure you have installed:

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* VS Code / Android Studio
* Chrome Browser
* Git (optional)

---

## 📂 Project Structure

```text
lib/            → Main Dart source code
web/            → Web-specific files
assets/         → Images, fonts, icons
pubspec.yaml    → Dependencies & project settings
main.dart       → App entry point
```

---

## ⚙️ Setup Instructions

### 1️⃣ Clone or Download Project

```bash
git clone <repository-url>
```

or download ZIP and extract it.

---

### 2️⃣ Open Project Folder

Open the project folder in **VS Code**.

---

### 3️⃣ Install Dependencies

Run this command in terminal:

```bash
flutter pub get
```

---

### 4️⃣ Enable Web Support

```bash
flutter config --enable-web
```

---

### 5️⃣ Run the Project

```bash
flutter run -d chrome
```

or

```bash
flutter run -d edge
```

---

## 🛠️ Common Issues

### Flutter not recognized

If terminal says `flutter is not recognized`, add Flutter to PATH:

```text
C:\flutter\bin
```

Then restart terminal.

---

### Packages Error

```bash
flutter clean
flutter pub get
```

---

### Chrome Device Not Found

Check available devices:

```bash
flutter devices
```

---

## 📦 Build for Production

To create web build:

```bash
flutter build web
```

Output will be inside:

```text
build/web
```

---

## 🔥 Features

* Responsive UI
* Agriculture Information
* Modern Flutter Web Interface
* Cross-platform Support

---

## 👩‍💻 Developed With

* Flutter
* Dart
* Firebase (if configured)

---

## 📄 License

This project is for educational / personal use.

---
