import 'package:intl/intl.dart';

String chatTime(String dateString, {bool numericDates = true}) {
  DateTime date = DateTime.parse(dateString);
  final date2 = DateTime.now();
  final time = DateFormat('hh:mm a').format(DateTime.parse(dateString));
  final week = DateFormat('dd/MM/yyyy').format(DateTime.parse(dateString));
  final difference = date2.difference(date);

  if ((difference.inDays / 365).floor() >= 2) {
    return week;
  } else if ((difference.inDays / 365).floor() >= 1) {
    return 'Last year';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return week;
  } else if ((difference.inDays / 30).floor() >= 1) {
    return 'Last month';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return week;
  } else if ((difference.inDays / 7).floor() >= 1) {
    return 'Last week';
  } else if (difference.inDays >= 2) {
    return week;
  } else if (difference.inDays >= 1) {
    return 'Yesterday';
  } else if (difference.inHours >= 2) {
    return time;
  } else if (difference.inHours >= 1) {
    return time;
  } else if (difference.inMinutes >= 2) {
    return time;
  } else if (difference.inMinutes >= 1) {
    return time;
  } else if (difference.inSeconds >= 3) {
    return time;
  } else {
    return time;
  }
}
