import 'package:flutter/material.dart';

class FoodMenuTabs extends StatefulWidget {
  @override
  _FoodMenuTabsState createState() => _FoodMenuTabsState();
}

class _FoodMenuTabsState extends State<FoodMenuTabs> {
  final List<String> categories = [
    'Offers',
    'Burger',
    'Pizza',
    'Donut',
    'Ice Cream',
    'Soft Drink',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedIndex = index;
                });
              },
              backgroundColor: Colors.grey[100],
              selectedColor: Colors.green[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      isSelected ? Colors.green.shade300 : Colors.grey.shade300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
