// models/user_response.dart

class UserResponse {
  final String message;
  final User user;
  final dynamic driverDetails;
  final double accuracyLevelAndroid;
  final double accuracyLevelIos;
  final int refreshRate;

  UserResponse({
    required this.message,
    required this.user,
    this.driverDetails,
    required this.accuracyLevelAndroid,
    required this.accuracyLevelIos,
    required this.refreshRate,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      message: json['message'],
      user: User.fromJson(json['user']),
      driverDetails: json['driverDetails'],
      accuracyLevelAndroid: json['accuracyLevelAndroid']?.toDouble() ?? 0.0,
      accuracyLevelIos: json['accuracyLevelIos']?.toDouble() ?? 0.0,
      refreshRate: json['refreshRate'] ?? 20,
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final bool genderBasisFilter;
  final String otp;
  final String? mpin;
  final String deviceId;
  final String phone;
  final String? deviceChangeToken;
  final String? deviceChangeExpires;
  final String address;
  final int userToUserFareAmount;
  final String dateOfBirth;
  final String gender;
  final String userRole;
  final String createdAt;
  final bool isVerified;
  final bool manualVerification;
  final bool carpooling;
  final bool isMoWo;
  final String? organization;
  final String color;
  final bool shuttleService;
  final int rating;
  final String? fcmToken;
  final String? image;
  final String? paymentQRcode;
  final int v;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.genderBasisFilter,
    required this.otp,
    this.mpin,
    required this.deviceId,
    required this.phone,
    this.deviceChangeToken,
    this.deviceChangeExpires,
    required this.address,
    required this.userToUserFareAmount,
    required this.dateOfBirth,
    required this.gender,
    required this.userRole,
    required this.createdAt,
    required this.isVerified,
    required this.manualVerification,
    required this.carpooling,
    required this.isMoWo,
    this.organization,
    required this.color,
    required this.shuttleService,
    required this.rating,
    this.fcmToken,
    this.image,
    this.paymentQRcode,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      genderBasisFilter: json['genderBasisFilter'] ?? false,
      otp: json['otp'],
      mpin: json['mpin'],
      deviceId: json['deviceId'],
      phone: json['phone'],
      deviceChangeToken: json['deviceChangeToken'],
      deviceChangeExpires: json['deviceChangeExpires'],
      address: json['address'],
      userToUserFareAmount: json['userToUserFareAmount'] ?? 0,
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      userRole: json['userRole'],
      createdAt: json['createdAt'],
      isVerified: json['isVerified'] ?? false,
      manualVerification: json['manualVerification'] ?? false,
      carpooling: json['carpooling'] ?? false,
      isMoWo: json['isMoWo'] ?? false,
      organization: json['organization'],
      color: json['color'],
      shuttleService: json['shuttleService'] ?? false,
      rating: json['rating'] ?? 0,
      fcmToken: json['fcmToken'],
      image: json['image'],
      paymentQRcode: json['paymentQRcode'],
      v: json['__v'] ?? 0,
    );
  }
}
