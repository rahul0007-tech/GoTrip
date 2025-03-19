import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
    @JsonKey(name: "id")
    final int id;
    @JsonKey(name: "passenger")
    final int passenger;
    @JsonKey(name: "pickup_location")
    final String pickupLocation;
    @JsonKey(name: "dropoff_location")
    final String dropoffLocation;
    @JsonKey(name: "fare")
    final String fare;
    @JsonKey(name: "booking_for")
    final DateTime? bookingFor;

    BookingModel({
        required this.id,
        required this.passenger,
        required this.pickupLocation,
        required this.dropoffLocation,
        required this.fare,
        required this.bookingFor,
    });

    factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

    Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}