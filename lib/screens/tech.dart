import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TechniciansScreen extends StatelessWidget {
  final int serviceId;
  final int locationId;
  final String serviceTitle;
  final String locationName;

  const TechniciansScreen({
    required this.serviceId,
    required this.locationId,
    required this.serviceTitle,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(serviceTitle),
            Text(locationName, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchTechnicians(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No technicians available'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final tech = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(tech['name']),
                    subtitle: Text(tech['phone']),
                    trailing: IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () {
                        // Implement phone call functionality
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchTechnicians() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.109:8000/api/technicians/$serviceId/$locationId'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load technicians');
    }
  }
}