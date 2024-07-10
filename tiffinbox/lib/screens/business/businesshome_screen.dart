import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';

// Define a class for TiffinItem
class TiffinItem {
  final String name;
  final List<String> mealTypes;
  final String description;
  final String contents;

  TiffinItem({
    required this.name,
    required this.mealTypes,
    required this.description,
    required this.contents,
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
    ),
    TiffinItem(
      name: 'Healthy Protein Box',
      mealTypes: ['Dinner'],
      description:
      'A protein-packed box with lean meats, quinoa, and a selection of vegetables.',
      contents: 'Grilled chicken, Quinoa, Spinach, Bell peppers, Protein shake',
    ),
  ];

  // Variables to track meal type selection in Add/Edit dialog
  bool isLunchSelected = false;
  bool isDinnerSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tiffins',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => _addTiffinItem(),
                  child: const Text('Add Tiffin'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Meal Type', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                for (final item in tiffinItems)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.name),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.mealTypes.join(', ')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editTiffinItem(item),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
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
                    if (name.isNotEmpty && description.isNotEmpty && contents.isNotEmpty) {
                      setState(() {
                        if (isLunchSelected) mealTypes.add('Lunch');
                        if (isDinnerSelected) mealTypes.add('Dinner');
                        tiffinItems.add(TiffinItem(
                          name: name,
                          mealTypes: mealTypes,
                          description: description,
                          contents: contents,
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
