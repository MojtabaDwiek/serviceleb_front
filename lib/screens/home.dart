import 'package:flutter/material.dart';

class LebaneseHomePage extends StatefulWidget {
  const LebaneseHomePage({super.key, required this.title});

  final String title;

  @override
  State<LebaneseHomePage> createState() => _LebaneseHomePageState();
}

class _LebaneseHomePageState extends State<LebaneseHomePage> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _services = [
    {
      'id': 'ac_maintenance',
      'title': 'صيانة مكيفات',
      'icon': Icons.ac_unit,
      'gradient': [const Color(0xFFEE161F), const Color(0xFFD91018)],
    },
    {
      'id': 'home_services',
      'title': 'خدمات منزلية',
      'icon': Icons.home,
      'gradient': [const Color(0xFF00A651), const Color(0xFF008B45)],
    },
    {
      'id': 'clearance',
      'title': 'تخليص',
      'icon': Icons.assignment_turned_in,
      'gradient': [const Color(0xFF00A651), const Color(0xFF008B45)],
    },
    {
      'id': 'delivery',
      'title': 'توصيل طلبات',
      'icon': Icons.delivery_dining,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
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
                    colors: [const Color(0xFFC62828), const Color.fromARGB(255, 255, 255, 255)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
      crossAxisAlignment: CrossAxisAlignment.center, // Changed from start to center
      children: [
        Text(
          'الخدمات المتاحة',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.center, // Added textAlign
        ),
        const SizedBox(height: 8),
        Text(
          'اختر الخدمة التي تحتاجها',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center, // Added textAlign
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
                  return _ServiceCard(service: _services[index]);
                },
                childCount: _services.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16), // Slightly smaller radius
      elevation: 3, // Slightly less elevation
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
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
                blurRadius: 8, // Smaller shadow
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16), // Reduced padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12), // Smaller padding
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    service['icon'],
                    size: 24, // Smaller icon
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12), // Reduced spacing
                Text(
                  service['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Smaller font
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