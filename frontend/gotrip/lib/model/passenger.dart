class Passenger {
  final int id;
  final String email;
  final String name;
  final int phone;
  final String? photo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Passenger({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.photo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      photo: json['photo'],
      createdAt: DateTime.parse(json['Created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'photo': photo,
      'Created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}