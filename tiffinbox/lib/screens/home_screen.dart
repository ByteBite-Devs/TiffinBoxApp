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
  List<Map<String, dynamic>> _tiffinServices = [];

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
      {'imagePath': 'assets/images/dal_rice_combo.jpg', 'offerText': ''},
      {'imagePath': 'assets/images/vegthali.jpg', 'offerText': ''},
      {'imagePath': 'assets/images/vegandelightbox.jpg', 'offerText': ''},
    ];

    _categories = [
      {'icon': Icons.eco, 'label': 'Veg'},
      {'icon': Icons.set_meal, 'label': 'Non Veg'},
      {'icon': Icons.spa, 'label': 'Vegan'},
      {'icon': Icons.set_meal, 'label': 'Fish'},
      {'icon': Icons.egg, 'label': 'Egg'},
    ];

    _tiffinServices = [
      {'imagePath': 'assets/images/img1.png', 'name': 'Tiffin Service 1', 'rating': 4.5},
      {'imagePath': 'assets/images/img1.png', 'name': 'Tiffin Service 2', 'rating': 4.0},
      {'imagePath': 'assets/images/img1.png', 'name': 'Tiffin Service 3', 'rating': 4.8},
      {'imagePath': 'assets/images/img1.png', 'name': 'Tiffin Service 4', 'rating': 4.2},
      {'imagePath': 'assets/images/img1.png', 'name': 'Tiffin Service 5', 'rating': 4.6},
      {'imagePath': 'assets/images/img1.png', 'name': 'Tiffin Service 6', 'rating': 4.3},
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: PageView(
                  children: [
                    _buildOfferCard('assets/images/landingimage1.jpg', ''),
                    _buildOfferCard('assets/images/landingimage2.jpg', ''),
                    _buildOfferCard('assets/images/landingimage3.jpg', ''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
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
              const SizedBox(height: 16),

              // Categories
              const Text(
                'Categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Category Icons
              GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: _filteredCategories.map((category) {
                  return _buildCategoryIcon(category['icon'], category['label']);
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Popular Tiffins Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Tiffins',
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
              const SizedBox(height: 12),

              // Popular Tiffins List
              Container(
                height: 220, // Adjust the height as needed
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTiffinCard(
                      'assets/images/dal_rice_combo.jpg',
                      'Dal Rice Combo',
                      4.5,
                      150,
                    ),
                    _buildTiffinCard(
                      'assets/images/vegthali.jpg',
                      'Veg Thali',
                      4.0,
                      200,
                    ),
                    _buildTiffinCard(
                      'assets/images/vegandelightbox.jpg',
                      'Vegan Delight Box',
                      4.8,
                      250,
                    ),
                  ],
                ),
              ),

              // Tiffin Services Heading
              const Text(
                'Tiffin Services',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Tiffin Services List
              Column(
                children: _tiffinServices.map((service) {
                  return _buildTiffinServiceCard(service['imagePath'], service['name'], service['rating']);
                }).toList(),
              ),
            ],
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

  Widget _buildTiffinCard(String imagePath, String name, double rating, double price) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: 150,
            height: 120,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '₹$price',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTiffinServiceCard(String imagePath, String name, double rating) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: double.infinity,  // Makes the image take the full width available
              height: 180,  // Increased height for a larger image
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          // Name and Rating
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
