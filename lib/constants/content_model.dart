class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingContent> contents = [
  OnboardingContent(
      title: 'Welcome to QuNot',
      image: 'assets/images/onboardingscreen1.png',
      description: "Earn while you commute! With QuNot, you can turn your daily drive into an opportunity to pick up passengers heading in your direction. Start monetizing your travel time today!" ),
  OnboardingContent(
      title:  "Pick up Passengers on Your Way",
      image: 'assets/images/onboardingscreen2.jpg',
      description: "Connect with passengers traveling in the same direction as you. Get matched with riders heading to destinations along your route. Increase your income and help commuters reach their destinations conveniently." ),
  OnboardingContent(
      title: "Flexible and Reliable Earnings",
      image: 'assets/images/onboardingscreen3.png',
      description: "Set your own schedule and choose when and how many passengers you want to pick up. Enjoy the flexibility of earning extra income during your regular commute. QuNot provides a reliable platform for seamless transactions and secure payments." ),
];
