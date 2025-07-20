import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routers.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<String> users = [
    //
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mes Commandes')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Row(
                  children: [
                    //
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'images/visuel-09.jpg',
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Commande #007125',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => context.pushNamed(Urls.order.name),
                      child: Icon(Icons.navigate_next, size: 32),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            );
            //
          },
        ),
      ),
    );
  }
}
