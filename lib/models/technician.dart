import 'package:serviceleb/models/location.dart';
import 'package:serviceleb/models/service.dart';

class Technician {
  final int id;
  final String name;
  final String phone;
  final String? description;
  final int serviceId;
  final int locationId;
  final Service? service; // Nested service object
  final Location? location; // Nested location object

  Technician({
    required this.id,
    required this.name,
    required this.phone,
    this.description,
    required this.serviceId,
    required this.locationId,
    this.service,
    this.location,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      description: json['description'],
      serviceId: json['service_id'],
      locationId: json['location_id'],
      service: json['service'] != null ? Service.fromJson(json['service']) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }
}