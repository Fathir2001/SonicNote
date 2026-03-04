import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';

/// Handles all CRUD operations on the local Hive 'notes' box.
class NotesRepository {
  static const String _boxName = 'notes';

  /// Open and return the notes box.
  static Future<Box<NoteModel>> _box() async =>
      Hive.isBoxOpen(_boxName)
          ? Hive.box<NoteModel>(_boxName)
          : await Hive.openBox<NoteModel>(_boxName);

  /// Get all notes sorted by newest first (default).
  Future<List<NoteModel>> getAllNotes() async {
    final box = await _box();
    return box.values.toList();
  }

  /// Get a single note by id.
  Future<NoteModel?> getNoteById(String id) async {
    final box = await _box();
    try {
      return box.values.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Create or update a note. Uses id as key.
  Future<void> saveNote(NoteModel note) async {
    final box = await _box();
    await box.put(note.id, note);
  }

  /// Delete a note by id.
  Future<void> deleteNote(String id) async {
    final box = await _box();
    await box.delete(id);
  }

  /// Toggle pin status.
  Future<NoteModel> togglePin(String id) async {
    final box = await _box();
    final note = box.get(id);
    if (note == null) throw Exception('Note not found');
    final updated = note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    );
    await box.put(id, updated);
    return updated;
  }

  /// Toggle favorite status.
  Future<NoteModel> toggleFavorite(String id) async {
    final box = await _box();
    final note = box.get(id);
    if (note == null) throw Exception('Note not found');
    final updated = note.copyWith(
      isFavorite: !note.isFavorite,
      updatedAt: DateTime.now(),
    );
    await box.put(id, updated);
    return updated;
  }
}
