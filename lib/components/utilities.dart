import 'dart:io';

class Utility {
  static Future checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      throw e;
    }
  }

  static String lastTimeUpdated(DateTime lastTime) {
    DateTime currentTime = DateTime.now();
    Duration duration = currentTime.difference(lastTime);
    if (duration.inSeconds < 60)
      return '${duration.inSeconds} seconds';
    else if (duration.inMinutes < 60)
      return '${duration.inMinutes} ' +
          (duration.inMinutes == 1 ? "minute" : "minutes");
    else if (duration.inHours < 24)
      return '${duration.inHours} ' + (duration.inHours == 1 ? "hour" : "hours");
    else
      return '${duration.inDays} ' + (duration.inDays == 1 ? "day" : "days");
  }
}

/// Data we have in SharedPreferences
/// Authorization
/// isDarkEnabled
/// lastTimeTCUpdated
/// lastTimeMCUpdated
/// enrollNo
/// lastTimeMetadataUpdated
