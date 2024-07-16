import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';

// Define a class for TiffinItem
class TiffinItem {
  final String name;
  final List<String> mealTypes;
  final String description;
  final String contents;
  final String assetPath;
  final double price;
  final int rating;
  final int reviews;

  TiffinItem({
    required this.name,
    required this.mealTypes,
    required this.description,
    required this.contents,
    required this.assetPath,
    required this.price,
    required this.rating,
    required this.reviews,
  });
}

// BusinessHomeScreen Widget
class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({Key? key}) : super(key: key);

  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  // List of TiffinItems
  List<TiffinItem> tiffinItems = [
    TiffinItem(
      name: 'Vegan Delight Box',
      mealTypes: ['Lunch'],
      description:
      'A delicious Vegan Delight Box featuring a variety of fresh vegetables, grains, and a delightful vegan patty.',
      contents: 'Avocado, Rice with some black seeds, Sprouts, Green vegetables, Vegan sauces',
      assetPath: 'assets/images/vegthali.jpg',
      price: 9.99,
      rating: 75,
      reviews: 4,
    ),
    TiffinItem(
      name: 'Healthy Protein Box',
      mealTypes: ['Dinner'],
      description:
      'A protein-packed box with lean meats, quinoa, and a selection of vegetables.',
      contents: 'Grilled chicken, Quinoa, Spinach, Bell peppers, Protein shake',
      assetPath: 'assets/images/paneerbiryani.jpg',
      price: 10.49,
      rating: 100,
      reviews: 4,
    ),
  ];

  // Variables to track meal type selection in Add/Edit dialog
  bool isLunchSelected = false;
  bool isDinnerSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TiffinBox'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: tiffinItems.isEmpty
          ? Center(
        child: ElevatedButton(
          onPressed: () => _addTiffinItem(),
          child: const Text('Start Adding Tiffins'),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ABC Tiffins',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () => _addTiffinItem(),
                  child: const Icon(Icons.add),
                  backgroundColor: Theme.of(context).primaryColor, // Primary color for the background
                  foregroundColor: Colors.white, // White color for the icon
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: tiffinItems.length,
              itemBuilder: (context, index) {
                final item = tiffinItems[index];
                return Card(
                  color: buttonnavbg, // Set background color to orangeGradientShade
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Image.asset(
                      item.assetPath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)} • ${item.rating}% (${item.reviews} reviews)',
                        ),
                        Text(item.mealTypes.join(', ')),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editTiffinItem(item),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBusinessBottomNavigationBar(currentIndex: 0),
    );
  }

  // Function to add a new TiffinItem
  void _addTiffinItem() {
    String name = '';
    List<String> mealTypes = [];
    String description = '';
    String contents = '';
    String assetPath = '';
    double price = 0.0;
    int rating = 0;
    int reviews = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Tiffin Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('Meal Type'),
                    CheckboxListTile(
                      title: const Text('Lunch'),
                      value: isLunchSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isLunchSelected = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Dinner'),
                      value: isDinnerSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isDinnerSelected = value ?? false;
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Description'),
                      onChanged: (value) => description = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Tiffin Contents'),
                      onChanged: (value) => contents = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Image Asset Path'),
                      onChanged: (value) => assetPath = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Rating'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => rating = int.tryParse(value) ?? 0,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Reviews'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => reviews = int.tryParse(value) ?? 0,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (name.isNotEmpty && description.isNotEmpty && contents.isNotEmpty && assetPath.isNotEmpty) {
                      setState(() {
                        if (isLunchSelected) mealTypes.add('Lunch');
                        if (isDinnerSelected) mealTypes.add('Dinner');
                        tiffinItems.add(TiffinItem(
                          name: name,
                          mealTypes: mealTypes,
                          description: description,
                          contents: contents,
                          assetPath: assetPath,
                          price: price,
                          rating: rating,
                          reviews: reviews,
                        ));
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to edit an existing TiffinItem
  void _editTiffinItem(TiffinItem item) {
    String name = item.name;
    List<String> mealTypes = List.from(item.mealTypes);
    String description = item.description;
    String contents = item.contents;
    String assetPath = item.assetPath;
    double price = item.price;
    int rating = item.rating;
    int reviews = item.reviews;

    isLunchSelected = mealTypes.contains('Lunch');
    isDinnerSelected = mealTypes.contains('Dinner');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Tiffin Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      controller: TextEditingController(text: name),
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('Meal Type'),
                    CheckboxListTile(
                      title: const Text('Lunch'),
                      value: isLunchSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isLunchSelected = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Dinner'),
                      value: isDinnerSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isDinnerSelected = value ?? false;
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Description'),
                      controller: TextEditingController(text: description),
                      onChanged: (value) => description = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Tiffin Contents'),
                      controller: TextEditingController(text: contents),
                      onChanged: (value) => contents = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Image Asset Path'),
                      controller: TextEditingController(text: assetPath),
                      onChanged: (value) => assetPath = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: price.toString()),
                      onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Rating'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: rating.toString()),
                      onChanged: (value) => rating = int.tryParse(value) ?? 0,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Reviews'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: reviews.toString()),
                      onChanged: (value) => reviews = int.tryParse(value) ?? 0,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      mealTypes.clear();
                      if (isLunchSelected) mealTypes.add('Lunch');
                      if (isDinnerSelected) mealTypes.add('Dinner');
                      final updatedItem = TiffinItem(
                        name: name,
                        mealTypes: mealTypes,
                        description: description,
                        contents: contents,
                        assetPath: assetPath,
                        price: price,
                        rating: rating,
                        reviews: reviews,
                      );
                      final index = tiffinItems.indexOf(item);
                      tiffinItems[index] = updatedItem;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      tiffinItems.remove(item);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
