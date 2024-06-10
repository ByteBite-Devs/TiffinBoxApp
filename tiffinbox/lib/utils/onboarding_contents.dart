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
    title: "Browse Endless Options",
    image: "assets/browse.png",
    desc: "",
  ),
  OnboardingContents(
    title: "Quick and Easy Payment",
    image: "assets/payment.png",
    desc: "",
  ),
  OnboardingContents(
    title: "Seamless Order Tracking",
    image: "assets/tracking.png",
    desc: "",
  ),
];