import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapasScreen extends StatefulWidget {
  const MapasScreen({Key? key}) : super(key: key);
  static const String routeName = '/MapasScreen';

  @override
  State<MapasScreen> createState() => _MapasScreenState();
}

class _MapasScreenState extends State<MapasScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(40.192639, -8.411899);
  Set<Marker> _markers = {};

  void _addMarker(double lat, double lng, String name) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(name),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: name),
        ),
      );
    });
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fetchDataFromFirestore();
  }
  Future<void> _fetchDataFromFirestore() async {
    try {

      CollectionReference places = FirebaseFirestore.instance.collection('Place');


      QuerySnapshot querySnapshot = await places.get();


      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        double latitude = data['latitude'];
        double longitude = data['longitude'];
        String name = data['Name'];


        _addMarker(latitude, longitude, name);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
         appBar: AppBar(
            title: const Text('Mapa'),
            backgroundColor: Colors.white,
           leading: IconButton(
             icon: Icon(Icons.arrow_back),
             onPressed: (){
               Navigator.pop(context);
             },
           ),


                       ),
            body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
                markers: _markers),

        )
    );
  }
}

