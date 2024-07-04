import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
 
class RegisterBusinessScreen extends StatefulWidget {
  const RegisterBusinessScreen({Key? key}) : super(key: key);
 
  @override
  _RegisterBusinessScreenState createState() => _RegisterBusinessScreenState();
}
 
class _RegisterBusinessScreenState extends State<RegisterBusinessScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
 
  bool _rememberMe = false;
  XFile? _profileImage;
 
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }
 
  bool _validateInputs() {
    if (_businessNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _licenseController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields'))
      );
      return false;
    }
 
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match'))
      );
      return false;
    }
 
    return true;
  }
 
  Future<String?> _uploadProfileImage(XFile image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final profileImageRef = storageRef.child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
 
      final uploadTask = profileImageRef.putFile(File(image.path));
      final snapshot = await uploadTask.whenComplete(() {});
 
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload profile image'))
      );
      return null;
    }
  }
 
  Future<void> _registerBusiness() async {
    if (!_validateInputs()) return;
 
    String? imageUrl;
    if (_profileImage != null) {
      imageUrl = await _uploadProfileImage(_profileImage!);
      if (imageUrl == null) return; // Exit if image upload failed
    }
 
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('businesses').add({
        'businessName': _businessNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text, // Note: Passwords should be hashed
        'location': _locationController.text,
        'licenseNumber': _licenseController.text,
        'description': _descriptionController.text,
        'profileImage': imageUrl,
        'rememberMe': _rememberMe,
        'createdAt': FieldValue.serverTimestamp(),
      });
 
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Business registered successfully'))
      );
 
      // Optionally navigate to another screen or clear the form
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register business'))
      );
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Your Business'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(File(_profileImage!.path))
                    : null,
                child: _profileImage == null
                    ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _businessNameController,
              decoration: InputDecoration(
                labelText: 'Business Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: Icon(Icons.visibility),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: Icon(Icons.visibility),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _licenseController,
              decoration: InputDecoration(
                labelText: 'Business License Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Business Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _rememberMe = newValue ?? false;
                    });
                  },
                ),
                const Text('Remember me'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerBusiness,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Register Business',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
 
 
 
 
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class RegisterBusinessScreen extends StatefulWidget {
//   const RegisterBusinessScreen({Key? key}) : super(key: key);
//
//   @override
//   _RegisterBusinessScreenState createState() => _RegisterBusinessScreenState();
// }
//
// class _RegisterBusinessScreenState extends State<RegisterBusinessScreen> {
//   final TextEditingController _businessNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _licenseController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//
//   bool _rememberMe = false;
//   XFile? _profileImage;
//
//   Future<void> _pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _profileImage = image;
//       });
//     }
//   }
//
//   void _registerBusiness() {
//     // Business registration logic goes here
//     // For example, sending data to Firebase or another backend service
//     // Also include validation for the input fields before proceeding
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register Your Business'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: _profileImage != null
//                     ? FileImage(File(_profileImage!.path))
//                     : null,
//                 child: _profileImage == null
//                     ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _businessNameController,
//               decoration: InputDecoration(
//                 labelText: 'Business Name',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 suffixIcon: Icon(Icons.visibility),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Confirm Password',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 suffixIcon: Icon(Icons.visibility),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _locationController,
//               decoration: InputDecoration(
//                 labelText: 'Location',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _licenseController,
//               decoration: InputDecoration(
//                 labelText: 'Business License Number',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(
//                 labelText: 'Business Description',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 15),
//             Row(
//               children: [
//                 Checkbox(
//                   value: _rememberMe,
//                   onChanged: (bool? newValue) {
//                     setState(() {
//                       _rememberMe = newValue ?? false;
//                     });
//                   },
//                 ),
//                 const Text('Remember me'),
//               ],
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _registerBusiness,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   child: Text(
//                     'Register Business',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }