import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dementia_care/components/coustom_bottom_nav_bar.dart';
import '../components/default_button.dart';
import '../helper/enums.dart';
import 'update_patient.dart'; // Import the UpdatePatientScreen


class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  late CollectionReference<Map<String, dynamic>> _patientsRef;

  @override
  void initState() {
    super.initState();
    _patientsRef = FirebaseFirestore.instance.collection('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: const Color.fromARGB(48, 0, 0, 0),
          centerTitle: true,
          title: const Text('Patients',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0))),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _patientsRef.where('care', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final patients = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: PatientCard(patient: patient),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.view_patients),
    );
  }
}

class PatientCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> patient;

  const PatientCard({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          patient['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Email: ${patient['email']}\nContact: ${patient['contact']}',
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatientDetailsScreen(patient: patient)),
          );
        },
      ),
    );
  }
}


class PatientDetailsScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> patient;

  const PatientDetailsScreen({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: const Color.fromARGB(48, 0, 0, 0),
          centerTitle: true,
          title: Text(
            patient['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoTile('Email', patient['email']),
                _buildInfoTile('Contact', patient['contact']),
                _buildInfoTile('Longitude', patient['longitude'].toString()),
                _buildInfoTile('Latitude', patient['latitude'].toString()),
                const SizedBox(height: 20),
                Center( // Wrap the button with Center widget
                  child: DefaultButton(
                    text: 'Edit', // Text for the button
                    press: () {
                      _navigateToUpdatePatient(context, patient);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.view_patients),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        '$label: $value',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _navigateToUpdatePatient(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdatePatientScreen(patient: patient),
      ),
    );
  }
}
