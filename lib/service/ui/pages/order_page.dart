import 'package:cyber_mobile/account/ui/pages/login_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<OrderPage> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(loginCtrlProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Commande Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.03),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      //
                      Text(
                        'Commande #23456789',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Text(
                        'Status',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Text(
                        'En attente',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Text(
                        'Pages',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Text(
                        '2',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Text(
                        '\$ 25.00',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    children: [
                      //
                      Text(
                        'Pages',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Container(
                        width: 175,
                      height: 225,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.grey[100],
                        ),
                      ),
                      /*Text(
                        'En attente',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          overflow:
                              TextOverflow.ellipsis, // si jamais ça déborde
                        ),
                      ),*/
                      Spacer()
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
