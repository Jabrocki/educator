# Educator

An educational app prototype built with Flutter. It lets users create a local
account, sign in, organize learning by subject and deck, and create and edit
flashcards.

## Current features

- user registration and sign-in;
- an option to remember the signed-in user;
- local data storage with SQLite;
- management of subjects, decks, flashcards, and images;
- flashcard content editing with Flutter Quill;
- navigation between the Home, Subjects, Search, and Settings views;
- animated grids in the subjects and decks views.

## Technologies

- Flutter and Dart;
- `provider` for state management;
- `sqflite` for the local database;
- `shared_preferences` for persisting user sessions;
- `flutter_quill` for rich-text editing.

## Directory structure

```text
lib/
├── database/   # local database configuration and access
├── dialogs/    # dialogs
├── layouts/    # application screens and navigation
├── models/     # data models
├── state/      # Provider state classes
└── widgets/    # user-interface components
```

The application entry point is `lib/main.dart`.

## Running the project

The repository currently contains the source from the `lib` directory, but no
`pubspec.yaml` file or Flutter platform configuration. To run the project,
first restore a complete Flutter project scaffold and add the dependencies
listed above, then run:

```bash
flutter pub get
flutter run
```

## Status

The project is at the prototype stage. Planned improvements include dark mode,
quizzes, notes, tasks and a calendar, as well as more secure authentication.
