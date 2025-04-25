import 'package:flutter/material.dart';

class Service {
  final int id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  Service({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });

  // Convert JSON to Service model (for API responses)
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      title: json['name'], // Assuming your API returns 'name' for service title
      icon: _getIconForService(json['id']),
      gradient: _getGradientForService(json['id']),
    );
  }

  // Helper methods to maintain your design
  static IconData _getIconForService(int id) {
    switch (id) {
      case 1: return Icons.ac_unit;
      case 2: return Icons.home;
      case 3: return Icons.assignment_turned_in;
      case 4: return Icons.delivery_dining;
      default: return Icons.help_outline;
    }
  }

  static List<Color> _getGradientForService(int id) {
    switch (id) {
      case 1: return [const Color(0xFFEE161F), const Color(0xFFD91018)];
      case 2: 
      case 3: return [const Color(0xFF00A651), const Color(0xFF008B45)];
      case 4: return [const Color(0xFFEE161F), const Color(0xFFD91018)];
      default: return [Colors.blue, Colors.lightBlue];
    }
  }
}