import 'package:timeago/timeago.dart';

class TimeAgo {
  DateTime newTime;

  int oneHour = 3600000;
  int oneMin = 60000;
  int oneSec = 1000;

  TimeAgo();

  String timeUpdater(DateTime loadedTime) {
    final now = new DateTime.now();
    final difference = now.difference(loadedTime);
    //new Timer.periodic(new Duration(seconds: 1), (_) => timeUpdater(time));
    return /*timeText =*/ timeAgo(now.subtract(difference));
  }

  String getAltTimeAgo(int milliseconds) {
    int newHours = getHoursAgoInt(milliseconds);
    int newMinutes = getMinutesAgoInt(milliseconds);
    int newSeconds = getSecondsAgoInt(milliseconds);
    int newTimeAgo;
    String timeAgo;

    //String timeAgo = newTimeAgo == 0 ? "now" : newTimeAgo.toString();
    return timeAgo;
  }

  String getTimeAgo(int time) {
    int newHours = getHoursAgoInt(time);
    int newMinutes = getMinutesAgoInt(time);
    int newSeconds = getSecondsAgoInt(time);
    //int newTimeAgo =  newHours == 0 ? newMinutes :? newMinutes == 0 ? 0;
    int newTimeAgo;
    String timeAgo;
    if (newHours > 0) {
      newTimeAgo = newHours;
      timeAgo = getHoursString(newTimeAgo);
      //timeAgo = newTimeAgo.toString() + " hrs Ago";
    } else if (newHours <= 0) {
      newTimeAgo = newMinutes;
      timeAgo = getMinutesString(newTimeAgo);
    } else if (newMinutes > 0) {
      timeAgo = getMinutesString(newTimeAgo);
    } else if (newSeconds <= 0) {
      newTimeAgo = 0;
      timeAgo = getSecondsString(newTimeAgo);
    }

    //String timeAgo = newTimeAgo == 0 ? "now" : newTimeAgo.toString();
    return timeAgo;
  }

  String getHoursAgoString(int time) {
    DateTime oldTime = new DateTime.fromMillisecondsSinceEpoch(time);
    DateTime currentTime = new DateTime.now();
    int newTime = currentTime.hour - oldTime.hour;
    String hoursAgo = newTime.toString() == "1"
        ? newTime.toString() + "hr Ago"
        : newTime.toString() + "hrs Ago";
    return hoursAgo;
  }

  String getMinutesAgoString(int time) {
    DateTime oldTime =
        new DateTime.fromMillisecondsSinceEpoch(time, isUtc: true);
    DateTime currentTime = new DateTime.now();
    int newTime = currentTime.minute - oldTime.minute;
    String hoursAgo =
        newTime.toString() == "0" ? "now" : newTime.toString() + "minutes Ago";
    return hoursAgo;
  }

  String getCompleteTime(int time) {
    DateTime oldTime = new DateTime.fromMillisecondsSinceEpoch(time);

    List<String> listTime = oldTime.toIso8601String().split("T");
    List<String> currentTime = listTime[1].split(".");
    List<String> splitTime = currentTime[0].split(":");

    String hours = splitTime[0];
    String mins = splitTime[1];
    String secs = splitTime[2];
    int intOfHrs = num.parse(hours);
    String timeOfDay = intOfHrs >= 12 ? "PM" : "AM";
    String hoursAgo = "$hours:$mins $timeOfDay";
    return hoursAgo;
  }

  String getSecondsAgoString(int time) {
    DateTime oldTime = new DateTime.fromMillisecondsSinceEpoch(time);
    DateTime currentTime = new DateTime.now();
    int newTime = currentTime.second - oldTime.second;
    String hoursAgo = newTime.toString() == "1"
        ? newTime.toString() + "second Ago"
        : newTime.toString() + "seconds Ago";
    return hoursAgo;
  }

  String getHoursString(int time) {
    String hoursAgo = time.toString() == "1"
        ? time.toString() + "hr Ago"
        : time.toString() + "hrs Ago";
    return hoursAgo;
  }

  String getMinutesString(int time) {
    String hoursAgo = time.toString() == "1"
        ? time.toString() + "minutue Ago"
        : time.toString() + "minutues Ago";
    return hoursAgo;
  }

  String getSecondsString(int time) {
    return "now";
  }

  int getHoursAgoInt(int time) {
    DateTime oldTime = new DateTime.fromMillisecondsSinceEpoch(time);
    DateTime currentTime = new DateTime.now();
    int newTime = currentTime.hour - oldTime.hour;
    return newTime;
  }

  int getMinutesAgoInt(int time) {
    DateTime oldTime = new DateTime.fromMillisecondsSinceEpoch(time);
    DateTime currentTime = new DateTime.now();
    int newTime = currentTime.minute - oldTime.minute;
    return newTime;
  }

  int getSecondsAgoInt(int time) {
    DateTime oldTime = new DateTime.fromMillisecondsSinceEpoch(time);
    DateTime currentTime = new DateTime.now();
    int newTime = currentTime.second - oldTime.second;
    return newTime;
  }
}
