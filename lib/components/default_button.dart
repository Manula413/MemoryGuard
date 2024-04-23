import 'package:flutter/material.dart';
import '../helper/size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getRelativeScreenWidth(218),
      height: getRelativeScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),

          backgroundColor:Color.fromARGB(255, 154, 99, 206),
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: TextStyle(
            fontSize: getRelativeScreenWidth(18),
            color:const Color.fromARGB(255, 5, 5, 5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
