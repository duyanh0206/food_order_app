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
      backgroundColor: Colors.white70,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
