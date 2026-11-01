# Educator

Prototyp aplikacji edukacyjnej stworzonej we Flutterze. Pozwala użytkownikowi
założyć lokalne konto, logować się, organizować naukę według przedmiotów i talii
oraz tworzyć i edytować fiszki.

## Obecne możliwości

- rejestracja i logowanie użytkownika;
- opcja zapamiętania zalogowanego użytkownika;
- lokalne przechowywanie danych w SQLite;
- zarządzanie przedmiotami, taliami, fiszkami i obrazami;
- edycja zawartości fiszek z użyciem Flutter Quill;
- nawigacja między widokami: Home, Subjects, Search i Settings;
- animowane siatki elementów w widoku przedmiotów i talii.

## Technologie

- Flutter i Dart;
- `provider` do zarządzania stanem;
- `sqflite` do lokalnej bazy danych;
- `shared_preferences` do zachowania sesji użytkownika;
- `flutter_quill` do edycji sformatowanego tekstu.

## Struktura katalogów

```text
lib/
├── database/   # konfiguracja i obsługa lokalnej bazy danych
├── dialogs/    # okna dialogowe
├── layouts/    # ekrany i nawigacja aplikacji
├── models/     # modele danych
├── state/      # stany używane przez Provider
└── widgets/    # komponenty interfejsu
```

Punktem wejścia aplikacji jest `lib/main.dart`.

## Uruchomienie

W tym repozytorium znajduje się obecnie kod źródłowy z katalogu `lib`, bez
pliku `pubspec.yaml` i konfiguracji platform Fluttera. Aby uruchomić projekt,
należy uzupełnić pełny szkielet aplikacji Flutter, dodać zależności wymienione
wyżej, a następnie wykonać:

```bash
flutter pub get
flutter run
```

## Status

Projekt jest w fazie prototypu. Planowane kierunki rozwoju obejmują m.in.
tryb ciemny, quizy, notatki, zadania i kalendarz oraz bezpieczniejsze
uwierzytelnianie.
