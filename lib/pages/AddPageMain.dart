import 'package:flutter/material.dart';
import '../utils.dart';
import '../FavouritePage.dart';
import 'AddPage.dart';
import 'ListPage.dart';
import 'aboutUs.dart';

class AddPageMain extends StatefulWidget {
  final int initialPageIndex;
  const AddPageMain({super.key, required this.initialPageIndex});

  @override
  State<AddPageMain> createState() => _AddPageMainState();
}

class _AddPageMainState extends State<AddPageMain> {
  late PageController pageController;
  late int currentIndex;

  final pages = [
    AddPage(),
    ListPage(),
    Favouritepage(),
    AboutUsPage()
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialPageIndex;
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18), // Adjust the bottom border radius
          ),
        ),
        title: const Text(
          'NOTRU',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          onTap: (index) {
            setState(() {
              clerInput();
              currentIndex = index;
              pageController.animateToPage(
                currentIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'View',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'About Us',
            ),
          ],
        ),
      ),
    );
  }
}