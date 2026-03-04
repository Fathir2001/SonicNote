/// App‑wide string constants.
class AppStrings {
  AppStrings._();

  static const String appName = 'SonicNote';
  static const String appVersion = '1.0.0';

  // Home screen
  static const String homeTitle = 'My Notes';
  static const String searchHint = 'Search notes…';
  static const String noNotes = 'No notes yet.\nTap + to create one!';
  static const String noResults = 'No matching notes found.';

  // Note editor
  static const String newNote = 'New Note';
  static const String editNote = 'Edit Note';
  static const String titleHint = 'Title';
  static const String bodyHint = 'Start typing or tap the mic…';
  static const String deleteConfirm = 'Note deleted';
  static const String undo = 'Undo';

  // Voice
  static const String listening = 'Listening…';
  static const String tapToSpeak = 'Tap to speak';
  static const String speechUnavailable =
      'Speech recognition depends on your device\'s speech service.';

  // Settings
  static const String settings = 'Settings';
  static const String theme = 'Theme';
  static const String themeLight = 'Light';
  static const String themeDark = 'Dark';
  static const String themeSystem = 'System';
  static const String about = 'About';
  static const String privacyPolicy = 'Privacy Policy';
  static const String version = 'Version';

  // Sort
  static const String sortNewest = 'Newest first';
  static const String sortOldest = 'Oldest first';
  static const String sortLastEdited = 'Last edited';
}
