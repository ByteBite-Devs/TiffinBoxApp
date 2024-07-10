import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiffinbox/screens/login_screen.dart';
import 'package:tiffinbox/screens/profile_screen.dart';
import 'package:tiffinbox/services/profile-service.dart';
import 'package:tiffinbox/utils/constants/color.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer();

  @override
  State<StatefulWidget> createState() {
    return _MyDrawerState();
  }
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  String _userName  = '';
  String _userEmail = '';
  String _profileImageUrl = '';


    Future<void> _logout() async {
      print("in logout method");
    await _auth.signOut();
    await _googleSignIn.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      var response = await ProfileService().getProfileDetails();
      if (response['status'] == 'success') {
        var userData = response['user'];
        setState(() {
          _userName = userData['name'];
          _userEmail = userData['email'];
          _profileImageUrl = userData['profileImage'];
        });
      }
    } catch (e) {
      print('Error loading user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: primarycolor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  // Replace with your user profile image logic
                  backgroundImage: AssetImage('assets/icons/user.png'),
                  foregroundImage: _profileImageUrl.isNotEmpty
                      ? NetworkImage(_profileImageUrl)
                      : null,
                ),
                SizedBox(height: 8),
                Text(
                  _userName,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  _userEmail,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('My Orders'),
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => OrdersScreen()),
              // );
            },
          ),
          ListTile(
            title: Text('My Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Addresses'),
            onTap: () {
              // Handle tap for Addresses
            },
          ),
          ListTile(
            title: Text('Payment Methods'),
            onTap: () {
              // Handle tap for Payment Methods
            },
          ),
          ListTile(
            title: Text('Contact Us'),
            onTap: () {
              // Handle tap for Contact Us
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Handle tap for Settings
            },
          ),
          ListTile(
            title: Text('Help & FAQs'),
            onTap: () {
              // Handle tap for Help & FAQs
            },
          ),
          Divider(),
          ListTile(
            title: Text('Log Out'),
            onTap: () {
              print("hwefhuwhf");
              _logout();
            },
          ),
        ],
      ),
    );
  }

}
