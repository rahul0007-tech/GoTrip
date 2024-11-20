import 'dart:ffi';

class Passenger {
  String passengerName;
  int passengerPhone;
  String passengerEmail;
  String passengerPassword;
  String passengerOtp;
  Bool passengerVerified;

  Passenger({
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerEmail,
    required this.passengerPassword,
    required this.passengerOtp,
    required this.passengerVerified
  });
}