import 'package:flutter/material.dart';
import 'package:tiffinbox/services/profile-service.dart';
import 'package:tiffinbox/widgets/drawer.dart';
import '../utils/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
      var response = await ProfileService().getProfileDetails();
      if (response['status'] == 'success') {
        var userData = response['user'];
        setState(() {
          _location = userData['location'];
          _userName = userData['name'];
        });
      }    
    } catch (e) {
      print('Error loading user details: $e');
    }
  }

  void _loadInitialData() {
    _offers = [
      {'imagePath': 'assets/images/dal_rice_combo.jpg', 'offerText': ''},
      {'imagePath': 'assets/images/vegthali.jpg', 'offerText': ''},
      {'imagePath': 'assets/images/vegandelightbox.jpg', 'offerText': ''},
    ];

    _categories = [
      {'icon': Icons.eco, 'label': 'Vegetarian'},
      {'icon': Icons.set_meal, 'label': 'Non Vegetarian'},
      {'icon': Icons.spa, 'label': 'Vegan'},
      {'icon': Icons.set_meal, 'label': 'Fish'},
      {'icon': Icons.egg, 'label': 'Egg'},
    ];

    _tiffinServices = [
      {
        'imagePath': 'assets/images/img1.png',
        'name': 'Tiffin Service 1',
        'rating': 4.5
      },
      {
        'imagePath': 'assets/images/img1.png',
        'name': 'Tiffin Service 2',
        'rating': 4.0
      },
      {
        'imagePath': 'assets/images/img1.png',
        'name': 'Tiffin Service 3',
        'rating': 4.8
      },
      {
        'imagePath': 'assets/images/img1.png',
        'name': 'Tiffin Service 4',
        'rating': 4.2
      },
      {
        'imagePath': 'assets/images/img1.png',
        'name': 'Tiffin Service 5',
        'rating': 4.6
      },
      {
        'imagePath': 'assets/images/img1.png',
        'name': 'Tiffin Service 6',
        'rating': 4.3
      },
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
            .where((offer) =>
                offer['offerText'].toLowerCase().contains(query.toLowerCase()))
            .toList();
        _filteredCategories = _categories
            .where((category) =>
                category['label'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi, ${_userName ?? 'Guest'}"),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                tooltip: 'Menu',
              );
            },
          ),
        ],
      ),
      endDrawer: const MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
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
              const SizedBox(height: 16),

              // Horizontal Category List
              Container(
                height:
                    100, // Adjust the height to fit the category icons and labels
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _filteredCategories.map((category) {
                    return _buildCategoryIcon(
                        category['icon'], category['label']);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 5),

              // Popular Tiffins Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Tiffins',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      // Navigate to the view all page or perform desired action
                      Navigator.pushNamed(
                          context, '/Browse'); // Example navigation
                    },
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
                  return _buildTiffinServiceCard(
                      service['imagePath'], service['name'], service['rating']);
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
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData iconData, String label) {
    return Container(
      width: 80, // Adjust width to fit content and spacing
      margin:
          const EdgeInsets.symmetric(horizontal: 8), // Space between categories
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(iconData, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center, // Center align the text
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTiffinCard(String imagePath, String name, double rating, double price) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to the ends
                children: [
                  Text(
                    '₹$price',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 55),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontSize: 12,),
                      ),
                    ],
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
              width: double
                  .infinity, // Makes the image take the full width available
              height: 180, // Increased height for a larger image
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
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
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
