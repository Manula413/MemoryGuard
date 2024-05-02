import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dementia_care/components/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  late Position _currentPosition;
  late StreamSubscription<Position> _positionStreamSubscription;
  late Timer _timer;
  User? user = FirebaseAuth.instance.currentUser;
  late String? userId = user?.uid;
  late DocumentSnapshot data;
  late DocumentSnapshot data2;
  @override
  void initState() {
    super.initState();
    
    _getData();
    _getCurrentLocation();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateLocation();
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  Future<void> _updateLocation() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user?.uid)
          .update({
        'latitude': _currentPosition.latitude,
        'longitude': _currentPosition.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print('Location updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating location: $e');
      }
    }
  }

  Future<void> _getData() async {
    final userRef =
        FirebaseFirestore.instance.collection('user').doc(user?.uid);

    try {
      final userData = await userRef.get();

      final userRef2 =
          FirebaseFirestore.instance.collection('user').doc(userData['care']);
      final userData2 = await userRef2.get();
      print(userData['care']);
      setState(() {
        data = userData;
        data2 = userData2;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<void> sendNotification() async {

     try {
      snackBar(context, 'SoS Alert is sent. Help will be Here Soon');
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user?.uid)
          .update({
        'sos': true,
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
          title: const Text('Support',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0))),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: AvatarGlow(
          glowColor: const Color.fromARGB(255, 155, 97, 230),
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          animate: true,
          child: Material(
            color: Colors.blue,
            elevation: 8.0,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                sendNotification();
              },
              child: const SizedBox(
                width: 120.0,
                height: 120.0,
                child: Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
