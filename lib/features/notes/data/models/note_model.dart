import 'package:hive/hive.dart';

part 'note_model.g.dart';

/// Hive type adapter for Note. Stored in box 'notes'.
@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  bool isPinned;

  @HiveField(6)
  bool isFavorite;

  NoteModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.isFavorite = false,
  });

  /// Create a copy with optional overrides.
  NoteModel copyWith({
    String? title,
    String? body,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isFavorite,
  }) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
