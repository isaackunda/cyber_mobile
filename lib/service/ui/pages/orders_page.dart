import 'package:cyber_mobile/service/ui/pages/order_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routers.dart';
import '../../business/models/order.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  late Future<List<Order>> futureOrders;
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    // Appelle une seule fois quand on ouvre la page
    Future.microtask(() {
      ref.read(orderCtrlProvider.notifier).getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderCtrlProvider).orders;

    return Scaffold(
      appBar: AppBar(title: Text('Mes Commandes')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: ListView.builder(
          // 👈 ICI le `return` ajouté
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index]; // 👈 tu peux utiliser l'item ici

            return Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: Image.asset(
                        'images/visuel-09.jpg',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.status, // 👈 par exemple
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '#${order.ref}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            order.date,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //const Spacer(),
                    GestureDetector(
                      onTap: () {
                        var ctrl = ref.read(orderCtrlProvider.notifier);
                        ctrl.viewOrder(order);

                        context.pushNamed(Urls.order.name);
                      },
                      child: const Icon(Icons.navigate_next, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            );
          },
        ),
      ),
    );
  }
}
