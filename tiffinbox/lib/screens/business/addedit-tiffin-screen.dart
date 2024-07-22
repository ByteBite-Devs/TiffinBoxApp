import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiffinbox/screens/business/businesshome_screen.dart';
import 'package:tiffinbox/services/tiffin-service.dart';

import '../../models/TiffinIntem.dart';class AddEditTiffinScreen extends StatefulWidget {
  final TiffinItem? tiffinItem;

  AddEditTiffinScreen({this.tiffinItem});

  @override
  _AddEditTiffinScreenState createState() => _AddEditTiffinScreenState();
}

class _AddEditTiffinScreenState extends State<AddEditTiffinScreen> {
  final _formKey = GlobalKey<FormState>();
  late String id;
  late String _name;
  late String _description;
  late double _price;
  late List<dynamic> _mealTypes;
  late List<dynamic> _contents;
  late String _dietType;
  late List<dynamic> _frequencies;
  late List<dynamic> _images;

  final List<dynamic> _selectedMealTypes = [];
  final List<dynamic> _selectedFrequencies = [];

  List<XFile> selectedImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.tiffinItem != null) {
      id = widget.tiffinItem!.id ?? '';
      _name = widget.tiffinItem!.name;
      _description = widget.tiffinItem!.description;
      _price = widget.tiffinItem!.price;
      _mealTypes = widget.tiffinItem!.mealTypes ?? [];
      _contents = widget.tiffinItem!.contents!;
      _dietType = widget.tiffinItem!.dietType;
      _frequencies = widget.tiffinItem!.frequency ?? [];
      _images = widget.tiffinItem!.images;
    } else {
      id = '';
      _name = '';
      _description = '';
      _price = 0.0;
      _mealTypes = [];
      _contents = [];
      _dietType = 'Veg';
      _frequencies = [];
      _images = [];
    }
    _selectedMealTypes.addAll(_mealTypes);
    _selectedFrequencies.addAll(_frequencies);
  }

  uploadImages() async {
      FirebaseStorage storage = FirebaseStorage.instance;

      for (XFile image in selectedImages) {
        Reference ref = storage.ref().child('images').child(image.name);
        UploadTask uploadTask = ref.putFile(File(image.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        _images.add(downloadUrl);
      }

  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {

      await uploadImages();

      TiffinItem tiffinItem = TiffinItem(
          name: _name,
          description: _description,
          price: _price,
          mealTypes: _selectedMealTypes,
          contents: _contents,
          dietType: _dietType,
          frequency: _selectedFrequencies,
          images: _images,
          business_id: FirebaseAuth.instance.currentUser!.uid
      );

      if (widget.tiffinItem == null) {
        var response = await TiffinService().addTiffibn(tiffinItem);
      if (response['status'] == 'success') {
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => BusinessHomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add tiffin')),
        );
      }
      }
      else {
        tiffinItem.id = widget.tiffinItem!.id;
        var response = await TiffinService().updateTiffin(tiffinItem);
        if (response['status'] == 'success') {
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => BusinessHomeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update tiffin')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }

  void _toggleMealType(String mealType) {
    setState(() {
      if (_selectedMealTypes.contains(mealType)) {
        _selectedMealTypes.remove(mealType);
      } else {
        _selectedMealTypes.add(mealType);
      }
    });
  }

  void _toggleDietType(String dietType) {
    setState(() {
      _dietType = dietType;
    });
  }

  void _toggleFrequency(String frequency) {
    setState(() {
      if (_selectedFrequencies.contains(frequency)) {
        _selectedFrequencies.remove(frequency);
      } else {
        _selectedFrequencies.add(frequency);
      }
    });
  }

  void _addContent() {
    setState(() {
      _contents.add({'name': '', 'quantity': ''});
    });
  }

  void _removeContent(int index) {
    setState(() {
      _contents.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tiffinItem == null ? 'Add Tiffin' : 'Edit Tiffin'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a name.';
                  }
                  return null;
                },
                onChanged: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) => _description = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please provide a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please provide a number greater than zero.';
                  }
                  return null;
                },
                onChanged: (value) => _price = double.parse(value!),
              ),
              const SizedBox(height: 16),
              Text(
                'Meal Types',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Wrap(
                children: [
                  _buildMealTypeChip('Breakfast'),
                  _buildMealTypeChip('Lunch'),
                  _buildMealTypeChip('Dinner'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Diet Type',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Wrap(
                children: [
                  _buildDietTypeChip('Veg'),
                  _buildDietTypeChip('Non-Veg'),
                  _buildDietTypeChip('Vegan'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Frequency',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Wrap(
                children: [
                  _buildFrequencyChip('One Time'),
                  _buildFrequencyChip('One Week'),
                  _buildFrequencyChip('One Month'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Contents',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              ..._contents.asMap().entries.map((entry) {
                int index = entry.key;
                var content = entry.value;
                return Column(
                  children: [
                    TextFormField(
                      initialValue: content['name'],
                      decoration: InputDecoration(
                        labelText: 'Content Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => _contents[index]['name'] = value!,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: content['quantity'],
                      decoration: InputDecoration(
                        labelText: 'Content Quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => _contents[index]['quantity'] = value!,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _removeContent(index),
                      child: const Text('Remove Content'),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addContent,
                child: const Text('Add Content'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Pick multiple images
                  final List<XFile>? pickedImages = await ImagePicker().pickMultiImage();
                  if (pickedImages != null) {
                    setState(() {
                      selectedImages.addAll(pickedImages);
                    });
                  }
                },
                child: const Text('Pick Images'),
              ),
              const SizedBox(height: 16),
            if (_images.isNotEmpty)
                Wrap(
                  children: _images.map((image) => _buildNetworkImageWidget(image)).toList(),
                ),
              if (selectedImages.isNotEmpty) 
                Wrap(
                  children: selectedImages.map((image) => _buildImageWidget(image.path)).toList(),
                ),
              const SizedBox(height: 16),
              
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildNetworkImageWidget(String imageUrl) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _images.remove(imageUrl); // Remove the image URL from _images list
              });
            },
          ),
        ),
      ],
    );
  }

      Widget _buildImageWidget(String imageUrl) {
    return Stack(
      children: [
        Image.file(
          File(imageUrl),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                selectedImages.removeWhere((image) => image.path == imageUrl);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMealTypeChip(String mealType) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(mealType),
        selected: _selectedMealTypes.contains(mealType),
        onSelected: (_) => _toggleMealType(mealType),
      ),
    );
  }

  Widget _buildDietTypeChip(String dietType) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(dietType),
        selected: _dietType == dietType,
        onSelected: (_) => _toggleDietType(dietType),
      ),
    );
  }

  Widget _buildFrequencyChip(String frequency) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(frequency),
        selected: _selectedFrequencies.contains(frequency),
        onSelected: (_) => _toggleFrequency(frequency),
      ),
    );
  }
}
