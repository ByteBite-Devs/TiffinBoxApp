import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/color.dart';

class TiffinDetailScreen extends StatefulWidget {
  const TiffinDetailScreen({Key? key}) : super(key: key);

  @override
  _TiffinDetailScreenState createState() => _TiffinDetailScreenState();
}

class _TiffinDetailScreenState extends State<TiffinDetailScreen> {
  int quantity = 1;
  int initialVisibleReviews = 3;
  int visibleReviews = 3;
  bool showMoreEnabled = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.pop(context);
        return true; // Return true to allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Detail'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/vegandelightbox.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Vegan Delight Box',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '\$10.00',
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '\$6.00',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '4.9',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text('(1205)'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'A delicious Vegan Delight Box featuring a variety of fresh vegetables, grains, and a delightful vegan patty. Served with a side of vegan-friendly sauces, this box is perfect for those who crave a healthy and tasty meal.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tiffin Contents:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Avocado\n• Rice with some black seeds\n• Sprouts\n• Green vegetables\n• Vegan sauces',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quantity:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Vegan Delight Box',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) quantity--;
                            });
                          },
                        ),
                        Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reviews:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: _buildReviewWidgets(),
                  ),
                ),
                if (_allReviews.length > initialVisibleReviews)
                  Container(
                    constraints: BoxConstraints(maxWidth: 150), // Adjust maxWidth as needed
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (showMoreEnabled) {
                            if (visibleReviews + 5 >= _allReviews.length) {
                              visibleReviews = _allReviews.length;
                              showMoreEnabled = false;
                            } else {
                              visibleReviews += 5;
                            }
                          } else {
                            visibleReviews = initialVisibleReviews;
                            showMoreEnabled = true;
                          }
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        textStyle: TextStyle(fontSize: 12),
                        foregroundColor: Colors.white, // Set text color to white
                      ),
                      child: Text(showMoreEnabled ? 'Show More' : 'Show Less'),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primarycolor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text(
              'Add to Basket',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              // Handle add to basket
            },
          ),
        ),
      ),
    );
  }

  List<String> _allReviews = [
    'Delicious box! Highly recommend.',
    'Great taste, but a bit pricey.',
    'Loved the flavors, will order again.',
    'Fresh and tasty, perfect for a quick lunch.',
    'Could use a bit more seasoning, but overall good.',
    'Best vegan meal I\'ve had in a while!',
    'Amazing taste and very fresh.',
    'Good portion size and nutritious.',
    'Variety of flavors in every bite.',
    'Highly satisfied with the quality.'
  ];

  List<Widget> _buildReviewWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < visibleReviews && i < _allReviews.length; i++) {
      widgets.add(_buildReview('Reviewer $i', _allReviews[i], (i % 5) + 1));
    }
    return widgets;
  }

  Widget _buildReview(String reviewer, String review, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.person,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reviewer,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(review),
              ],
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.yellow,
                size: 16,
              );
            }),
          ),
        ],
      ),
    );
  }
}
