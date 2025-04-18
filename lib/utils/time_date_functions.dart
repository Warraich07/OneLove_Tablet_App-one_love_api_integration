import 'package:intl/intl.dart';

class TimeDateFunctions {
  static int get timestamp => DateTime.now().microsecondsSinceEpoch;

  String durationToTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  static Duration timeDuration(int value) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(value);
    Duration diff = date.difference(now);
    return diff;
  }

  static String stopwatchTime(int value) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(value);
    Duration diff = date.difference(now);
    double inSec = diff.inSeconds.abs() / 10;
    int inMints = diff.inMinutes.abs();
    int inHour = diff.inHours.abs();
    return inHour > 0 ? '$inHour:$inMints:$inSec' : '$inMints:$inSec';
  }

  static String timeInDigits(int value) {
    DateFormat format = DateFormat('HH:mm a');
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(value);
    return format.format(date);
  }

  static String dateTimeInDigits(int value) {
    DateFormat format = DateFormat('MM/dd/yyyy hh:mm a');
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(value);
    return format.format(date);
  }

  static String dateInDigits(int value) {
    DateFormat format = DateFormat('MM/dd/yyyy');
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(value);
    return format.format(date);
  }

  static String timeInWords(int value) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(value);
    Duration diff = date.difference(now);
    String time = '';

    int inSec = diff.inSeconds.abs();
    int inMints = diff.inMinutes.abs();
    int inHour = diff.inHours.abs();
    int inDays = diff.inDays.abs();

    if (inSec <= 0 || inSec > 0 && inMints == 0) {
      time = 'few seconds ago';
      //
    } else if (inMints > 0 && inHour == 0) {
      //
      if (inMints < 1.5) {
        time = '${inMints.toStringAsFixed(0)} minute ago';
      } else {
        time = '${inMints.toStringAsFixed(0)} minutes ago';
      }
      //
    } else if (inHour > 0 && inDays == 0) {
      //
      if (inHour < 1.5) {
        time = '${inHour.toStringAsFixed(0)} hour ago';
      } else {
        time = '${inHour.toStringAsFixed(0)} hours ago';
      }
      //
    } else if (inDays > 0 && inDays < 7) {
      //
      if (inDays < 1.5) {
        time = '${inDays.toStringAsFixed(0)} day ago';
      } else {
        time = '${inDays.toStringAsFixed(0)} days ago';
      }
      //
    } else if (inDays >= 7 && inDays < 30) {
      double temp = (diff.inDays.abs() / 7);
      //
      if (inDays < 14) {
        time = '${temp.toStringAsFixed(0)} week ago';
      } else {
        time = '${temp.toStringAsFixed(0)} weeks ago';
      }
      //
    } else if (diff.inDays.abs() >= 30 && diff.inDays.abs() < 365) {
      double temp = (diff.inDays.abs() / 30);
      if (temp < 1.5) {
        time = '${temp.toStringAsFixed(0)} month ago';
      } else {
        time = '${temp.toStringAsFixed(0)} months ago';
      }
    } else {
      double temp = (diff.inDays.abs() / 365);
      if (temp < 1.5) {
        time = '${temp.toStringAsFixed(0)} year ago';
      } else {
        time = '${temp.toStringAsFixed(0)} years ago';
      }
    }
    return time;
  }
}
