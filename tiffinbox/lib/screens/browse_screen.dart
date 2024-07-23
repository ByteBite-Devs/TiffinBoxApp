import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/tiffindetails_screen.dart';
import 'package:tiffinbox/services/tiffin-service.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';

class BrowseScreen extends StatefulWidget {
  final String? mealType;
  final String? searchQuery;
  BrowseScreen({Key? key, this.mealType, this.searchQuery}) : super(key: key);

  @override
  _BrowseScreenState createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  double _ratingFilter = 3.0;
  bool _VegFilter = false;
  bool _veganFilter = false;
  bool _glutenFreeFilter = false;
  String _sortOption = 'Recommended';
  List<dynamic> _tiffins = [];
  List<dynamic> _filteredTiffins = [];
  late TextEditingController _searchController;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTiffins();
    _searchController = TextEditingController(text: widget.searchQuery);
    if(widget.mealType != null) {
      _applyMealTypeFilter();
    }
    if(_searchController.text.isNotEmpty) {
      _filterTiffins();
    }
  }

  _loadTiffins() async {
    var res = await TiffinService().getAllTiffins();
    if (res['status'] == 'success') {
      setState(() {
        _tiffins = res['tiffins'];
        _filterTiffins();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTiffinImages() async {
    try {
      var response = await TiffinService().getAllTiffins();
      if (response['status'] == 'success') {
        setState(() {
          _tiffins = response['tiffins'];
          _filterTiffins();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load tiffin images');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading tiffins. Please try again later.';
      });
    }
  }

  _applyMealTypeFilter() async {
    if (widget.mealType != null) {
      setState(() {
        if (widget.mealType == 'Veg') {
          _VegFilter = true;
        } else if (widget.mealType == 'Vegan') {
          _veganFilter = true;
        } else if (widget.mealType == 'Non-Veg') {
          _glutenFreeFilter = true;
        }
      });
        await _filterTiffins();
    }
  }

  _filterTiffins() async {
    setState(() {
      _filteredTiffins = _tiffins;
      // do filtering one after the other
      if (_VegFilter || _veganFilter || _glutenFreeFilter) {
      _filteredTiffins = _tiffins
          .where((tiffin) =>
          (_VegFilter && tiffin['dietType'] == 'Veg') ||
          (_veganFilter && tiffin['dietType'] == 'Vegan') ||  
          (_glutenFreeFilter && tiffin['dietType'] == 'Non-Veg'))
          .toList();
      }

      if (_searchController.text.isNotEmpty) {
        _filteredTiffins = _filteredTiffins
            .where((tiffin) =>
        tiffin['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
        tiffin['description'].toLowerCase().contains(_searchController.text.toLowerCase())
        || (tiffin['contents'] != null && (tiffin['contents'] as List)
            .any((content) => content['name'].toLowerCase().contains(_searchController.text.toLowerCase())))
        ).toList();
      }

      if (_ratingFilter != 3.0) {
        _filteredTiffins = _filteredTiffins
            .where((tiffin) => tiffin['rating'] >= _ratingFilter)
            .toList();
      }
      _sortTiffins();
      });
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
                    _filterTiffins();
                  },
                  child: const Text('Apply' , style: TextStyle(color: whiteText)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarycolor,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _ratingFilter = 3.0;
                      _filterTiffins();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Reset', style: TextStyle(color: whiteText)),
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
                  title: const Text('Veg'),
                  value: _VegFilter,
                  onChanged: (value) {
                    setState(() {
                      _VegFilter = value ?? false;
                      _filterTiffins();
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Vegan'),
                  value: _veganFilter,
                  onChanged: (value) {
                    setState(() {
                      _veganFilter = value ?? false;
                      _filterTiffins();
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Non-Veg'),
                  value: _glutenFreeFilter,
                  onChanged: (value) {
                    setState(() {
                      _glutenFreeFilter = value ?? false;
                      _filterTiffins();
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _filterTiffins();
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
                      _VegFilter = false;
                      _veganFilter = false;
                      _glutenFreeFilter = false;
                      _filterTiffins();
                    });
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
                ListTile(
                  title: const Text('Recommended'),
                  leading: Radio<String>(
                    value: 'Recommended',
                    groupValue: _sortOption,
                    onChanged: (value) {
                      setState(() {
                        _sortOption = value!;
                        _filterTiffins();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Price: Low to High'),
                  leading: Radio<String>(
                    value: 'Price: Low to High',
                    groupValue: _sortOption,
                    onChanged: (value) {
                      setState(() {
                        _sortOption = value!;
                        _filterTiffins();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Price: High to Low'),
                  leading: Radio<String>(
                    value: 'Price: High to Low',
                    groupValue: _sortOption,
                    onChanged: (value) {
                      setState(() {
                        _sortOption = value!;
                        _filterTiffins();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Rating: High to Low'),
                  leading: Radio<String>(
                    value: 'Rating: High to Low',
                    groupValue: _sortOption,
                    onChanged: (value) {
                      setState(() {
                        _sortOption = value!;
                        _filterTiffins();
                      });
                    },
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

  void _sortTiffins() {
    setState(() {
      if (_sortOption == 'Price: Low to High') {
        _filteredTiffins.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (_sortOption == 'Price: High to Low') {
        _filteredTiffins.sort((a, b) => b['price'].compareTo(a['price']));
      } else if (_sortOption == 'Rating: High to Low') {
        _filteredTiffins.sort((a, b) => b['rating'].compareTo(a['rating']));
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _ratingFilter = 3.0;
      _VegFilter = false;
      _veganFilter = false;
      _glutenFreeFilter = false;
      _sortOption = 'Recommended';
      _searchController.clear();
      _filteredTiffins = _tiffins;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterTiffins();
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterTiffins();
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TextButton(
                  onPressed: _openRatingFilter,
                  child: const Text('Rating' , style: TextStyle(color: whiteText)),
                  style: TextButton.styleFrom(
                    backgroundColor: primarycolor,
                    side: const BorderSide(color: primarycolor),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _openDietaryFilter,
                  child: const Text('Dietary' , style: TextStyle(color: whiteText)),
                  style: TextButton.styleFrom(
                    backgroundColor: primarycolor,
                    side: const BorderSide(color: primarycolor),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _openSortOptions,
                  child: const Text('Sort by' , style: TextStyle(color: whiteText)),
                  style: TextButton.styleFrom(
                    backgroundColor: primarycolor,
                    side: const BorderSide(color: primarycolor),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear Filters' , style: TextStyle(color: whiteText)),
                  style: TextButton.styleFrom(
                    backgroundColor: primarycolor,
                    side: const BorderSide(color: primarycolor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (_filteredTiffins.isEmpty)
            const Text('No tiffins found.'),
          const SizedBox(height: 8),
          if (_filteredTiffins.isNotEmpty)

            Expanded(
            child: GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: _filteredTiffins.map(
                  (tiffin) {
                    return _buildFoodCategory(context, tiffin);
                  }
                ).toList()
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  
  Widget _buildFoodCategory(BuildContext context, dynamic tiffin) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TiffinDetailScreen(
              tiffinId: tiffin['id'],
            ),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                    tiffin['images'] != null && tiffin['images'].isNotEmpty 
                      ? tiffin['images'][0]
                      : 'https://via.placeholder.com/150',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tiffin['name'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}