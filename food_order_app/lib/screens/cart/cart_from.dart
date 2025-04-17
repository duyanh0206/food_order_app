import 'package:flutter/material.dart';

class CartFrom extends StatefulWidget {
  const CartFrom({super.key});

  @override
  State<CartFrom> createState() => _CartFromState();
}

class _CartFromState extends State<CartFrom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/cart1.png', fit: BoxFit.cover),
            const SizedBox(width: 10),
            const Text(
              'Food Order',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
