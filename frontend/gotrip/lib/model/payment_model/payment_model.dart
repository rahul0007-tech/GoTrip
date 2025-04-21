import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
    @JsonKey(name: "payment_id")
    final int paymentId;
    
    @JsonKey(name: "pidx", defaultValue: "")
    final String pidx;
    
    @JsonKey(name: "amount")
    final int amount;
    
    @JsonKey(name: "status", defaultValue: "initiated")
    final String status;

    PaymentModel({
        required this.paymentId,
        required this.pidx,
        required this.amount,
        required this.status,
    });

    factory PaymentModel.fromJson(Map<String, dynamic> json) {
        return PaymentModel(
            paymentId: json['payment_id'] as int,
            pidx: (json['pidx'] ?? '').toString(),
            amount: (json['amount'] is num) ? (json['amount'] as num).toInt() : 0,
            status: json['status'] as String? ?? 'initiated',
        );
    }

    Map<String, dynamic> toJson() => {
        'payment_id': paymentId,
        'pidx': pidx,
        'amount': amount,
        'status': status,
    };
}
