import 'package:cyber_mobile/service/business/models/order.dart';

class OrderState {
  final Order order;
  final List<Order> orders;

  OrderState({
    this.order = const Order(
      ref: 'N/A',
      image: 'N/A',
      status: 'N/A',
      link: 'N/A',
    ),
    this.orders = const [
    ],
  });

  OrderState copyWith({Order? order, List<Order>? orders}) {
    return OrderState(
      order: order ?? this.order,
      orders: orders ?? this.orders,
    );
  }
}
