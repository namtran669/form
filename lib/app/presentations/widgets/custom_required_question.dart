import 'package:flutter/material.dart';
import 'package:talosix/app/styles/app_styles.dart';

class RequiredText extends StatelessWidget {
  const RequiredText(this.text, {Key? key, this.style}) : super(key: key);
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
        text: TextSpan(
          text: text,
          style: style ?? AppTextStyles.w400s16black,
          children:  const [
            TextSpan(
              text: '*',
              style:  AppTextStyles.w600s18red,
            )
          ],
        ),
      )
    ]);
  }
}
