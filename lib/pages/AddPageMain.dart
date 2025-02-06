import 'package:flutter/material.dart';
import '../utils.dart';
import '../FavouritePage.dart';
import 'AddPage.dart';
import 'ListPage.dart';
import 'aboutUs.dart';

class AddPageMain extends StatefulWidget {
  final int initialPageIndex;
  const AddPageMain({super.key,required this.initialPageIndex});
  @override
  State<AddPageMain> createState() => _AddPageMainState();
}

class _AddPageMainState extends State<AddPageMain> {
  late PageController pageController;
  var pages = [AddPage(),ListPage(),Favouritepage(),AboutUsPage()];
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialPageIndex; // Set the initial page index
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NOTRU'),backgroundColor: Color(0xd79f1761),),
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 100,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
            pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 400),curve: Easing.emphasizedAccelerate);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add),label: 'Add',backgroundColor: Color(0xFF91356A)),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt),label: 'View',backgroundColor: Color(0xFF91356A)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favourite',backgroundColor: Color(0xFF91356A)),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'About Us',backgroundColor: Color(0xFF91356A)),
      ]),
    );
  }
}
