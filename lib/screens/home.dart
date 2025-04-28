import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:serviceleb/apiservice.dart';
import 'package:serviceleb/screens/location.dart';

class LebaneseHomePage extends StatefulWidget {
  const LebaneseHomePage({super.key, required this.title});

  final String title;

  @override
  State<LebaneseHomePage> createState() => _LebaneseHomePageState();
}

class _LebaneseHomePageState extends State<LebaneseHomePage> 
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _headerScale;
  late Animation<double> _headerFade;
  final _searchFocusNode = FocusNode();

  final List<Map<String, dynamic>> _services = [
    {
      'id': 1,
      'title': 'كهربجي',
      'icon': Icons.electrical_services,
      'color': const Color(0xFFEE161F),
    },
    {
      'id': 2,
      'title': 'سبّاك',
      'icon': Icons.plumbing,
      'color': const Color(0xFF00A651),
    },
    {
      'id': 3,
      'title': 'بلّاط',
      'icon': Icons.square_foot,
      'color': const Color(0xFF00A651),
    },
    {
      'id': 4,
      'title': 'نجّار',
      'icon': Icons.construction,
      'color': const Color(0xFFEE161F),
    },
    {
      'id': 5,
      'title': 'حدّاد',
      'icon': Icons.hardware,
      'color': const Color(0xFFEE161F),
    },
    {
      'id': 6,
      'title': 'فني ألمنيوم',
      'icon': Icons.window,
      'color': const Color(0xFF00A651),
    },
    {
      'id': 7,
      'title': 'فني تكييف',
      'icon': Icons.ac_unit,
      'color': const Color(0xFF00A651),
    },
    {
      'id': 8,
      'title': 'فني تبريد',
      'icon': Icons.kitchen,
      'color': const Color(0xFFEE161F),
    },
    {
      'id': 9,
      'title': 'ميكانيكي',
      'icon': Icons.car_repair,
      'color': const Color(0xFF00A651),
    },
    {
      'id': 10,
      'title': 'فني إنترنت',
      'icon': Icons.wifi,
      'color': const Color(0xFFEE161F),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _headerScale = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _navigateToLocations(BuildContext context, int serviceId) async {
    final service = _services.firstWhere((s) => s['id'] == serviceId);
    
    // Pre-cache the next screen's data
    final locationsFuture = ApiService.getLocations(serviceId);
    
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FutureBuilder(
            future: locationsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return LocationsScreen(
                  serviceId: serviceId,
                  serviceTitle: service['title'],
                  locations: snapshot.data!,
                  serviceIcon: service['icon'],
                );
              }
              // Seamless transition with placeholder content
              return Scaffold(
                backgroundColor: service['color'],
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              );
            },
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isScrolled = _scrollController.hasClients && 
        _scrollController.offset > (size.height * 0.25 - kToolbarHeight);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.35,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              stretchModes: const [StretchMode.zoomBackground],
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isScrolled ? 1 : 0,
                child: Text(
                  'Service Leb',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: ScaleTransition(
                scale: _headerScale,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFEE161F),
                          const Color(0xFF00A651),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -50,
                          top: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -30,
                          bottom: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.park,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Service Leb',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  'Find trusted professionals for all your home needs',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'الخدمات المتاحة',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey[900],
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
    ],
  ),
)

                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimatedServiceCard(
                    service: _services[index],
                    delay: index * 50,
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
    );
  }
}

class AnimatedServiceCard extends StatefulWidget {
  final Map<String, dynamic> service;
  final int delay;
  final VoidCallback onTap;

  const AnimatedServiceCard({
    required this.service,
    required this.delay,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedServiceCard> createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<AnimatedServiceCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _offset = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
          position: _offset,
          child: _ServiceCard(
            service: widget.service,
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: service['color'],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'service-icon-${service['id']}',
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          service['icon'],
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Hero(
                      tag: 'service-title-${service['id']}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          service['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}