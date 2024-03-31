const String customTimer = "timer";

class CustomTimerFields {
  static const String id = "id";
  static const String title = "title";
  static const String description = "description";
  static const String timer = "time";
  static const String rest = "rest";
  static const String interval = "interval";
}

class CusTime {
  final int? id;
  final String title;
  final String description;
  final int timer;
  final int? rest;
  final int? interval;

  CusTime({
    this.id,
    required this.title,
    required this.description,
    required this.timer,
    this.rest,
    this.interval,
  });

  CusTime copy({
    int? id,
    String? title,
    String? description,
    int? timer,
    int? rest,
    int? interval,
  }) {
    return CusTime(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        timer: timer ?? this.timer,
        rest: rest ?? this.rest,
        interval: interval ?? this.interval);
  }

  static CusTime fromJson(Map<String, Object?> json) {
    return CusTime(
      id: json[CustomTimerFields.id] as int?,
      title: json[CustomTimerFields.title] as String,
      description: json[CustomTimerFields.description] as String,
      timer: json[CustomTimerFields.timer] as int,
      rest: json[CustomTimerFields.rest] as int?,
      interval: json[CustomTimerFields.rest] as int?,
    );
  }

  Map<String, Object?> toJson() => {
        CustomTimerFields.id: id,
        CustomTimerFields.title: title,
        CustomTimerFields.description: description,
        CustomTimerFields.timer: timer,
        CustomTimerFields.rest: rest,
        CustomTimerFields.interval: interval,
      };
}
