import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiffinbox/screens/cart_screen.dart';
import 'package:tiffinbox/services/cart-service.dart';
import 'package:tiffinbox/services/tiffin-service.dart';
import 'package:tiffinbox/utils/constants/color.dart';

class TiffinDetailScreen extends StatefulWidget {
  final String tiffinId;

  const TiffinDetailScreen({Key? key, required this.tiffinId}) : super(key: key);

  @override
  _TiffinDetailScreenState createState() => _TiffinDetailScreenState();
}

class _TiffinDetailScreenState extends State<TiffinDetailScreen> {
  int quantity = 1;
  int initialVisibleReviews = 3;
  int visibleReviews = 3;
  bool showMoreEnabled = true;
  bool isAddedToCart = false; // Track if item is added to cart
  TiffinService tiffinService = TiffinService();
  dynamic tiffin;

  @override
  void initState() {
    super.initState();
    _fetchTiffinDetails();
  }

  Future<void> _fetchTiffinDetails() async {
    var response = await tiffinService.getTiffinDetails(widget.tiffinId);
    if (response['status'] == 'success') {
      setState(() {
        tiffin = response['tiffin'];
      });
    } else {
      throw Exception('Failed to load tiffin details');
    }
  }

  void _addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
  if (tiffin['name'] != null && tiffin['price'] != null) {
    cartProvider.addItem(tiffin['name'], tiffin['price'], tiffin['images'], quantity: quantity);
    setState(() {
      isAddedToCart = true; // Update state to indicate item is added
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$quantity ${tiffin['name']} added to cart')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: tiffin['images'] != null ? tiffin['images'].length : 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          tiffin['images']![index],
                          fit: BoxFit.fitWidth,
                          ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tiffin['name'] ?? '',
                      style: const TextStyle(
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
                  children: [
                    const Text(
                      '\$10.99',
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '\$${tiffin['price']}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    Spacer(),
                    const Text(
                      '5.0',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    const Text('(1205)'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  tiffin['description'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // list all the contents of the tiffin dynamically
                _buildTiffinContents(tiffin),
                const SizedBox(height: 8),
                
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
                    Text(
                      'Quantity: $quantity',
                      style: const TextStyle(fontSize: 16),
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
                    constraints: BoxConstraints(maxWidth: 150),
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
                        foregroundColor: Colors.white,
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
          child: SizedBox(
            width: double.infinity, // Forces the button to take full available width
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: isAddedToCart ? Colors.grey : primarycolor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(
                isAddedToCart ? 'View Cart' : 'Add to Basket',
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: isAddedToCart
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    }
                  : _addToCart,
            ),
          ),
        ),
      ),
    );
  }

  _buildTiffinContents(tiffin) {
    // list all the contents name and quatity if they are exiting
    if (tiffin['contents'] != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Contents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          for (var content in tiffin['contents'])
            Text('${content['name']}: ${content['quantity']}'),
        ],
      );
    }

    return Container();
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
