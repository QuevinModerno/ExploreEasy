import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MaisVisitadosScreen extends StatefulWidget {
  const MaisVisitadosScreen({Key? key}) : super(key: key);
  static const String routeName = '/MaisVisitadosScreen';

  @override
  State<MaisVisitadosScreen> createState() => _MaisVisitadosScreenState();
}

class _MaisVisitadosScreenState extends State<MaisVisitadosScreen> {
  late SharedPreferences _prefs;
  late List<String> clickedItems;
  late List<Map<String, dynamic>> placeDetails;

  @override
  void initState() {
    super.initState();
    _loadClickedItems();
  }

  Future<void> _loadClickedItems() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      clickedItems = _prefs.getStringList('clickedItems') ?? [];
    });
    await _fetchPlaceDetails();
  }

  Future<void> _fetchPlaceDetails() async {
    placeDetails = [];

    for (String itemName in clickedItems) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Place')
          .where('Name', isEqualTo: itemName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        placeDetails.add(querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
    }

    setState(() {
      placeDetails = placeDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(title: const Text("Lugares Mais Visitados")),
      body: ListView.builder(
        itemCount: clickedItems.length,
        itemBuilder: (context, index) {
          if (placeDetails.isEmpty || placeDetails.length <= index) {
            return ListTile(
              title: Text(
                clickedItems[index],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Carregando...',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          var place = placeDetails[index];

          return ListTile(
            title: Text(
              '${place['Name']} ${place['location'] != null ? '- ${place['location']}' : ''}',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                place['Description'] ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                place['category'] ?? '',
                style: const TextStyle(color: Colors.white),
              )

              ],
          ),
          );
        },
      ),
    );
  }
}