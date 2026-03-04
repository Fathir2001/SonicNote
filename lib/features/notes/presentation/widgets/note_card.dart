import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../data/models/note_model.dart';

/// A glassmorphism note card for the home list.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onTogglePin,
    this.index = 0,
  });

  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.nearWhite : AppColors.deepNavy;
    final subColor = textColor.withValues(alpha: 0.55);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: isDark
                ? AppColors.pureWhite.withValues(alpha: 0.08)
                : AppColors.deepNavy.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.pureWhite.withValues(alpha: 0.12)
                        : AppColors.pureWhite.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      children: [
                        if (note.isPinned)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.push_pin_rounded,
                              size: 16,
                              color: AppColors.accentIndigo,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            note.title.isEmpty ? 'Untitled' : note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        // Popup menu
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: subColor, size: 20),
                          onSelected: (v) {
                            if (v == 'pin') onTogglePin();
                            if (v == 'delete') onDelete();
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'pin',
                              child:
                                  Text(note.isPinned ? 'Unpin' : 'Pin to top'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Body preview
                    if (note.body.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        note.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: subColor,
                          height: 1.4,
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // Date
                    Row(
                      children: [
                        Text(
                          DateHelper.formatDate(note.updatedAt),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: subColor.withValues(alpha: 0.6),
                          ),
                        ),
                        if (note.isFavorite) ...[
                          const Spacer(),
                          Icon(Icons.favorite_rounded,
                              size: 14, color: AppColors.magentaPurple),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .animate()
        .fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: (50 * index).clamp(0, 400)),
        )
        .slideY(
          begin: 0.05,
          end: 0,
          duration: 300.ms,
          delay: Duration(milliseconds: (50 * index).clamp(0, 400)),
          curve: Curves.easeOut,
        );
  }
}
