# 🌙 MoodMate – Mood Tracker & Chat App

A Flutter app that helps users **track moods**, **analyze emotional trends**, and **connect with others** through a smart **matching algorithm** and **real-time chat**.  
Built with **Flutter** and **Firebase**, featuring a clean UI, animations, and light/dark themes.  

---

## ✨ Features

- 📅 **Mood Tracking**
  - Rate your daily mood (1–5)
  - Write journal-style entries
  - View mood history with charts

- 🔍 **Smart Matching**
  - Match with users in real-time
  - Filters for preferences
  - Automatic redirection to chat on match

- 💬 **Real-Time Chat**
  - Emoji & sticker messaging
  - Time-limited chat sessions
  - Online/offline status
  - Auto-exit when one user leaves

- 🎨 **UI/UX**
  - Dark & Light themes
  - Smooth transitions & animations
  - Modern, minimal design

- 🔔 **Notifications**
  - New match alerts
  - Chat message notifications

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart), GetX for state management  
- **Backend**: Firebase Auth, Firestore, Realtime Database, Cloud Messaging  
- **Storage**: GetStorage / Hive (local), Firebase Cloud Storage (optional for images)  
- **Other**: Lottie animations, animated_emoji, avatar_plus  

---

## 📸 Screenshots

| Mood Tracker | Mood Chart | Matching | Chat |
|--------------|------------|----------|------|
| ![Mood](screenshots/mood.png) | ![Chart](screenshots/chart.png) | ![Match](screenshots/match.png) | ![Chat](screenshots/chat.png) |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Firebase project configured
- Emulator or physical device

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/moodmate.git

# Navigate into the project
cd moodmate

# Get dependencies
flutter pub get

# Run the app
flutter run
