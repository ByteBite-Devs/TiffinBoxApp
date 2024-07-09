import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';
 
class BrowseScreen extends StatelessWidget {
  const BrowseScreen({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search TiffinBox',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tiffins near you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildFoodCategory(
                    context,
                    'Dal Rice',
                    'assets/images/dal_rice_combo.jpg',
                  ),
                  _buildFoodCategory(
                    context,
                    'Paneer Biryani',
                    'assets/images/paneerbiryani.jpg',
                  ),
                  _buildFoodCategory(
                    context,
                    'Chicken Biryani',
                    'assets/images/chickenbiryani.jpg',
                  ),
                  _buildFoodCategory(
                    context,
                    'Veg Thali',
                    'assets/images/vegthali.jpg',
                  ),
                  _buildFoodCategory(
                    context,
                    'Vegan Delight Box',
                    'assets/images/vegandelightbox.jpg',
                  ),
                  _buildFoodCategory(
                    context,
                    'Seafood Extravaganza',
                    'assets/images/seafoodextravaganza.jpg',
                  ),
                  // _buildFoodCategory(
                  //   context,
                  //   'Fast Food',
                  //   'assets/images/fast_food.png',
                  // ),
                  // _buildFoodCategory(
                  //   context,
                  //   'Halal',
                  //   'assets/images/halal.png',
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
 
  Widget _buildFoodCategory(BuildContext context, String label, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed("/TiffinDetail");
        // Navigate to category-specific screen
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(
                    imagePath,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
 