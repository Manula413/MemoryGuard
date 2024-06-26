import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helper/size_config.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String?> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index]!)),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/Error.svg",
          height: getRelativeScreenWidth(14),
          width: getRelativeScreenWidth(14),
        ),
        SizedBox(
          width: getRelativeScreenWidth(20),
        ),
        Text(error,style:const TextStyle(
                      color: Color.fromARGB(255, 221, 59, 59)))
      ],
    );
  }
}
