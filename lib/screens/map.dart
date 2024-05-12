import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../components/coustom_bottom_nav_bar.dart';
import '../helper/enums.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  User? user = FirebaseAuth.instance.currentUser;
  late String? userId = user?.uid;
  List<Marker> markers = [];
  late Timer timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  bool initialLoad = true; // Flag to track initial load
  int notificationIdCounter = 0;

  Future<void> initializeNotifications() async {
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    _setUpSosStatusListener(); // Set up SOS status listener
    _updateUserLocations(); // Load locations when map screen is opened
    timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => _updateUserLocations());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _updateUserLocations() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('user').get();
      setState(() {
        markers.clear();
        markers.addAll(querySnapshot.docs
            .where((user) =>
        user['role'] == 'patient' && user['care'] == userId)
            .map((user) {
          // Handle null values and ensure data type compatibility
          double? latitude = user['latitude'] is int
              ? (user['latitude'] as int).toDouble()
              : user['latitude'];
          double? longitude = user['longitude'] is int
              ? (user['longitude'] as int).toDouble()
              : user['longitude'];
          double x = longitude ?? 0.0;
          double y = latitude ?? 0.0;

          if (initialLoad) {
            // Perform initial load tasks
            _checkDistanceFromOriginalPosition(
                user['name'], latitude, longitude, user['x'], user['y']);

            if (user['sos']) {
              _scheduleNotification(
                  'SOS Alert!',
                  'Emergency SOS Alert!',
                  "${user['name']} has sent a SOS Alert!");
              _updateSos(user.id); // Changed to use document ID
            }
          }

          return Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(y, x),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: user['name']),
                    const WidgetSpan(
                      child: Icon(Icons.person_pin_circle,
                          size: 38.0, color: Color.fromARGB(255, 255, 17, 0)),
                    )
                  ],
                ),
              ));
        }));
      });
      initialLoad = false; // Set initialLoad to false after initial load
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user locations: $e");
      }
    }
  }

  void _setUpSosStatusListener() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        bool sosStatus = snapshot.get('sos') ?? false;
        if (sosStatus) {
          // SOS status changed to true, trigger SOS alert
          _triggerSosAlert(); // Trigger the SOS alert
        }
      }
    });
  }

  void _triggerSosAlert() {
    _scheduleNotification('SOS Alert!', 'Emergency SOS Alert!',
        'An SOS alert has been triggered.');
  }

  void _checkDistanceFromOriginalPosition(
      String name, double? lat, double? lon, double? originalLat, double? originalLon) {
    if (lat == null || lon == null || originalLat == null || originalLon == null) {
      return; // If any of the coordinates are null, return without calculating distance
    }

    print("Current Location: $lat, $lon");
    print("Original Location: $originalLat, $originalLon");

    double distance = const Distance().as(
      LengthUnit.Meter,
      LatLng(originalLat, originalLon),
      LatLng(lat, lon),
    );

    print("Distance: $distance meters");

    if (distance > 100) {
      _scheduleNotification(name, 'Location Alert',
          '$name is 100 meters or more away from the original location');
    }
  }

  Future<void> _scheduleNotification(
      String type, String title, String message) async {
    var priority = type == 'SOS Alert!' ? Priority.max : Priority.high;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: priority,
      ticker: 'ticker',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Increment the counter to generate a unique notification ID
    notificationIdCounter++;

    await flutterLocalNotificationsPlugin.show(
      notificationIdCounter,
      title,
      message,
      platformChannelSpecifics,
    );
  }

  Future<void> _updateSos(String id) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(id).update({
        'sos': false,
      });
      if (kDebugMode) {
        print('SoS updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating SoS: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: const Color.fromARGB(48, 0, 0, 0),
          centerTitle: true,
          title: const Text(
            'Map',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(7.873054, 80.771797),
          initialZoom: 8,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.map),
    );
  }
}
