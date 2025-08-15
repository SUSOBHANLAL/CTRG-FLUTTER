// lib/models/contact_data.dart
class ContactData {
  final String id;
  final String address;
  final String email;
  final String website;
  final String developmentInfo;
  final String phone;
  final String socialMedia;
  final String contactHeader; // New field
  final String aboutAppHeader; // New field

  ContactData({
    required this.id,
    required this.address,
    required this.email,
    required this.website,
    required this.developmentInfo,
    required this.phone,
    required this.socialMedia,
    required this.contactHeader,
    required this.aboutAppHeader,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      id: json['_id'],
      address: json['address'],
      email: json['email'],
      website: json['website'],
      developmentInfo: json['Development'],
      phone: json['phone'],
      socialMedia: json['socialmedia'],
      contactHeader: json['contactHeader'],
      aboutAppHeader: json['aboutAppHeader'],
    );
  }
}
