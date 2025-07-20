import 'dart:convert';

OrderStatus orderStatusFromJson(String str) =>
    OrderStatus.fromJson(json.decode(str));
String orderStatusToJson(OrderStatus data) => json.encode(data.toJson());

class OrderStatus {
  final String orderId;
  final String status; // e.g. "pending", "processing", "completed"
  final DateTime lastUpdated;

  OrderStatus({
    required this.orderId,
    required this.status,
    required this.lastUpdated,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      orderId: json['orderId'],
      status: json['status'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'status': status,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}
