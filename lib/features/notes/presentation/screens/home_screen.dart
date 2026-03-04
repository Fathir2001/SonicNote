import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/note_model.dart';
import '../../state/note_sort_mode.dart';
import '../../state/notes_provider.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearchOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openEditor({NoteModel? note}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => NoteEditorScreen(note: note),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(NoteModel note) async {
    final notifier = ref.read(notesProvider.notifier);
    final deleted = await notifier.deleteNote(note.id);
    if (deleted != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(AppStrings.deleteConfirm),
          action: SnackBarAction(
            label: AppStrings.undo,
            onPressed: () => notifier.restoreNote(deleted),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(filteredNotesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App bar ──────────────────────────────────
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 70,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 20, bottom: 14),
              title: _isSearchOpen
                  ? _buildSearchField()
                  : _buildTitle(isDark),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearchOpen ? Icons.close : Icons.search_rounded,
                ),
                onPressed: () {
                  setState(() {
                    _isSearchOpen = !_isSearchOpen;
                    if (!_isSearchOpen) {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                    }
                  });
                },
              ),
              _buildSortMenu(),
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
              const SizedBox(width: 4),
            ],
          ),

          // ── Note list ────────────────────────────────
          notesAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
            data: (notes) {
              if (notes.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Opacity(
                      opacity: 0.5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.note_add_rounded,
                              size: 64,
                              color: isDark
                                  ? AppColors.softBlue
                                  : AppColors.deepNavy),
                          const SizedBox(height: 16),
                          Text(
                            ref.watch(searchQueryProvider).isNotEmpty
                                ? AppStrings.noResults
                                : AppStrings.noNotes,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark
                                  ? AppColors.nearWhite
                                  : AppColors.deepNavy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => NoteCard(
                      note: notes[i],
                      index: i,
                      onTap: () => _openEditor(note: notes[i]),
                      onDelete: () => _confirmDelete(notes[i]),
                      onTogglePin: () => ref
                          .read(notesProvider.notifier)
                          .togglePin(notes[i].id),
                    ),
                    childCount: notes.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // ── FAB ──────────────────────────────────────────
      floatingActionButton: _buildFab(),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────

  Widget _buildTitle(bool isDark) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppColors.brandGradientHorizontal.createShader(bounds),
      child: const Text(
        AppStrings.appName,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 36,
      width: 220,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (v) =>
            ref.read(searchQueryProvider.notifier).state = v,
      ),
    );
  }

  Widget _buildSortMenu() {
    return PopupMenuButton<NoteSortMode>(
      icon: const Icon(Icons.sort_rounded),
      onSelected: (mode) =>
          ref.read(sortModeProvider.notifier).state = mode,
      itemBuilder: (_) => const [
        PopupMenuItem(
            value: NoteSortMode.newest,
            child: Text(AppStrings.sortNewest)),
        PopupMenuItem(
            value: NoteSortMode.oldest,
            child: Text(AppStrings.sortOldest)),
        PopupMenuItem(
            value: NoteSortMode.lastEdited,
            child: Text(AppStrings.sortLastEdited)),
      ],
    );
  }

  Widget _buildFab() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentIndigo.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.elasticOut,
        );
  }
}
