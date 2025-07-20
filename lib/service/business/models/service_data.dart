import 'dart:convert';

String serviceDataToJson(ServiceData data) => json.encode(data.toJson());

class ServiceData {
  final String serviceId;
  final double amount;
  final String paymentMethod; // e.g. "mobile_money", "credit_card"

  ServiceData({
    required this.serviceId,
    required this.amount,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    'amount': amount,
    'paymentMethod': paymentMethod,
  };
}
