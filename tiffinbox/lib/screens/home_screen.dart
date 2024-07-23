import 'package:flutter/material.dart';
import 'package:tiffinbox/common/location_manager.dart';
import 'package:tiffinbox/screens/browse_screen.dart';
import 'package:tiffinbox/screens/business-details-screen.dart';
import 'package:tiffinbox/screens/saved-addresses.dart';
import 'package:tiffinbox/services/home-service.dart';
import 'package:tiffinbox/services/profile-service.dart';
import 'package:tiffinbox/widgets/drawer.dart';
import '../utils/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  final location;
  const HomeScreen({super.key, this.location});

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
  List<dynamic> _tiffinServices = [];
  HomeServie homeServie = HomeServie();
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData().then(
      (value) {
        setState(() {
          isDataLoaded = value;
        });
      });
  }
  _loadCurrentLocation() async {
    LocationManager.shared.initLocation();

    var currentPosition = LocationManager.shared.currentPos;

    // conver currentPos to accurate string addreess
    if (currentPosition != null) {
      await LocationManager.shared
          .convertLatLongToAddress(currentPosition.latitude, currentPosition.longitude)
          .then((address) {
        setState(() {
          _location = address;
          if (widget.location != null) {
            _location =  widget.location['addressLine1'] + ' ' + widget.location['addressLine2'];
          }
        });
      });
    }
    else {
      // get last location
      var lastPosition = await LocationManager.shared.getLastKnownPosition();
      if (lastPosition != null) {
        await LocationManager.shared
            .convertLatLongToAddress(lastPosition.latitude, lastPosition.longitude)
            .then((address) {
          setState(() {
            _location = address;
          });
        });
      }
    }
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

  Future<bool> _loadInitialData() async {
    await _loadUserDetails();
    await _loadCurrentLocation();
    _offers = [
      {'imagePath': 'assets/images/dal_rice_combo.jpg', 'offerText': ''},
      {'imagePath': 'assets/images/vegthali.jpg', 'offerText': ''},
      {'imagePath': 'assets/images/vegandelightbox.jpg', 'offerText': ''},
    ];

    _categories = [
      {'icon': Icons.eco, 'label': 'Veg'},
      {'icon': Icons.set_meal, 'label': 'Non-Veg'},
      {'icon': Icons.spa, 'label': 'Vegan'},
      {'icon': Icons.set_meal, 'label': 'Fish'},
      {'icon': Icons.egg, 'label': 'Egg'},
    ];

    var response = await homeServie.getData();
    if (response['status'] == 'success') {
      setState(() {
        _tiffinServices = response['businesses'];
        _filteredOffers = _offers;
        _filteredCategories = _categories;
      });
    }

    return true;
  }

  void _filterResults(String query) {
    if (query.isEmpty) {
      return;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute
          (builder: (context) => BrowseScreen(
            mealType: '',
            searchQuery: query,
          )),
      );
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
      body: isDataLoaded ?  SafeArea(
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddressScreen()),
                            );
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
                      onSubmitted: (value) {
                        _filterResults(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Categories',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

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
                      children: [
                  //   iterate through _tiffinService and create each child
                        for (var service in _tiffinServices)
                          _buildTiffinServiceCard(
                            service['image'],
                            service['business_name'],
                      service['rating'],
                            service['id'],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
      )
      : const Center(child: CircularProgressIndicator()),
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
    return GestureDetector(
      onTap: () {
        print(label);
        if (label == 'Veg' || label == 'Non-Veg' || label == 'Vegan') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrowseScreen(
              mealType: label,
              searchQuery: '',
            ),
          ),
        );
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrowseScreen(
              mealType: '',
              searchQuery: label,
            ),
          ),
        );
      }
      },
      child:Container(
      width: 80, // Adjust width to fit content and spacing
      margin:
      const EdgeInsets.symmetric(horizontal: 8), // Space between categories
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    )
    );
  }

  Widget _buildTiffinCard(String imagePath, String name, double rating,
      double price) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Align items to the ends
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


  Widget _buildTiffinServiceCard(String imagePath, String name, double? rating,
      String id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailsScreen(
              businessId: id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(rating.toString(),
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}