import 'package:dementia_care/screens/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/upload.dart';
import '../screens/map.dart';
import '../screens/register.dart';
import '../helper/enums.dart';
import '../screens/view.dart';

class CustomBottomNavBar extends StatefulWidget {
  final MenuState? selectedMenu;

  const CustomBottomNavBar({super.key, required this.selectedMenu});
  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late MenuState _selectedMenuState;

  @override
  void initState() {
    _selectedMenuState = widget.selectedMenu!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color.fromARGB(255, 128, 126, 126);
    // ignore: constant_identifier_names
    const Color ActiveIconColor = Color.fromARGB(255, 174, 118, 238);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Color.fromARGB(232, 250, 250, 250),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: Color.fromARGB(90, 22, 0, 43).withOpacity(0.08),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Transform.scale(
                  scale: MenuState.upload == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Conversation.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.upload == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Upload()))
                    },
                  )),
              Transform.scale(
                  scale: MenuState.view == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Bell.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.view == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ViewScreen()))
                    },
                  )),
              Transform.scale(
                  scale: MenuState.map == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Plus Icon.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.map == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Map()))
                    },
                  )),
              Transform.scale(
                  scale: MenuState.register == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Mail.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.register == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Register()))
                    },
                  )),
                    Transform.scale(
                  scale: MenuState.logout == _selectedMenuState ? 1.5 : 1.3,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Star Icon.svg",
                      // ignore: deprecated_member_use
                      color: MenuState.logout == _selectedMenuState
                          ? ActiveIconColor
                          : inActiveIconColor,
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LogOutScreen()))
                    },
                  ))
            ],
          )),
    );
  }
}
