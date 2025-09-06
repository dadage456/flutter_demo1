# GEMINI.md

## Project Overview

This is a Flutter project for a warehouse management system. The main functionality seems to be related to warehouse collection, as indicated by the `warehouse_collection_page.dart` file. The project is set up for cross-platform development, targeting Android, iOS, Linux, macOS, Web, and Windows.

**Key Technologies:**

*   **Framework:** Flutter
*   **Language:** Dart
*   **UI:** Material Design

**Architecture:**

The project follows a standard Flutter project structure. The entry point is `lib/main.dart`, which sets up the main application widget and routes to the `WarehouseCollectionPage`. The UI is built with Flutter widgets, and the application state seems to be managed within the widgets themselves (using `StatefulWidget`).

## Building and Running

To build and run this project, you will need to have the Flutter SDK installed.

**Running the app:**

```bash
flutter run
```

This command will launch the application on a connected device or emulator.

**Building the app:**

To build the app for a specific platform, use the following commands:

*   **Android:** `flutter build apk` or `flutter build appbundle`
*   **iOS:** `flutter build ios`
*   **Web:** `flutter build web`
*   **macOS:** `flutter build macos`
*   **Linux:** `flutter build linux`
*   **Windows:** `flutter build windows`

**Testing the app:**

To run the widget tests, use the following command:

```bash
flutter test
```

## Development Conventions

*   **Linting:** The project uses `flutter_lints` to enforce good coding practices. The linting rules are defined in the `analysis_options.yaml` file.
*   **Styling:** The code follows the standard Dart and Flutter styling guidelines.
*   **State Management:** The current implementation uses `StatefulWidget` for state management. For more complex applications, you might consider using a more advanced state management solution like Provider, BLoC, or Riverpod.
*   **File Naming:** Files are named using `snake_case`.
