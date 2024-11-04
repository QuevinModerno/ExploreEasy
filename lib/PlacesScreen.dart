import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'LikeButton.dart';

class PlacesScreen extends StatefulWidget {
  final LocalData locationData;
  final LocationData userLocation;

  const PlacesScreen(
      {Key? key, required this.locationData, required this.userLocation})
      : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlaceScreenState();
}


class _PlaceScreenState extends State<PlacesScreen> {
  bool isButtonPressed = false;
  late SharedPreferences _prefs;
  late List<String> clickedItems = [];
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData _locationData = LocationData.fromMap({
    "latitude": 40.192639,
    "longitude": -8.411899,
  });


  @override
  void initState() {
    super.initState();
    _loadClickedItems();
  }

  void _loadClickedItems() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      clickedItems = _prefs.getStringList('clickedItems') ?? [];
    });
  }

  void _saveClickedItems(String name) {
    if (clickedItems.contains(name)) {
      clickedItems.remove(name);
    }

    clickedItems.insert(0, name);

    if (clickedItems.length > 10) {
      clickedItems.removeLast();
    }

    _prefs.setStringList('clickedItems', clickedItems);
  }
  void getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text('Details for ${widget.locationData.name}'),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Place')
            .orderBy('Name')
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var documents = snapshot.data!.docs;

          if(!isButtonPressed) {
            documents.sort((a, b) =>
                (a['Name'].toString().toLowerCase())
                    .compareTo(b['Name'].toString().toLowerCase()));
          }
          else{
            if(widget.userLocation.latitude != null && widget.userLocation.longitude != null) {

              documents.sort((a, b) {
                double distanceA = calculateDistance(
                  _locationData.latitude!, _locationData.longitude!,
                  a['latitude'], a['longitude'],);

                double distanceB = calculateDistance(
                  widget.userLocation.latitude!, widget.userLocation.longitude!,
                  b['latitude'], b['longitude'],);

                return distanceA.compareTo(distanceB);
              });
            }
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'Latitude: ${_locationData.latitude}; Longitude: ${_locationData.longitude}',
                  style: const TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: getLocation,
                  child: const Text("Refresh"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isButtonPressed = !isButtonPressed;
                    });
                  },
                  child: Text('Change Order'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var description = documents[index]['Description'];
                      var name = documents[index]['Name'];
                      var user = documents[index]['Useradded'];
                      var docs = documents[index]['category'];
                      var lati = documents[index]['latitude'];
                      var loc = documents[index]['location'];
                      var lang = documents[index]['longitude'];


                      if (loc == widget.locationData.name) {
                        return GestureDetector(
                            onTap: () {
                                setState(() {

                                  _saveClickedItems(name);
                                });
                            } ,
                      child: Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Colors.blueGrey[800],

                        child: ListTile(
                            title: Text(
                               name ?? '',
                              style: const TextStyle(color: Colors.black87),
                            ),

                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description: ${description ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'User: ${user ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Category: ${docs ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Latitude: ${lati ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Location: ${loc ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Longitude: ${lang ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            trailing: LikeButton(itemId: name),
                          ),
                        ),
                        );
                      }
                      else {
                        return Container();
                      }


                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}



class LocalData {
  final String name;
  final String description;
  final String user;

  LocalData({required this.name, required this.description, required this.user,});
}


double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  double degToRad(double deg) {
    return deg * pi / 180.0;
  }

  double dLat = degToRad(lat2 - lat1);
  double dLon = degToRad(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(degToRad(lat1)) * cos(degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double earthRadius = 6371.0;
  double distance = earthRadius * c;

  return distance;
}