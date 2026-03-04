# SonicNote — Voice-Powered Notes App

A modern, offline-first notes app built with Flutter. Type or speak your thoughts — everything stays on your device.

## Features

- **Create, Edit, Delete Notes** — Full CRUD with title, body, timestamps
- **Voice to Text** — Tap the mic to dictate notes using your device's speech service
- **Pin & Favorite** — Keep important notes at the top
- **Search & Sort** — Find notes by title/body; sort by newest, oldest, or last edited
- **Light & Dark Mode** — Material 3 with glassmorphism blue→purple gradient UI
- **100% Offline** — No login, no cloud, no tracking. Your data stays on your device.
- **Undo Delete** — Accidentally deleted? Tap Undo in the snackbar

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| State Management | Riverpod |
| Local Database | Hive |
| Speech-to-Text | speech_to_text |
| Design System | Material 3 + Glassmorphism |

## Project Structure

```
lib/
├── core/
│   ├── constants/     # Colors, strings
│   ├── helpers/       # Date formatting
│   ├── theme/         # Material 3 theme (light/dark)
│   └── widgets/       # GlassContainer, GradientButton
├── features/
│   ├── notes/
│   │   ├── data/
│   │   │   ├── models/       # NoteModel (Hive)
│   │   │   └── repository/   # NotesRepository
│   │   ├── presentation/
│   │   │   ├── screens/      # HomeScreen, NoteEditorScreen
│   │   │   └── widgets/      # NoteCard, VoiceWaveform
│   │   └── state/            # Riverpod providers
│   ├── settings/
│   │   ├── presentation/     # SettingsScreen
│   │   └── state/            # ThemeProvider
│   └── splash/               # SplashScreen
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK 3.6+ installed
- Android SDK (API 21+)
- An Android device or emulator

### Run

```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run
```

### Build Release AAB (for Play Store)

1. **Generate a keystore** (one-time):
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Create `android/key.properties`**:
   ```properties
   storePassword=YOUR_STORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=C:/Users/YOU/upload-keystore.jks
   ```

3. **Update `android/app/build.gradle`** — add signing config:
   ```gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   android {
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

4. **Build**:
   ```bash
   flutter build appbundle --release
   ```

5. Find your AAB at: `build/app/outputs/bundle/release/app-release.aab`

6. Upload to [Google Play Console](https://play.google.com/console)

## Play Store Listing

### Short Description (80 chars)
```
Voice-powered notes app. Speak or type — 100% offline, private & free.
```

### Full Description
```
SonicNote — Your Voice-Powered Notes App

Capture your thoughts effortlessly with SonicNote. Type your notes or simply speak — our voice-to-text feature converts your words into text instantly. Everything is stored locally on your device. No accounts, no cloud, no tracking.

✨ KEY FEATURES:
• Voice to Text — Tap the mic and dictate your notes hands-free
• Offline Only — Your notes never leave your device
• Beautiful UI — Modern glassmorphism design with smooth animations
• Dark Mode — Easy on the eyes, day or night
• Pin Notes — Keep important notes at the top
• Search & Sort — Find any note in seconds
• Undo Delete — Recover accidentally deleted notes instantly
• No Ads — Clean, distraction-free experience
• No Sign-up — Open the app and start writing immediately

🎨 DESIGNED FOR YOU:
SonicNote features a stunning blue-to-purple gradient design with glassmorphism effects, smooth animations, and a clean Material 3 interface.

🔒 YOUR PRIVACY MATTERS:
SonicNote doesn't collect, transmit, or share any data. All notes are stored exclusively on your device. We don't have servers — your data is truly yours.

📱 PERFECT FOR:
• Quick thoughts and reminders
• Meeting notes with voice dictation
• Shopping lists and to-dos
• Journal entries
• Students taking lecture notes
• Anyone who values privacy

Download SonicNote today and experience the simplest, most beautiful way to take notes.
```

### Keywords
```
notes, voice notes, speech to text, offline notes, note taking, voice recorder, dictation, memo, notepad, private notes, no login notes, dark mode notes
```

## Privacy Policy

SonicNote is a 100% offline application. We do not collect, store, transmit, or share any personal data. All notes are stored locally on your device. The voice-to-text feature uses your device's built-in speech recognition service. No internet connection is required. See the full privacy policy in-app under Settings → Privacy Policy.

## License

This project is proprietary. All rights reserved.
