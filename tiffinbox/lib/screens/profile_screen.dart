import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiffinbox/utils/color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedGender;
  String? _profileImageUrl;
  File? _profileImage;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _phoneController.text = userData['phone'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _nameController.text = userData['name'] ?? '';
            _dobController.text = userData['dob'] ?? '';
            _locationController.text = userData['location'] ?? '';
            _selectedGender = userData['gender'];
            _profileImageUrl = userData['profileImageUrl'];
          });
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> _updateUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        Map<String, dynamic> updatedData = {
          'phone': _phoneController.text,
          'email': _emailController.text,
          'name': _nameController.text,
          'dob': _dobController.text,
          'location': _locationController.text,
          'gender': _selectedGender,
        };

        // Update profile picture if a new one is selected
        if (_profileImage != null) {
          String imageUrl = await _uploadProfileImage(user.uid);
          updatedData['profileImageUrl'] = imageUrl;
        }

        await _firestore.collection('users').doc(user.uid).update(updatedData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile')),
      );
    }
  }

  Future<String> _uploadProfileImage(String userId) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('profileImages').child('$userId.jpg');
      UploadTask uploadTask = ref.putFile(_profileImage!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      throw e;
    }
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // final PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
             Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (_profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!)
                          : AssetImage('assets/icons/user.png')) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickProfileImage,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: primarycolor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                IntlPhoneField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  initialCountryCode: 'GB',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: const Text('Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateUserProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarycolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:tiffinbox/utils/color.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//
//   String? _selectedGender;
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Profile'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             height: screenHeight,
//             padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 30),
//                 Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: AssetImage('assets/icons/user.png'),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: GestureDetector(
//                         onTap: () {
//                           // Handle profile picture update
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(5),
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                           ),
//                           child: Icon(
//                             Icons.edit,
//                             color: primarycolor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 IntlPhoneField(
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     counterText: "",
//                     labelText: 'Phone Number',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   initialCountryCode: 'CA',
//                   onChanged: (phone) {
//                     print(phone.completeNumber);
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Full Name',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _dobController,
//                   decoration: InputDecoration(
//                     labelText: 'Date of Birth',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     suffixIcon: Icon(Icons.calendar_today),
//                   ),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (pickedDate != null) {
//                       setState(() {
//                         _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                       });
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 DropdownButtonFormField<String>(
//                   value: _selectedGender,
//                   hint: const Text('Gender'),
//                   items: ['Male', 'Female', 'Other']
//                       .map((gender) => DropdownMenuItem(
//                     value: gender,
//                     child: Text(gender),
//                   ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedGender = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _locationController,
//                   decoration: InputDecoration(
//                     labelText: 'Your Location',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     suffixIcon: Icon(Icons.location_on),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle profile update
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80), backgroundColor: primarycolor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Save',
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 // TextButton(
//                 //   onPressed: () {
//                 //     // Handle skip action
//                 //   },
//                 //   child: const Text(
//                 //     'Skip',
//                 //     style: TextStyle(
//                 //       color: primarycolor,
//                 //       fontSize: 16,
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: <Widget>[
//           // Profile Picture
//           Stack(
//             children: <Widget>[
//               const CircleAvatar(
//                 radius: 50,
//                 backgroundImage: AssetImage('assets/profile_picture.jpg'), // Add your profile picture asset here
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: CircleAvatar(
//                   radius: 15,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.edit,
//                     size: 15,
//                     color: primarycolor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // Phone Number
//           Row(
//             children: <Widget>[
//               Image.asset('assets/uk_flag.png', width: 32), // Add your flag asset here
//               const SizedBox(width: 10),
//               Expanded(
//                 child: TextField(
//                   decoration: const InputDecoration(
//                     labelText: '+44 20 1234 5629',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // Email
//           const TextField(
//             decoration: InputDecoration(
//               labelText: 'thomas.abc.inc@gmail.com',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Name
//           const TextField(
//             decoration: InputDecoration(
//               labelText: 'Thomas K. Wilson',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Date of Birth
//           const TextField(
//             decoration: InputDecoration(
//               labelText: '07/11/1997',
//               border: OutlineInputBorder(),
//               suffixIcon: Icon(Icons.calendar_today),
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Gender
//           const TextField(
//             decoration: InputDecoration(
//               labelText: 'Male',
//               border: OutlineInputBorder(),
//               suffixIcon: Icon(Icons.arrow_drop_down),
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Location
//           const TextField(
//             decoration: InputDecoration(
//               labelText: '221B Baker Street, London, United Kingdom',
//               border: OutlineInputBorder(),
//               suffixIcon: Icon(Icons.location_on),
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Continue Button
//           ElevatedButton(
//             onPressed: () {
//               // Handle continue button press
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primarycolor, // Background color
//               minimumSize: const Size(double.infinity, 50), // Full width button
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(50),
//               ),
//             ),
//             child: const Text('Continue'),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }
