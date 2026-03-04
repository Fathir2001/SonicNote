import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/models/note_model.dart';
import '../data/repository/notes_repository.dart';
import 'note_sort_mode.dart';

// ─── Repository provider ──────────────────────────────────────────
final notesRepositoryProvider = Provider((_) => NotesRepository());

// ─── Sort mode state ──────────────────────────────────────────────
final sortModeProvider = StateProvider<NoteSortMode>(
  (_) => NoteSortMode.newest,
);

// ─── Search query state ───────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((_) => '');

// ─── Notes list state ─────────────────────────────────────────────
final notesProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<List<NoteModel>>>((ref) {
  return NotesNotifier(ref);
});

/// Filtered + sorted notes for the UI.
final filteredNotesProvider = Provider<AsyncValue<List<NoteModel>>>((ref) {
  final notesAsync = ref.watch(notesProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final sort = ref.watch(sortModeProvider);

  return notesAsync.whenData((notes) {
    // Filter by search
    var filtered = query.isEmpty
        ? notes
        : notes
            .where((n) =>
                n.title.toLowerCase().contains(query) ||
                n.body.toLowerCase().contains(query))
            .toList();

    // Sort
    switch (sort) {
      case NoteSortMode.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case NoteSortMode.oldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case NoteSortMode.lastEdited:
        filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
    }

    // Pinned first
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });

    return filtered;
  });
});

// ─── Notifier ─────────────────────────────────────────────────────
class NotesNotifier extends StateNotifier<AsyncValue<List<NoteModel>>> {
  NotesNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadNotes();
  }

  final Ref _ref;
  static const _uuid = Uuid();

  NotesRepository get _repo => _ref.read(notesRepositoryProvider);

  /// Load all notes from Hive.
  Future<void> loadNotes() async {
    try {
      final notes = await _repo.getAllNotes();
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Create a new note and return its id.
  Future<String> createNote({
    required String title,
    required String body,
  }) async {
    final now = DateTime.now();
    final note = NoteModel(
      id: _uuid.v4(),
      title: title.trim(),
      body: body.trim(),
      createdAt: now,
      updatedAt: now,
    );
    await _repo.saveNote(note);
    await loadNotes();
    return note.id;
  }

  /// Update an existing note.
  Future<void> updateNote({
    required String id,
    required String title,
    required String body,
  }) async {
    final existing = await _repo.getNoteById(id);
    if (existing == null) return;
    final updated = existing.copyWith(
      title: title.trim(),
      body: body.trim(),
      updatedAt: DateTime.now(),
    );
    await _repo.saveNote(updated);
    await loadNotes();
  }

  /// Delete a note. Returns the deleted note for undo.
  Future<NoteModel?> deleteNote(String id) async {
    final note = await _repo.getNoteById(id);
    await _repo.deleteNote(id);
    await loadNotes();
    return note;
  }

  /// Re‑insert a previously deleted note (undo).
  Future<void> restoreNote(NoteModel note) async {
    await _repo.saveNote(note);
    await loadNotes();
  }

  /// Toggle pin.
  Future<void> togglePin(String id) async {
    await _repo.togglePin(id);
    await loadNotes();
  }

  /// Toggle favorite.
  Future<void> toggleFavorite(String id) async {
    await _repo.toggleFavorite(id);
    await loadNotes();
  }
}
