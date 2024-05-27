# MemoryGuard

## Overview

MemoryGuard is a mobile application designed to assist caretakers of individuals with dementia. Developed in Dart using the Flutter framework, the application leverages Firebase (Cloud Firestore) for its backend and integrates OpenStreetMap for location-based services. MemoryGuard provides a suite of features aimed at enhancing the safety and well-being of dementia patients while offering vital support to their caretakers.

## Features

### Caretaker Interface
- **Live Location Tracking:** Monitor the real-time location of the patient.
- **Geofencing:** Set up geofenced areas and receive alerts if the patient exits these zones.
- **Medication Reminders:** Schedule and receive reminders for patient medication.
- **Prescription Log:** Maintain a log of all patient prescriptions for easy reference.

### Patient Interface
- **SOS Button:** Quickly alert the caretaker in case of an emergency.

## Technology Stack
- **Language:** Dart
- **Framework:** Flutter
- **IDE:** Android Studio
- **Database:** Firebase (Cloud Firestore)
- **Map Service:** OpenStreetMap

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio
- Firebase account with Cloud Firestore enabled

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/MemoryGuard.git

   cd MemoryGuard
2. **Set up Firebase:**

- Follow the official Firebase setup instructions for Flutter.
- Add the google-services.json file for Android or GoogleService-Info.plist file for iOS in the appropriate directories.

3. **Install dependencies:**

```bash
flutter pub get
```
4. **Run the application:**

```bash

flutter run
```

## Usage
Upon launching the application, caretakers can log in to access the caretaker interface, where they can monitor the patient's location, set up geofences, and manage medication schedules and prescriptions. Patients, on the other hand, will have access to the SOS button on their interface to alert caretakers during emergencies.
