class Timer {
  String title;
  String image;
  String description;
  String time;

  Timer({
    required this.image,
    required this.title,
    required this.description,
    required this.time,
  });
}

var Timerlist = [
  Timer(
    image: 'assets/images/cat1.svg',
    title: 'Short Timer',
    description: 'Produktivitas waktu singkat',
    time: '00:15:00',
  ),
  Timer(
    image: 'assets/images/cat1.svg',
    title: 'Long Timer',
    description: 'Produktivitas waktu panjang',
    time: '00:40:00',
  ),
  Timer(
    image: 'assets/images/cat1.svg',
    title: 'Pomodoro',
    description: 'Fokus dengan pomodoro',
    time: '00:25:00',
  ),
];
