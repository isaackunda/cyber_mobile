import 'package:cyber_mobile/database_helper.dart';
import 'package:cyber_mobile/service/business/models/order.dart';
import 'package:cyber_mobile/service/ui/pages/order_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_ctrl.g.dart';

@riverpod
class OrderCtrl extends _$OrderCtrl {
  @override
  OrderState build() {
    return OrderState();
  }

  void addOrder(Order order) async {
    //
    final now = DateTime.now();
    final formatted1 = DateFormat('dd-MM-yyyy à HH:mm').format(now);

    debugPrint('First Brod 1');
    debugPrint('First Brod');

    await DatabaseHelper.instance.insertOrder(
      ref: order.ref,
      status: order.status,
      nbreDePages: order.nbreDePages,
      total: order.total,
      date: formatted1,
    );
  }

  Future<int> updateOrder(String ref) async {
    final db = await DatabaseHelper.instance.database;

    return await db.update(
      'orders',
      {'status': 'complété'},
      where: 'ref = ?',
      whereArgs: [ref],
    );
  }

  Future<List<Order>> getAllOrders() async {
    debugPrint('First Brod 2');
    final db = await DatabaseHelper.instance.database;

    final result = await db.query('orders', orderBy: 'date DESC');
    final orders = result.map((map) => Order.fromMap(map)).toList();

    state = state.copyWith(orders: orders); // ✅ ici tu mets les bonnes données

    return orders;
  }

  void viewOrder(Order data) async {
    state = state.copyWith(order: data);
  }
}
