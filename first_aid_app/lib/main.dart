import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('First Aid_data');

  runApp(const FirstAidApp());
}

class FirstAidApp extends StatelessWidget {
  const FirstAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First-Aid Lite',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      routes: {
        '/categories': (context) => const CategoriesScreen(),
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First-Aid Lite'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.medical_services,
                          color: Colors.white, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'Emergency First-Aid',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Quick guidance when you need it most',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Quick actions
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        context,
                        'Browse Categories',
                        Icons.list,
                        Colors.blue,
                        () => Navigator.pushNamed(context, '/categories'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickAction(
                        context,
                        'Search Symptoms',
                        Icons.search,
                        Colors.green,
                        () => Navigator.pushNamed(context, '/search'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Emergency categories quick access
                const Text(
                  'Emergency Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: FirstAidData.categories.map((category) {
                      return _buildCategoryCard(context, category);
                    }).toList(),
                  ),
                ),

                // Offline indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.offline_bolt,
                          color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Works offline - No internet required',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black87)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, FirstAidCategory category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(category: category),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First-Aid Categories'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: FirstAidData.categories.length,
        itemBuilder: (context, index) {
          final category = FirstAidData.categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(category.icon, color: Colors.red),
              ),
              title: Text(category.name),
              subtitle: Text(category.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoryDetailScreen(category: category),
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FirstAidCategory> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search First-Aid'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by symptoms or keywords...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchResults = FirstAidData.searchCategories(query);
                });
              },
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Search for symptoms or keywords',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final category = _searchResults[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Icon(category.icon, color: Colors.red),
                          title: Text(category.name),
                          subtitle: Text(category.description),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryDetailScreen(category: category),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final FirstAidCategory category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(category.icon, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            const Text(
              'Step-by-Step Instructions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...category.instructions.asMap().entries.map((entry) {
              int index = entry.key;
              String instruction = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        instruction,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // Warning box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Notice',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This app provides basic first-aid guidance only. Always call emergency services (999) for serious injuries or emergencies.',
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data models and static data
class FirstAidCategory {
  final String name;
  final String description;
  final IconData icon;
  final List<String> instructions;
  final List<String> keywords;

  FirstAidCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.instructions,
    required this.keywords,
  });
}

class FirstAidData {
  static List<FirstAidCategory> categories = [
    FirstAidCategory(
      name: 'Bleeding',
      description: 'Control bleeding from cuts and wounds',
      icon: Icons.bloodtype,
      keywords: ['bleeding', 'cut', 'wound', 'blood', 'injury'],
      instructions: [
        'Apply direct pressure to the wound with a clean cloth or bandage',
        'Elevate the injured area above heart level if possible',
        'Maintain pressure for 10-15 minutes without lifting to check',
        'If blood soaks through, add more cloth on top - do not remove original',
        'Seek medical attention if bleeding is severe or won\'t stop',
      ],
    ),
    FirstAidCategory(
      name: 'Fires & Burns',
      description: 'fire safety and burn treatment',
      icon: Icons.local_fire_department,
      keywords: ['burn', 'scald', 'fire', 'hot', 'heat', 'cooking'],
      instructions: [
        'Cool the burn with cold running water for 10-20 minutes',
        'Remove any jewelry or clothing near the burn before swelling occurs',
        'Cover with a sterile, non-stick bandage or clean cloth',
        'Take over-the-counter pain medication if needed',
        'Seek medical help for burns larger than 3 inches or on face, hands, feet, or genitals',
      ],
    ),
    FirstAidCategory(
      name: 'Panic Attacks',
      description: 'Emergency response for panic attacks',
      icon: Icons.psychology,
      keywords: ['panic', 'attack', 'anxiety', 'fear', 'stress'],
      instructions: [
        'Stay calm and reassure the person',
        'Encourage slow deep breathing',
        'Move to a quiet place',
        'Avoid judgment or panic',
        'Seek professional help if it persists',
      ],
    ),
    FirstAidCategory(
      name: 'Choking',
      description: 'Clear airway obstruction',
      icon: Icons.air,
      keywords: ['choking', 'cough', 'airway', 'breathing', 'throat'],
      instructions: [
        'Encourage the person to cough if they can',
        'Give 5 back blows between shoulder blades with heel of hand',
        'If unsuccessful, give 5 abdominal thrusts (Heimlich maneuver)',
        'Place hands above navel, thrust inward and upward',
        'Alternate between back blows and abdominal thrusts',
        'Call 177 if object cannot be dislodged',
      ],
    ),
    FirstAidCategory(
      name: 'Fainting',
      description: 'Help someone who has fainted',
      icon: Icons.airline_seat_recline_normal,
      keywords: ['faint', 'unconscious', 'dizzy', 'collapse', 'weak'],
      instructions: [
        'Check if person is conscious and breathing',
        'If breathing, place in recovery position',
        'Loosen any tight clothing around neck',
        'Elevate legs 8-12 inches if no spinal injury suspected',
        'Do not give food or water until fully conscious',
        'Seek medical attention if they don\'t wake up within 1 minute',
      ],
    ),
    FirstAidCategory(
      name: 'Fractures',
      description: 'Stabilize broken bones',
      icon: Icons.healing,
      keywords: ['fracture', 'break', 'bone', 'arm', 'leg', 'pain'],
      instructions: [
        'Do not move the person unless they are in immediate danger',
        'Support the injured area and keep it still',
        'Apply ice wrapped in cloth to reduce swelling',
        'Create a splint using rigid material if necessary',
        'Treat for shock - keep person warm and calm',
        'Get emergency medical help - do not give food or water',
      ],
    ),
    FirstAidCategory(
      name: 'Poisoning',
      description: 'Respond to poisoning emergencies',
      icon: Icons.dangerous,
      keywords: ['poison', 'toxic', 'chemical', 'overdose', 'medication'],
      instructions: [
        'Call Poison Control immediately or emergency services',
        'Try to identify what was ingested and how much',
        'Do NOT induce vomiting unless instructed by poison control',
        'If substance is on skin, remove contaminated clothing and rinse with water',
        'If in eyes, flush with clean water for 15-20 minutes',
        'Keep the person calm and monitor breathing',
      ],
    ),
    FirstAidCategory(
      name: 'CPR Basics',
      description: 'Cardiopulmonary resuscitation steps',
      icon: Icons.favorite,
      keywords: ['CPR', 'heart', 'cardiac', 'breathing', 'chest compressions'],
      instructions: [
        'Check for responsiveness - tap shoulders and shout "Are you okay?"',
        'Call 900 and ask someone to find an Automated External Defibrillator (AED) if available',
        'Place heel of one hand on center of chest, other hand on top',
        'Push hard and fast at least 2 inches deep at 100-120 compressions per minute',
        'After 30 compressions, give 2 rescue breaths',
        'Continue cycles of 30 compressions and 2 breaths until help arrives',
      ],
    ),
  ];

  static List<FirstAidCategory> searchCategories(String query) {
    if (query.isEmpty) return [];

    return categories.where((category) {
      final searchLower = query.toLowerCase();
      return category.name.toLowerCase().contains(searchLower) ||
          category.description.toLowerCase().contains(searchLower) ||
          category.keywords
              .any((keyword) => keyword.toLowerCase().contains(searchLower));
    }).toList();
  }
}