# Chat App

A feature-rich chat application built with Flutter, supporting real-time messaging, group chats, media sharing, and user authentication.

## Features
- **Real-time Messaging**: Instant message delivery between users.
- **Group Chats**: Create and manage group conversations.
- **Media Sharing**: Send images, videos, and other files.
- **User Authentication**: Secure sign-up and sign-in functionality.
- **Flutter Bloc Pattern**: Manages app state efficiently.
- **REST API Integration**: Powered by Dio for network requests.
- **Cloud Backend**: Utilizes Firebase for authentication and real-time data.

## Tech Stack
- **Flutter**: For building the UI.
- **flutter_bloc**: State management.
- **dio**: HTTP client for API calls.
- **firebase_auth**: User authentication.
- **cloud_firestore**: Real-time database.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/rewannashat/chat.git
   cd chat
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Add your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) in the respective folders.
4. Run the app:
   ```bash
   flutter run
   ```

## Folder Structure
```
lib/
├── main.dart                 # Entry point of the app
├── blocs/                    # BLoC state management
├── models/                   # Data models
├── repositories/             # Handles data fetching and business logic
├── screens/                  # UI Screens
├── widgets/                  # Reusable widgets
└── utils/                    # Helper functions and constants
```

## Usage
1. Sign up or log in.
2. Create or join chat rooms.
3. Send messages and share media instantly.

## Contributing
1. Fork the repository.
2. Create a new branch.
3. Make changes and push.
4. Create a pull request.

## License
This project is licensed under the MIT License.

---

Ready to dive in? Clone the repo and start chatting! 💬
