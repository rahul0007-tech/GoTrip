// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      paymentId: (json['payment_id'] as num).toInt(),
      pidx: json['pidx'] as String,
      amount: (json['amount'] as num).toInt(),
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'payment_id': instance.paymentId,
      'pidx': instance.pidx,
      'amount': instance.amount,
    };
