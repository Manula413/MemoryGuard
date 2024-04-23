import 'package:dementia_care/components/coustom_bottom_nav_bar.dart';
import 'package:dementia_care/components/curve_btn.dart';
import 'package:dementia_care/helper/enums.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogOutScreen extends StatefulWidget {
  const LogOutScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogOutScreenState createState() => _LogOutScreenState();
}

class _LogOutScreenState extends State<LogOutScreen> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/login');
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
            title: const Text('SignOut',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Center(
            child: Card(
                margin: const EdgeInsets.only(top: 100.0),
                elevation: 5,
                shadowColor: Colors.black,
                color: const Color.fromARGB(255, 255, 255, 255),
             
                        child: CurvedGradientButton(
                          gradientColors: const [
                            Color.fromARGB(255, 219, 184, 233),
                            Color.fromARGB(255, 188, 150, 250)
                          ],
                          text: "SignOut",
                          onPressed: () async {
                            _signOut();
                          },
                          width: 100,
                    
                        ))),
        bottomNavigationBar:
            const CustomBottomNavBar(selectedMenu: MenuState.logout));
  }
}
