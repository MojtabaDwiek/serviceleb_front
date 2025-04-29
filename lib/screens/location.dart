import 'package:flutter/material.dart';
import 'package:serviceleb/screens/tech.dart';

class LocationsScreen extends StatefulWidget {
  final int serviceId;
  final String serviceTitle;
  final List<dynamic> locations;
  final IconData serviceIcon;

  const LocationsScreen({
    required this.serviceId,
    required this.serviceTitle,
    required this.locations,
    required this.serviceIcon,
    Key? key,
  }) : super(key: key);

  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final List<IconData> locationIcons = const [
    Icons.location_city,
    Icons.home_work,
    Icons.store,
    Icons.business,
    Icons.apartment,
    Icons.house,
    Icons.place,
    Icons.location_on,
  ];

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = widget.locations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEE161F), Color(0xFF00A651), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with title and back button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'service-title-${widget.serviceId}',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                widget.serviceTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: 'service-icon-${widget.serviceId}',
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51), // 0.2 * 255 ≈ 51
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.serviceIcon,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isSearching
                      ? TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search locations...',
                            hintStyle: TextStyle(color: Colors.white.withAlpha(178)), // 0.7 * 255 ≈ 178
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _isSearching = false;
                                  _searchController.clear();
                                  _filteredLocations = widget.locations;
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _filteredLocations = widget.locations
                                  .where((location) => location['name']
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Choose your location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.search, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _isSearching = true;
                                });
                              },
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              // Location icons grid with names
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _filteredLocations.length,
                    itemBuilder: (context, index) {
                      final location = _filteredLocations[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return TechniciansScreen(
                                  serviceId: widget.serviceId,
                                  locationId: location['id'],
                                  serviceTitle: widget.serviceTitle,
                                  locationName: location['name'],
                                );
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOutQuart;
                                
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51), // 0.2 * 255 ≈ 51
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withAlpha(102), // 0.4 * 255 ≈ 102
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                locationIcons[index % locationIcons.length],
                                size: 36,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  location['name'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}