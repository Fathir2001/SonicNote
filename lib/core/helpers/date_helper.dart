import 'package:intl/intl.dart';

/// Date/time formatting helpers.
class DateHelper {
  DateHelper._();

  static String formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return DateFormat('EEEE').format(dt);
    return DateFormat('MMM d, yyyy').format(dt);
  }

  static String formatFull(DateTime dt) =>
      DateFormat('MMM d, yyyy – h:mm a').format(dt);
}
