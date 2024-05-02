import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/default_button.dart';
import '../components/coustom_bottom_nav_bar.dart';
import '../components/snackbar.dart';
import '../helper/enums.dart';

class UpdatePatientScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> patient;

  const UpdatePatientScreen({Key? key, required this.patient}) : super(key: key);

  @override
  _UpdatePatientScreenState createState() => _UpdatePatientScreenState();
}

class _UpdatePatientScreenState extends State<UpdatePatientScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _longitudeController;
  late TextEditingController _latitudeController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add GlobalKey<FormState>

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient['name']);
    _emailController = TextEditingController(text: widget.patient['email']);
    _contactController = TextEditingController(text: widget.patient['contact']);
    _longitudeController =
        TextEditingController(text: widget.patient['longitude'].toString());
    _latitudeController =
        TextEditingController(text: widget.patient['latitude'].toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    super.dispose();
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
          title: const Text(
            'Update Patient',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Wrap with Form widget
          key: _formKey, // Assign GlobalKey
          child: ListView(
            children: [
              _buildTextField(label: 'Name', controller: _nameController),
              _buildTextField(label: 'Email', controller: _emailController),
              _buildTextField(label: 'Contact', controller: _contactController),
              _buildTextField(
                  label: 'Longitude', controller: _longitudeController),
              _buildTextField(label: 'Latitude', controller: _latitudeController),
              const SizedBox(height: 20),
              DefaultButton(
                text: 'Update',
                press: () {
                  _updatePatientData(context);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.view_patients),
    );
  }

  Widget _buildTextField(
      {required String label, required TextEditingController controller}) {
    return ListTile(
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  void _updatePatientData(BuildContext context) async {
    if (_formKey.currentState!.validate()) { // Validate the form
      try {
        await widget.patient.reference.update({
          'name': _nameController.text,
          'email': _emailController.text,
          'contact': _contactController.text,
          'longitude': _longitudeController.text,
          'latitude': _latitudeController.text,
        });

        // Display a snack bar message on successful update
        snackBar(context, 'Patient data updated successfully.');

        Navigator.pop(context);
        Navigator.pop(context);
      } catch (error) {
        print('Error updating patient: $error');
        snackBar(context, 'Error updating patient data. Please try again later.');
      }
    }
  }

}
