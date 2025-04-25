import 'package:flutter/material.dart';
import 'package:serviceleb/apiservice.dart';

import 'package:serviceleb/screens/location.dart';

class LebaneseHomePage extends StatefulWidget {
  const LebaneseHomePage({super.key, required this.title});

  final String title;

  @override
  State<LebaneseHomePage> createState() => _LebaneseHomePageState();
}

class _LebaneseHomePageState extends State<LebaneseHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // Hardcoded services with matching backend IDs
 final List<Map<String, dynamic>> _services = [
    {
      'id': 1,
      'title': 'كهربجي',
      'icon': Icons.electrical_services,
      'gradient': [const Color(0xFFEE161F), const Color(0xFFD91018)],
    },
    {
      'id': 2,
      'title': 'سبّاك',
      'icon': Icons.plumbing,
      'gradient': [const Color(0xFF00A651), const Color(0xFF008B45)],
    },
    {
      'id': 3,
      'title': 'بلّاط',
      'icon': Icons.square_foot,
      'gradient': [const Color(0xFF00A651), const Color(0xFF008B45)],
    },
    {
      'id': 4,
      'title': 'نجّار',
      'icon': Icons.mood,
      'gradient': [const Color(0xFFEE161F), const Color(0xFFD91018)],
    },
    {
      'id': 5,
      'title': 'حدّاد',
      'icon': Icons.hardware,
      'gradient': [const Color(0xFFEE161F), const Color(0xFFD91018)],
    },
    {
      'id': 6,
      'title': 'فني ألمنيوم',
      'icon': Icons.window,
      'gradient': [const Color(0xFF00A651), const Color(0xFF008B45)],
    },
    {
      'id': 7,
      'title': 'فني تكييف',
      'icon': Icons.ac_unit,
      'gradient': [const Color(0xFF00A651), const Color(0xFF008B45)],
    },
    {
      'id': 8,
      'title': 'فني تبريد',
      'icon': Icons.kitchen,
      'gradient': [const Color(0xFFEE161F), const Color(0xFFD91018)],
    },
    {
      'id': 9,
      'title': 'ميكانيكي',
      'icon': Icons.car_repair,
      'gradient': [const Color(0xFF00A651), const Color(0xFF008B45)],
    },
    {
      'id': 10,
      'title': 'فني إنترنت',
      'icon': Icons.wifi,
      'gradient': [const Color(0xFFEE161F), const Color(0xFFD91018)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

 Future<void> _navigateToLocations(BuildContext context, int serviceId) async {
  debugPrint('Starting navigation to locations for service $serviceId');
  
  setState(() => _isLoading = true);
  try {
    debugPrint('Calling API for locations...');
    final locations = await ApiService.getLocations(serviceId);
    debugPrint('Received ${locations.length} locations');

    if (!mounted) {
      debugPrint('Widget disposed before navigation');
      return;
    }

    debugPrint('Finding service details...');
    final service = _services.firstWhere((s) => s['id'] == serviceId);
    debugPrint('Service found: ${service['title']}');

    debugPrint('Navigating to LocationsScreen');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationsScreen(
          serviceId: serviceId,
          serviceTitle: service['title'],
          locations: locations,
        ),
      ),
    );
    debugPrint('Navigation complete');

  } catch (e) {
    debugPrint('Error occurred: $e');
    debugPrint('Error type: ${e.runtimeType}');
    if (e is Error) {
      debugPrint('Stack trace: ${e.stackTrace}');
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  } finally {
    debugPrint('Cleaning up...');
    if (mounted) {
      setState(() => _isLoading = false);
    }
    debugPrint('Done');
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: size.height * 0.3,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFEE161F), Colors.white, Color(0xFFEE161F)],
                        begin: Alignment.topLeft,
            end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green.withOpacity(0.7),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.park,
                              size: 60,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Service Leb ',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.green[20],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'الخدمات المتاحة',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اختر الخدمة التي تحتاجها',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _ServiceCard(
                        service: _services[index],
                        onTap: () => _navigateToLocations(context, _services[index]['id']),
                      );
                    },
                    childCount: _services.length,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: service['gradient'],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    service['icon'],
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  service['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
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