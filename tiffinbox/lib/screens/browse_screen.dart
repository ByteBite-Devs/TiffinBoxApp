import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/tiffindetails_screen.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
 
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);
 
  @override
  _BrowseScreenState createState() => _BrowseScreenState();
}
 
class _BrowseScreenState extends State<BrowseScreen> {
  double _ratingFilter = 3.0;
  bool _vegetarianFilter = false;
  bool _veganFilter = false;
  bool _glutenFreeFilter = false;
  String _sortOption = 'Recommended';
  List<Map<String, dynamic>> _tiffins = [];
 
  @override
  void initState() {
    super.initState();
    _loadTiffinImages();
  }
 
  Future<void> _loadTiffinImages() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.56.1:8000/api/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _tiffins = List<Map<String, dynamic>>.from(data['tiffins']);
        });
      } else {
        print('Failed to load tiffin images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading tiffin images: $e');
    }
  }
 
  void _openRatingFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Rating',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primarycolor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Slider(
                  value: _ratingFilter,
                  onChanged: (value) {
                    setState(() {
                      _ratingFilter = value;
                    });
                  },
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _ratingFilter.toString(),
                  activeColor: primarycolor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                        (index) => Text(
                      '${index * 1.0}',
                      style: TextStyle(
                        fontSize: 12,
                        color: index * 1.0 == _ratingFilter ? primarycolor : Colors.black,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarycolor,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _ratingFilter = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
 
  void _openDietaryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Dietary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primarycolor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Vegetarian'),
                  value: _vegetarianFilter,
                  onChanged: (value) {
                    setState(() {
                      _vegetarianFilter = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Vegan'),
                  value: _veganFilter,
                  onChanged: (value) {
                    setState(() {
                      _veganFilter = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Non-Veg'),
                  value: _glutenFreeFilter,
                  onChanged: (value) {
                    setState(() {
                      _glutenFreeFilter = value ?? false;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarycolor,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _vegetarianFilter = false;
                      _veganFilter = false;
                      _glutenFreeFilter = false;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
 
  void _openSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text(
                    'Sort by',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primarycolor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                RadioListTile(
                  title: const Text('Price'),
                  value: 'Price',
                  groupValue: _sortOption,
                  onChanged: (value) {
                    setState(() {
                      _sortOption = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Rating'),
                  value: 'Rating',
                  groupValue: _sortOption,
                  onChanged: (value) {
                    setState(() {
                      _sortOption = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Earliest arrival'),
                  value: 'Earliest arrival',
                  groupValue: _sortOption,
                  onChanged: (value) {
                    setState(() {
                      _sortOption = value.toString();
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarycolor,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _sortOption = 'Recommended';
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
 
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
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _openRatingFilter(),
                      child: const Text('Rating'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _openDietaryFilter(),
                      child: const Text('Dietary'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _openSortOptions(),
                      child: const Text('Sort'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                        ),
                      ),
                    ),
                  ],
                ),
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
                children: _tiffins.map((tiffin) {
                  return _buildFoodCategory(
                    context,
                    tiffin['name'] ?? '',
                    tiffin['imagePath'] ?? '',
                    tiffin['id']
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
 
  Widget _buildFoodCategory(BuildContext context, String label, String imagePath, String id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TiffinDetailScreen(
              tiffinId: id,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imagePath),
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