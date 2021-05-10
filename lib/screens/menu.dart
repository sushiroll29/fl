import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl/constants.dart';
import 'package:fl/screens/credits.dart';
import 'package:fl/screens/add_new_pet.dart';
import 'package:fl/screens/favorites.dart';
import 'package:fl/screens/home.dart';
import 'package:fl/screens/map.dart';
import 'package:fl/screens/my_pets_updated.dart';
import 'package:fl/screens/profile.dart';
import 'package:fl/screens/sign_out.dart';
import 'package:fl/widgets/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  FirebaseUser user;
  Future<void> getUserData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  int selectedItemIndex = 0;
  int selectedBottomItemIndex = -1;

  final bool isMenuOpen = false;

  List<String> bottomMenuItems = [
    'Credits',
    'Log out',
  ];

  List<IconData> bottomMenuIcons = [
    FontAwesomeIcons.infoCircle,
    FontAwesomeIcons.signOutAlt,
  ];

  List<String> menuItems = [
    'Adoption',
    'My pets',
    'Add pet',
    'Map',
    'Favorites',
    'Profile',
  ];

  List<IconData> menuIcons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.list,
    FontAwesomeIcons.plus,
    FontAwesomeIcons.solidMap,
    FontAwesomeIcons.solidHeart,
    FontAwesomeIcons.userAlt,
  ];

  List<Widget> menuPages = [
    HomePage(),
    MyPetsPage(),
    AddNewPetPage(),
    MapPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  List<Widget> bottomMenuPages = [
    CreditsPage(),
    SignOutPage(),
  ];

  Widget buildMenuList(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => menuPages[selectedItemIndex]),
        );
        setState(() {
          selectedItemIndex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: <Widget>[
            Icon(
              menuIcons[index],
              color: selectedItemIndex == index ? Colors.white : Colors.white38,
              size: 17,
            ),
            SizedBox(width: 15),
            Text(
              menuItems[index],
              style: TextStyle(
                fontSize: 20,
                color:
                    selectedItemIndex == index ? Colors.white : Colors.white38,
                fontFamily: GoogleFonts.quicksand(fontWeight: FontWeight.bold)
                    .fontFamily,
              ),
            ),
            //Scaffold(
            //body: _children[selectedItemIndex],
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomMenuList(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => bottomMenuPages[selectedBottomItemIndex]),
        );
        setState(() {
          selectedBottomItemIndex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: <Widget>[
            Icon(
              bottomMenuIcons[index],
              color: Colors.white,
              size: 17,
            ),
            SizedBox(width: 15),
            Text(
              bottomMenuItems[index],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: GoogleFonts.quicksand(fontWeight: FontWeight.bold)
                    .fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: Container(
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: FutureBuilder(
                          future: Provider.of(context).auth.getCurrentUser(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return displayUserInformation(context, snapshot);
                            } else {
                              return CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.white,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: menuItems
                        .asMap()
                        .entries
                        .map((e) => buildMenuList(e.key))
                        .toList(),
                  ),
                  Column(
                    children: bottomMenuItems
                        .asMap()
                        .entries
                        .map((e) => buildBottomMenuList(e.key))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [aPrimaryStartingColor, aPrimaryColor],
          )),
        ),
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;

    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(0),
        child: Text("${authData.displayName}",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily:
                  GoogleFonts.quicksand(fontWeight: FontWeight.w600).fontFamily,
            )),
      ),
    ]);
  }
}
