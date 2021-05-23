import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl/screens/menu_items/detailed_pet.dart';
import 'package:fl/widgets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl/models/Pet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  final Pet pet;
  MapPage({Key key, this.pet}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController myController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  FirebaseUser user;
  bool loading;
  var _currentPosition;

  void initState() {
    loading = false;
    getUserData();
    getMarkerData();
    getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Find pets around you',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: GoogleFonts.quicksand(fontWeight: FontWeight.normal)
                  .fontFamily,
            ),
          ),
          backgroundColor: aPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: loading
            ? GoogleMap(
                markers: Set<Marker>.of(markers.values),
                mapType: MapType.normal,
                //myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  myController = controller;
                },
                initialCameraPosition:
                    CameraPosition(target: _currentPosition, zoom: 15),
              )
            : Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Please provide access to location services in order to use the map functionality.",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: aDarkGreyColor.withOpacity(0.9),
                          fontFamily: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.normal)
                              .fontFamily,
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }

  Future<void> getUserData() async {
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
    });
  }

  void getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      double latitude = position.latitude;
      double longitude = position.longitude;
      _currentPosition = LatLng(latitude, longitude);
      loading = true;
    });
  }

  getMarkerData() async {
    Firestore.instance.collection('petsStream').getDocuments().then((data) {
      if (data.documents.isNotEmpty) {
        for (int i = 0; i < data.documents.length; i++) {
          //data.documents[i]['favoritesID'] == data.documents[i].documentID;
          if (data.documents[i]['userId'] != "${user.uid}") {
            if (data.documents[i]['type'] == "dog") {
              initMarker(
                  data.documents[i].data, data.documents[i].documentID, 0.0);
            }
            if (data.documents[i]['type'] == "cat") {
              initMarker(
                  data.documents[i].data, data.documents[i].documentID, 17.0);
            }
            if (data.documents[i]['type'] == "parrot") {
              initMarker(
                  data.documents[i].data, data.documents[i].documentID, 69.0);
            }
            if (data.documents[i]['type'] == "guinea pig") {
              initMarker(
                  data.documents[i].data, data.documents[i].documentID, 117.0);
            }
            if (data.documents[i]['type'] == "hamster") {
              initMarker(
                  data.documents[i].data, data.documents[i].documentID, 182.0);
            }
            if (data.documents[i]['type'] == "rabbit") {
              initMarker(
                  data.documents[i].data, data.documents[i].documentID, 238.0);
            }
            if (data.documents[i]['type'] == "fish") {
              initMarker(
                  data.documents[i].data, data.documents[i].documentID, 280.0);
            }
            if (data.documents[i]['type'] == "snake") {
              initMarker(
                  data.documents[i].data, data.documents[i].documentID, 332.0);
            }
          }
        }
      }
    });
  }

  void initMarker(specify, specifyId, markerHue) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
      markerId: markerId,
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
      infoWindow: InfoWindow(
          title: specify['name'],
          snippet:
              "${specify['type']}, ${specify['gender'].toString().toLowerCase()}",
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailedPet(
                        pet: Pet(
                            specify['type'],
                            specify['name'],
                            specify['breed'],
                            specify['gender'],
                            specify['isVaccinated'],
                            specify['isStreilised'],
                            specify['location'],
                            specify['age'],
                            specify['foundOn'].toDate(),
                            specify['postDate'].toDate(),
                            specify['userId'],
                            specify['description'],
                            specify['userPhoneNumber'],
                            specify['usersName'],
                            specify['requiresSpecialCare'],
                            specify['hasMicrochip'],
                            specify['favoritesId'],
                            specify['petSize'],
                            specify['imageURL'],
                            specify['street'],
                            specify['city'],
                            specify['country']))));
          }),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }
}
