class Location {
  final int id;
  final String name;
  final int? serviceId; // Optional, for relationships

  Location({
    required this.id,
    required this.name,
    this.serviceId,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      serviceId: json['service_id'],
    );
  }
}