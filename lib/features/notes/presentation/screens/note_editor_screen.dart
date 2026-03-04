import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/models/note_model.dart';
import '../../state/notes_provider.dart';
import '../widgets/voice_waveform.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, this.note});
  final NoteModel? note;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  late final stt.SpeechToText _speech;

  bool _isListening = false;
  bool _speechAvailable = false;
  bool _isNew = true;
  String? _noteId;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _bodyCtrl = TextEditingController(text: widget.note?.body ?? '');
    _isNew = widget.note == null;
    _noteId = widget.note?.id;
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onError: (e) {
          debugPrint('Speech error: ${e.errorMsg}');
          if (mounted) setState(() => _isListening = false);
        },
        onStatus: (status) {
          if (status == 'notListening' && mounted) {
            setState(() => _isListening = false);
          }
        },
      );
    } catch (e) {
      debugPrint('Speech init failed: $e');
      _speechAvailable = false;
    }
    if (mounted) setState(() {});
  }

  Future<void> _toggleListening() async {
    // Check microphone permission
    final micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Microphone permission is required.')),
          );
        }
        return;
      }
    }

    if (!_speechAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.speechUnavailable)),
        );
      }
      return;
    }

    // Haptic feedback
    HapticFeedback.lightImpact();

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          final recognized = result.recognizedWords;
          if (recognized.isNotEmpty) {
            final current = _bodyCtrl.text;
            final separator = current.isEmpty ? '' : ' ';
            _bodyCtrl.text = '$current$separator$recognized';
            _bodyCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: _bodyCtrl.text.length),
            );
          }
        },
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          cancelOnError: true,
          partialResults: true,
        ),
      );
    }
  }

  Future<void> _saveNote() async {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();

    // Don't save completely empty notes.
    if (title.isEmpty && body.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final notifier = ref.read(notesProvider.notifier);
    if (_isNew) {
      _noteId = await notifier.createNote(title: title, body: body);
      _isNew = false;
    } else if (_noteId != null) {
      await notifier.updateNote(id: _noteId!, title: title, body: body);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _speech.stop();
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.nearWhite : AppColors.deepNavy;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? AppStrings.newNote : AppStrings.editNote),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _saveNote,
        ),
        actions: [
          // Favorite toggle (only for existing notes)
          if (!_isNew && _noteId != null)
            IconButton(
              icon: Icon(
                widget.note?.isFavorite == true
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: AppColors.magentaPurple,
              ),
              onPressed: () {
                ref.read(notesProvider.notifier).toggleFavorite(_noteId!);
              },
            ),
          // Save button
          IconButton(
            icon: ShaderMask(
              shaderCallback: (b) =>
                  AppColors.brandGradientHorizontal.createShader(b),
              child: const Icon(Icons.check_rounded, color: Colors.white),
            ),
            onPressed: _saveNote,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          await _saveNote();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // ── Title field ──
              TextField(
                controller: _titleCtrl,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.titleHint,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: textColor.withValues(alpha: 0.35),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const Divider(height: 1),
              const SizedBox(height: 4),

              // ── Body field ──
              Expanded(
                child: TextField(
                  controller: _bodyCtrl,
                  maxLines: null,
                  expands: true,
                  style: TextStyle(
                    fontSize: 15.5,
                    color: textColor.withValues(alpha: 0.85),
                    height: 1.55,
                  ),
                  decoration: InputDecoration(
                    hintText: AppStrings.bodyHint,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: textColor.withValues(alpha: 0.3),
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),

              // ── Voice bar ──
              _buildVoiceBar(isDark),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? AppColors.pureWhite.withValues(alpha: 0.06)
            : AppColors.deepNavy.withValues(alpha: 0.04),
        border: Border.all(
          color: _isListening
              ? AppColors.neonPurple.withValues(alpha: 0.4)
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Waveform
          VoiceWaveform(isActive: _isListening),
          if (_isListening) const SizedBox(width: 12),

          // Status text
          Expanded(
            child: Text(
              _isListening ? AppStrings.listening : AppStrings.tapToSpeak,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: _isListening
                    ? AppColors.neonPurple
                    : (isDark ? AppColors.nearWhite : AppColors.deepNavy)
                        .withValues(alpha: 0.45),
              ),
            ),
          ),

          // Mic button with pulsing glow
          _buildMicButton(),
        ],
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _toggleListening,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _isListening ? AppColors.brandGradient : null,
          color: _isListening ? null : AppColors.accentIndigo.withValues(alpha: 0.15),
          boxShadow: _isListening
              ? [
                  BoxShadow(
                    color: AppColors.neonPurple.withValues(alpha: 0.45),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Icon(
          _isListening ? Icons.stop_rounded : Icons.mic_rounded,
          color: _isListening ? AppColors.pureWhite : AppColors.accentIndigo,
          size: 22,
        ),
      ),
    )
        .animate(
          target: _isListening ? 1 : 0,
        )
        .scaleXY(begin: 1, end: 1.08, duration: 600.ms)
        .then()
        .scaleXY(begin: 1.08, end: 1, duration: 600.ms);
  }
}
