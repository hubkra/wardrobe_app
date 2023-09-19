import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wardrobe_app/widgets/profile_page.dart';
import '../models/wardrobe.dart';
import 'outfit/outfits-card.dart';
import 'wardrobe_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  final int outfitId;

  const HomePage({Key? key, required this.username, required this.outfitId})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomePageContent(username: widget.username, outfitId: widget.outfitId),
      WardrobePage(),
      ProfilePage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.deepPurple.shade800,
            gap: 8,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.checkroom,
                text: 'Wardrobe',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final String username;
  final int outfitId;

  const HomePageContent(
      {Key? key, required this.username, required this.outfitId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TableCalendar(
            calendarFormat: CalendarFormat.week,
            focusedDay: DateTime.now(),
            firstDay:
                DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
            lastDay:
                DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 0),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              weekendTextStyle: const TextStyle(color: Colors.red),
              holidayTextStyle: const TextStyle(color: Colors.blue),
              todayDecoration: BoxDecoration(
                color: Colors.deepPurple.shade800,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Good morning',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.username,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 550,
                        child: OutfitsCard(outfitId: widget.outfitId),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
