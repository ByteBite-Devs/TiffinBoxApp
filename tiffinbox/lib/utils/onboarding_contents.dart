class OnboardingContents {
  final String title;
  final String image;
    String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Browse endless Options",
    image: "assets/browse.png",
    desc: "Remember to keep track of your professional accomplishments.",
  ),
  OnboardingContents(
    title: "Quick and Easy Payment",
    image: "assets/payment.png",
    desc: "But understanding the contributions our colleagues make to our teams and companies.",
  ),
  OnboardingContents(
    title: "Seamless Order Tracking",
    image: "assets/tracking.png",
    desc: "Take control of notifications, collaborate live or on your own time.",
  ),
];