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
  const Map({super.key});

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
            .where(
                (user) => user['role'] == 'patient' && user['care'] == userId)
            .map((user) {
          double x = user['longitude'] ?? 0.0;
          double y = user['latitude'] ?? 0.0;

          _checkDistanceFromOriginalPosition(user['name'], user['latitude'],
              user['longitude'], user['x'], user['y']);

          if (user['sos']) {
            _scheduleNotification(
                user['name'], 'SoS Alert', "${user['name ']}sos");
            _updateSos(user['uid']);
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
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user locations: $e");
      }
    }
  }

  void _checkDistanceFromOriginalPosition(name, lat, lon, x, y) {
    double distance = const Distance().as(
      LengthUnit.Meter,
      LatLng(y, x),
      LatLng(lat, lon),
    );

    if (distance > 100) {
      _scheduleNotification(name, 'Location Alert',
          '$name 100 meters or more away from the original location');
    }
  }

  Future<void> _scheduleNotification(name, type, message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
        0, type, message, platformChannelSpecifics);
  }

  Future<void> _updateSos(id) async {
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
          title: const Text('Map',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0))),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FlutterMap(
        options: const MapOptions(
            initialCenter: LatLng(7.873054, 80.771797), initialZoom: 8),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.map),
    );
  }
}
