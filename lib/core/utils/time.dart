// String displayTimeAgoFromTimestamp(String dateString,
//     {bool numericDates = true}) {
//   DateTime date = DateTime.parse(dateString);
//   final date2 = DateTime.now();
//   final difference = date2.difference(date);

//   if ((difference.inDays / 365).floor() >= 2) {
//     return '${(difference.inDays / 365).floor()} years ago';
//   } else if ((difference.inDays / 365).floor() >= 1) {
//     return (numericDates) ? '1 year ago' : 'Last year';
//   } else if ((difference.inDays / 30).floor() >= 2) {
//     return '${(difference.inDays / 365).floor()} months ago';
//   } else if ((difference.inDays / 30).floor() >= 1) {
//     return (numericDates) ? '1 month ago' : 'Last month';
//   } else if ((difference.inDays / 7).floor() >= 2) {
//     return '${(difference.inDays / 7).floor()} weeks ago';
//   } else if ((difference.inDays / 7).floor() >= 1) {
//     return (numericDates) ? '1 week ago' : 'Last week';
//   } else if (difference.inDays >= 2) {
//     return '${difference.inDays} days ago';
//   } else if (difference.inDays >= 1) {
//     return (numericDates) ? '1 day ago' : 'Yesterday';
//   } else if (difference.inHours >= 2) {
//     return '${difference.inHours} hours ago';
//   } else if (difference.inHours >= 1) {
//     return (numericDates) ? '1 hour ago' : 'An hour ago';
//   } else if (difference.inMinutes >= 2) {
//     return '${difference.inMinutes} minutes ago';
//   } else if (difference.inMinutes >= 1) {
//     return (numericDates) ? '1 minute ago' : 'A minute ago';
//   } else if (difference.inSeconds >= 3) {
//     return '${difference.inSeconds} seconds ago';
//   } else {
//     return 'Just now';
//   }
// }
extension StringExtension on String {
  static String timeAgo(String timestamp) {
    final year = int.parse(timestamp.substring(0, 4));
    final month = int.parse(timestamp.substring(5, 7));
    final day = int.parse(timestamp.substring(8, 10));
    final hour = int.parse(timestamp.substring(11, 13));
    final minute = int.parse(timestamp.substring(14, 16));

    final DateTime videoDate = DateTime(year, month, day, hour, minute);
    final int diffInHours = DateTime.now().difference(videoDate).inHours;

    String timeAgo = '';
    String timeUnit = '';
    int timeValue = 0;

    if (diffInHours < 1) {
      final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
      timeValue = diffInMinutes;
      timeUnit = 'minute';
    } else if (diffInHours < 24) {
      timeValue = diffInHours;
      timeUnit = 'hour';
    } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
      timeValue = (diffInHours / 24).floor();
      timeUnit = 'day';
    } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
      timeValue = (diffInHours / (24 * 7)).floor();
      timeUnit = 'week';
    } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
      timeValue = (diffInHours / (24 * 30)).floor();
      timeUnit = 'month';
    } else {
      timeValue = (diffInHours / (24 * 365)).floor();
      timeUnit = 'year';
    }

    timeAgo = timeValue.toString() + ' ' + timeUnit;
    timeAgo += timeValue > 1 ? 's' : '';

    return timeAgo + ' ago';
  }
}
