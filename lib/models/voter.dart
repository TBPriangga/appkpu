class Voter {
  final int? id;
  final String nik;
  final String name;
  final String phone;
  final String gender;
  final DateTime registrationDate;
  final String address;
  final String? imagePath;
  final double? latitude;
  final double? longitude;

  Voter({
    this.id,
    required this.nik,
    required this.name,
    required this.phone,
    required this.gender,
    required this.registrationDate,
    required this.address,
    this.imagePath,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nik': nik,
      'name': name,
      'phone': phone,
      'gender': gender,
      'registrationDate': registrationDate.toIso8601String(),
      'address': address,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Voter.fromMap(Map<String, dynamic> map) {
    return Voter(
      id: map['id'],
      nik: map['nik'],
      name: map['name'],
      phone: map['phone'],
      gender: map['gender'],
      registrationDate: DateTime.parse(map['registrationDate']),
      address: map['address'],
      imagePath: map['imagePath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
