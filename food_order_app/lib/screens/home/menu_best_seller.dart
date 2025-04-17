import 'package:flutter/material.dart';

// Product Model
class Product {
  final String name;
  final double price;
  final double rating;
  final String image;

  const Product({
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
  });
}

const List<Product> products = [
  Product(
    name: 'Classic Burger',
    price: 12.75,
    rating: 4.7,
    image: 'assets/images/burger.png',
  ),
  Product(
    name: 'Shrimp Salad',
    price: 16.99,
    rating: 4.7,
    image: 'assets/images/salad.png',
  ),
  Product(
    name: 'Donut Box',
    price: 11.04,
    rating: 4.6,
    image: 'assets/images/meal.png',
  ),
  Product(
    name: ' Burger King',
    price: 13.99,
    rating: 4.8,
    image: 'assets/images/snack.png',
  ),
  Product(
    name: 'Mushroom Risotto',
    price: 17.65,
    rating: 5,
    image: 'assets/images/chocolate_brownie.png',
  ),
  Product(
    name: 'Broccoli Lasagna',
    price: 15.22,
    rating: 4.9,
    image: 'assets/images/broccoli_lasagna.png',
  ),
];

// Menu Best Seller Widget
class MenuBestSeller extends StatelessWidget {
  const MenuBestSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: products.length,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}

// Product Card Widget
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Product Name
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Price & Add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You just added "${product.name}" to your cart!',
                          ),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFFDDF2D1),
                      child: Icon(Icons.add, color: Colors.green, size: 10),
                    ),
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
