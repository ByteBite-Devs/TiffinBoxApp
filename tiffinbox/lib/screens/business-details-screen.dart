import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/tiffindetails_screen.dart';
import 'package:tiffinbox/services/tiffin-service.dart';

class BusinessDetailsScreen extends StatefulWidget {
  final String businessId;

  const BusinessDetailsScreen({Key? key, required this.businessId}) : super(key: key);

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  TiffinService tiffinService = TiffinService();
  dynamic business;

  @override
  void initState() {
    super.initState();
    _loadBusinessDetails();
  }

  void _loadBusinessDetails() async {
    var response = await tiffinService.getBusinessDetails(widget.businessId);
    if (response['status'] == 'success') {
      setState(() {
        business = response['business'];
      });
    }
  }

  void _navigateToTiffinDetails(String tiffinId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TiffinDetailScreen(tiffinId: tiffinId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(business != null ? business['business_name'] : 'Loading...'),
      ),
      body: business != null
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      business['image'] != '' ? business['image'] : 'assets/images/business_login.jpg',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    business['business_name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  business['rating'] != null
                      ? Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              business['rating'].toString(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${business['reviews_count']} reviews)',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 16),
                  business['description'] != null
                      ? Text(
                          business['description'],
                          style: TextStyle(fontSize: 16),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 16),
                  Text(
                    'Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    business['address'][0] != null
                        ? business['address'][0]['addressLine1'] + ' ' + business['address'][0]['addressLine2']
                        : '',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Menu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (business['tiffins'] as List<dynamic>)
                        .map((tiffin) => GestureDetector(
                              onTap: () {
                                _navigateToTiffinDetails(tiffin['id']);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        tiffin['images'] != null
                                            ? tiffin['images'][0]
                                            : 'https://via.placeholder.com/150',
                                        width: 120,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.network(
                                            'https://via.placeholder.com/150',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tiffin['name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Price: ${tiffin['price']}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(Icons.star, color: Colors.amber, size: 16),
                                                const SizedBox(width: 4),
                                                Text(
                                                  tiffin['rating'] != null
                                                      ? '${tiffin['rating']}'
                                                      : 'Not Available',
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Implement order functionality
                    },
                    child: Text('Order Now'),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
