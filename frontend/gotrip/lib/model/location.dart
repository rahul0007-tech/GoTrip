class Location {
  final int id;
  final String name;
  final String fare;
  final String? locationImage;

  Location({
    required this.id,
    required this.name,
    required this.fare,
    this.locationImage,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      fare: json['fare'],
      locationImage: json['location_image'],
    );
  }
}