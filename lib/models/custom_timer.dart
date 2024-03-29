class CustomTimer {
  final String name;
  final String description;
  final int mainTime;
  final int? breakTime;
  final int? interval;

  CustomTimer({
    required this.name,
    required this.description,
    required this.mainTime,
    this.breakTime,
    this.interval,
  });

  List<CustomTimer> addTimer = [
    CustomTimer(
        name: "Focus Instan",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        mainTime: 30)
  ];

  List<CustomTimer> addTimeBreak = [
    CustomTimer(
        name: "For a moment",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        mainTime: 40,
        breakTime: 5,
        interval: 2)
  ];
}
