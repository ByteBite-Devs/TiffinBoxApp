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
    image: "assets/images/browse.png",
    desc: "",
  ),
  OnboardingContents(
    title: "Quick and Easy Payment",
    image: "assets/images/payment.png",
    desc: "",
  ),
  OnboardingContents(
    title: "Seamless Order Tracking",
    image: "assets/images/tracking.png",
    desc: "",
  ),
];