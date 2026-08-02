import 'package:flutter/material.dart';
import 'package:medical_app/pages/general.dart';
import 'package:medical_app/pages/widgets/bottom_navigation.dart';

/// One entry in the specialty grid.
class Specialty {
  final String label;
  final String asset;
  final Color color;
  final double imageWidth;

  const Specialty({
    required this.label,
    required this.asset,
    required this.color,
    this.imageWidth = 90,
  });
}

const List<Specialty> kSpecialties = [
  Specialty(
      label: 'General',
      asset: 'assests/stet.png',
      color: Color(0xff477cfe),
      imageWidth: 70),
  Specialty(
      label: 'Dental',
      asset: 'assests/teeth.png',
      color: Color(0xfffdb45f),
      imageWidth: 90),
  Specialty(
      label: 'Ophthalmology',
      asset: 'assests/eye.png',
      color: Color(0xff56b3d4),
      imageWidth: 100),
  Specialty(
      label: 'Cardiology',
      asset: 'assests/heart.png',
      color: Color(0xffef7069),
      imageWidth: 105),
  Specialty(
      label: 'Neurology',
      asset: 'assests/brain.png',
      color: Color(0xfffdb45f),
      imageWidth: 100),
  Specialty(
      label: 'Laboratory',
      asset: 'assests/laboo.png',
      color: Color(0xff477cfe),
      imageWidth: 55),
];

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openSpecialty(Specialty specialty) {
    // Only General has a detail screen so far; the rest need a doctor list
    // backed by GET /api/doctors?specialization=...
    if (specialty.label == 'General') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => General()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${specialty.label} doctors are not available yet',
          style: const TextStyle(fontFamily: 'Poppin'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      const _Placeholder(label: 'Search'),
      const _Placeholder(label: 'Notifications'),
      const _Placeholder(label: 'Profile'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      appBar: AppBar(
        backgroundColor: const Color(0xffE5E5E5),
        leading: const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0), child: Icon(Icons.menu)),
        title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text("Hello User !!", style: TextStyle(fontFamily: 'Poppin'))),
        actions: const [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Icon(Icons.notifications))
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  Widget _buildHome() {
    final visible = _query.isEmpty
        ? kSpecialties
        : kSpecialties
            .where((s) => s.label.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text("Welcome Back",
                style: TextStyle(
                    fontFamily: 'Poppin',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color.fromARGB(255, 63, 151, 158))),
            const SizedBox(height: 5),
            const Text("What are you looking for?",
                style: TextStyle(
                    fontFamily: 'Poppin',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff565656))),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 42, 42, 42)
                        .withValues(alpha: 0.5),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  )
                ],
                color: const Color.fromARGB(255, 232, 232, 232),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                      decoration: const InputDecoration(
                          hintText: "Search the Doctor",
                          hintStyle:
                              TextStyle(fontFamily: 'Poppin', fontSize: 17),
                          border: InputBorder.none),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (visible.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text("No matching specialties",
                      style: TextStyle(fontFamily: 'Poppin', fontSize: 16)),
                ),
              )
            else
              // A grid replaces the two hand-built columns, so the cards reflow
              // instead of overflowing on narrow screens.
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 130 / 150,
                children: visible
                    .map((s) => _SpecialtyCard(
                          specialty: s,
                          onTap: () => _openSpecialty(s),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SpecialtyCard extends StatelessWidget {
  final Specialty specialty;
  final VoidCallback onTap;

  const _SpecialtyCard({required this.specialty, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: specialty.color,
      borderRadius: BorderRadius.circular(15),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(specialty.asset, width: specialty.imageWidth),
              ),
              const SizedBox(height: 4),
              Text(
                specialty.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'Poppin',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff565656)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String label;

  const _Placeholder({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label is not built yet',
        style: const TextStyle(fontFamily: 'Poppin', fontSize: 16),
      ),
    );
  }
}
