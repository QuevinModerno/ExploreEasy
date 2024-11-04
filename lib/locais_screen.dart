import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'LikeButton.dart';
import 'PlacesScreen.dart';
import 'firebase_options.dart';

class LocaisScreen extends StatefulWidget {
  const LocaisScreen({Key? key}) : super(key: key);
  static const String routeName = '/LocaisScreen';

  @override
  State<LocaisScreen> createState() => _LocaisScreenState();
}

class _LocaisScreenState extends State<LocaisScreen> {
  Location location = Location();
  bool isButtonPressed = false;
  LocationData _locationData = LocationData.fromMap({
    "latitude": 40.192639,
    "longitude": -8.411899,
  });

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(title: const Text("Locais de Interesse")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('location')
            .orderBy('Name')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var documents = snapshot.data!.docs;
          Map<int, bool> likeStatus = {};
          bool isLiked = false;
          return Center(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),

                Text(
                  'Locais:',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),

                Expanded(

                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var description = documents[index]['Description'];
                      var name = documents[index]['Name'];
                      var user = documents[index]['Useradded'];


                      if (!likeStatus.containsKey(index)) {
                        likeStatus[index] = false;
                      }

                      return GestureDetector(
                          onTap: () {
                            LocalData data = LocalData(
                              name: name ?? 'N/A',
                              description: description ?? 'N/A',
                              user: user ?? 'N/A',
                            );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlacesScreen(locationData: data, userLocation: _locationData),
                          ),
                        );
                      },
                      child: Card(

                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Colors.blueGrey[800],
                      child: ListTile(

                        title: Text(name ?? '',
                          style: const TextStyle(color: Colors.black87),),
                        trailing: LikeButton(itemId: name),
                        subtitle: Text('Description: ${description ?? 'N/A'}',
                          style: const TextStyle(color: Colors.white),),
                      ),
                      ),
                      );
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
