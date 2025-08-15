// lib/models/venue_data.dart
class VenueData {
  final String name;
  final String image;

  VenueData({required this.name, required this.image});

  factory VenueData.fromJson(Map<String, dynamic> json) {
    return VenueData(name: json['name'], image: json['image']);
  }
}
