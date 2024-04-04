class OnBoardItems {
  final String image;
  final String title;
  final String shortDescription;

  OnBoardItems(
      {required this.image,
      required this.title,
      required this.shortDescription});
}

class OnboardData {
  static List<OnBoardItems> onBoardItemList = [
    OnBoardItems(
      image: 'assets/images/cat_hello.png',
      title: "Welcome to TimeMinder",
      shortDescription: "Kelola waktu Anda secara efektif dengan TimeMinder",
    ),
    OnBoardItems(
      image: 'assets/images/cat_clock.png',
      title: "Explore Amazing Features",
      shortDescription:
          "Jelajahi fitur-fitur menakjubkan dan tetap terorganisir dengan TimeMinder",
    ),
    OnBoardItems(
      image: 'assets/images/cat_pencil.png',
      title: "Get Started Now!",
      shortDescription:
          "Mulai sekarang dan tingkatkan produktivitas Anda bersama TimeMinder",
    )
  ];
}
