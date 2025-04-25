import 'package:flutter/material.dart';
import 'package:serviceleb/screens/tech.dart';

class LocationsScreen extends StatelessWidget {
  final int serviceId;
  final String serviceTitle;
  final List<dynamic> locations;

  const LocationsScreen({
    required this.serviceId,
    required this.serviceTitle,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceTitle),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(location['name']),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechniciansScreen(
                      serviceId: serviceId,
                      locationId: location['id'],
                      serviceTitle: serviceTitle,
                      locationName: location['name'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}