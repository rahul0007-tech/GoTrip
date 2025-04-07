import 'package:json_annotation/json_annotation.dart';


part 'payment_model.g.dart';


@JsonSerializable()
class PaymentModel {
    @JsonKey(name: "payment_id")
    final int paymentId;
    @JsonKey(name: "pidx")
    final String pidx;
    @JsonKey(name: "amount")
    final int amount;

    PaymentModel({
        required this.paymentId,
        required this.pidx,
        required this.amount
    });

    factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

    Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
