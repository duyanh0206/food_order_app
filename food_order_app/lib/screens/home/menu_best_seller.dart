import 'package:flutter/material.dart';

class MenuBestSeller extends StatelessWidget {
  const MenuBestSeller({super.key});

  final List<Product> products = const [
    Product(
      name: 'Classic Burger',
      price: 12.75,
      rating: 4.7,
      image: 'assets/images/burger.png',
    ),
    Product(
      name: 'Cola',
      price: 3.99,
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
      name: 'Jumbo Beef Burger',
      price: 16.99,
      rating: 4.8,
      image: 'assets/images/snack.png',
    ),
    Product(
      name: 'Cola',
      price: 3.99,
      rating: 4.4,
      image: 'assets/images/salad.png',
    ),
    Product(
      name: 'Donut Box',
      price: 12.22,
      rating: 4.6,
      image: 'assets/images/meal.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        // To make sure we don't have overflow issues
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: products.length,
          physics: const BouncingScrollPhysics(),
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
      ),
    );
  }
}

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
              const SizedBox(height: 10),
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
              const SizedBox(height: 6),
              // Product Price and Add to Cart button
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
                      // TODO: Add to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Đã thêm "${product.name}" vào giỏ hàng!',
                          ),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFFDDF2D1),
                      child: Icon(Icons.add, color: Colors.green, size: 18),
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
