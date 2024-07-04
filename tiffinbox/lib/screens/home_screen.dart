import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiffinbox/screens/login_screen.dart';
import '../utils/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String? _location = "";
  String? _userName = "";
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredOffers = [];
  List<Map<String, dynamic>> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _loadInitialData();
  }

  Future<void> _loadUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            _location = userDoc['location'];
            _userName = userDoc['name'];
          });
        }
      }
    } catch (e) {
      print('Error loading user details: $e');
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _loadInitialData() {
    // Simulate fetching data from Firestore or another source
    _offers = [
      {'imagePath': 'assets/images/offer1.png', 'offerText': '40% OFF on Ice Cream'},
      {'imagePath': 'assets/images/offer2.png', 'offerText': 'Up to 60% OFF on Salads'},
      {'imagePath': 'assets/images/special_offer1.png', 'offerText': '50% OFF on Burgers'},
      {'imagePath': 'assets/images/special_offer2.png', 'offerText': 'Buy 1 Get 1 Free on Pizzas'},
    ];

    _categories = [
      {'icon': Icons.fastfood, 'label': 'Burger'},
      {'icon': Icons.local_pizza, 'label': 'Pizza'},
      {'icon': Icons.local_dining, 'label': 'Salad'},
      {'icon': Icons.local_cafe, 'label': 'Drink'},
      {'icon': Icons.cake, 'label': 'Dessert'},
      {'icon': Icons.ramen_dining, 'label': 'Noodles'},
      {'icon': Icons.icecream, 'label': 'Ice Cream'},
      {'icon': Icons.more_horiz, 'label': 'More'},
    ];

    _filteredOffers = _offers;
    _filteredCategories = _categories;
  }

  void _filterResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredOffers = _offers;
        _filteredCategories = _categories;
      });
    } else {
      setState(() {
        _filteredOffers = _offers
            .where((offer) => offer['offerText'].toLowerCase().contains(query.toLowerCase()))
            .toList();
        _filteredCategories = _categories
            .where((category) => category['label'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TiffinBox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deliver to',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        Text(
                          _location ?? 'Select Your Location',
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {
                        // Navigate to location selection screen
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Carousel for special offers
                Container(
                  height: 150,
                  child: PageView(
                    children: [
                      _buildOfferCard('assets/images/offer1.png', '40% OFF on Ice Cream'),
                      _buildOfferCard('assets/images/offer2.png', 'Up to 60% OFF on Salads'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Search Bar with Filter Button
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      onChanged: (value) {
                        _filterResults(value);
                      },
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          // Open filter dialog or menu
                          _showFilterDialog();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Category Icons
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _filteredCategories.map((category) {
                    return _buildCategoryIcon(category['icon'], category['label']);
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Special Offers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Special Offers',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all offers screen
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                Column(
                  children: _filteredOffers.map((offer) {
                    return _buildSpecialOfferItem(offer['imagePath'], offer['offerText']);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('Option 1'),
                value: false, // Add your filter option values here
                onChanged: (bool? value) {
                  // Handle filter option change
                },
              ),
              CheckboxListTile(
                title: const Text('Option 2'),
                value: false, // Add your filter option values here
                onChanged: (bool? value) {
                  // Handle filter option change
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // Apply filter changes
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOfferCard(String imagePath, String offerText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          offerText,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData iconData, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(iconData, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSpecialOfferItem(String imagePath, String offerText) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset(imagePath),
        title: Text(offerText),
        onTap: () {
          // Handle special offer tap
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const HomeScreen(),
  ));
}
