class TimerJobs {
  final String title;
  final String description;
  final int timer;
  final int rest;
  final int interval;

  TimerJobs({
    required this.title,
    required this.description,
    required this.timer,
    required this.rest,
    required this.interval,
  });

  List<ListJobs> generateJobsTimer() {
    const timeType = ['FOKUS', 'ISTIRAHAT'];
    int workDuration = (timer / (interval + 1)).floor();
    int restDuration = rest;

    List<ListJobs> jobsTimer = [];

    for (int i = 0; i < findIntervalLoop(interval); i++) {
      String type = timeType[i % 2];
      int duration = type == 'FOKUS' ? workDuration : restDuration;
      jobsTimer.add(ListJobs(
        title: type,
        description: '$type for $duration minutes',
        duration: duration,
        type: type,
      ));
    }

    return jobsTimer;
  }

  int findIntervalLoop(int interval){
    return interval * 2 + 1;
  }
}

class ListJobs {
  final String title;
  final String description;
  final int duration;
  final String type;

  ListJobs({
    required this.title,
    required this.description,
    required this.duration,
    required this.type,
  });
}
