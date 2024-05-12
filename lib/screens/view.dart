import 'package:dementia_care/components/coustom_bottom_nav_bar.dart';
import 'package:dementia_care/helper/enums.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dementia_care/components/snackbar.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late String? userId = user?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _imageStream = _firestore
      .collection('images')
      .where('care', isEqualTo: userId)
      .snapshots();
  String _selectedUserName = "";
  List<String> _userNames = [];
  final Map<String, bool> _isImageExpandedMap = {};

  @override
  void initState() {
    super.initState();
    _fetchUserCareOptions();
  }

  Future<void> _getUser(name) async {
    setState(() {
      _imageStream = _firestore
          .collection('images')
          .where('care', isEqualTo: userId)
          .where('owner', isEqualTo: name)
          .snapshots();
    });
  }

  Future<void> _fetchUserCareOptions() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user')
        .where('care', isEqualTo: userId)
        .get();

    List<String> userNames = querySnapshot.docs
        .map(
            (doc) => doc['name'] as String) // Ensure userName is cast to String
        .toList();

    setState(() {
      _selectedUserName = userNames[0];
      _userNames = userNames;
    });
  }

  Future<void> _deleteImage(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('images').doc(documentId).delete();
      // Optionally, you can also delete the image from Firebase Storage if needed
      // await FirebaseStorage.instance.refFromURL(document['url']).delete();
      snackBar(context, "Image deleted");
    } catch (e) {
      print('Error deleting image: $e');
      snackBar(context, "Failed to delete image");
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
          title: const Text('View',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0))),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 160, left: 40),
              child: DropdownButton<String>(
                value: _selectedUserName,
                hint: const Text('Select User Name'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUserName = newValue!;
                    _getUser(newValue);
                  });
                },
                items: _userNames.map((String userName) {
                  return DropdownMenuItem<String>(
                    value: userName,
                    child: Text(userName),
                  );
                }).toList(),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _imageStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var document = snapshot.data!.docs[index];
                        String imageId = document.id;
                        // Initialize the expanded state for each image
                        _isImageExpandedMap.putIfAbsent(imageId, () => false);
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(document['owner']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _deleteImage(document.id),
                                    ),
                                    IconButton(
                                      icon: Icon(_isImageExpandedMap[imageId] ?? false ? Icons.arrow_drop_up : Icons.keyboard_arrow_down),
                                      onPressed: () {
                                        setState(() {
                                          _isImageExpandedMap[imageId] = !(_isImageExpandedMap[imageId] ?? false);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (_isImageExpandedMap[imageId] ?? false)
                                Image.network(document['url'])
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.view),
    );
  }
}
