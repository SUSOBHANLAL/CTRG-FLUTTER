// lib/models/home_data.dart
class HomeData {
  final String title;
  final String date;
  final String location;
  final String description;
  final String buttonText;
  final String eventLogo; // Added
  final String institutionLogo; // Added
  final String homepageLogo; // Added

  HomeData({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.buttonText,
    required this.eventLogo,
    required this.institutionLogo,
    required this.homepageLogo,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      title: json['title'],
      date: json['date'],
      location: json['location'],
      description: json['description'],
      buttonText: json['buttonText'],
      eventLogo: json['eventlogo'],
      institutionLogo: json['institutionlogo'],
      homepageLogo: json['homepagelogo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'location': location,
      'description': description,
      'buttonText': buttonText,
      'eventlogo': eventLogo,
      'institutionlogo': institutionLogo,
      'homepagelogo': homepageLogo,
    };
  }
}
