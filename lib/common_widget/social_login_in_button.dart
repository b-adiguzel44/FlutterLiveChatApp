import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {

  final String? buttonText;
  final Color? buttonBackColor;
  final Color? buttonForeColor;
  final Color? textColor;
  final double? radius;
  final double? height;
  final Widget? buttonIcon;
  final VoidCallback? onPressed;

  const SocialLoginButton(
    {super.key,
    this.buttonText = "Placeholder",
    this.buttonBackColor = Colors.deepPurple,
    this.buttonForeColor = Colors.grey,
    this.textColor = Colors.white,
    this.radius = 16.0,
    this.height = 40,
    this.buttonIcon, this.onPressed})
    : assert(buttonText != null, onPressed != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBackColor,
            foregroundColor: buttonForeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  radius != null ? radius! : 16.0
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //Spreads example below
              // if buttonIcon isn't null, then add these following Widgets
              if(buttonIcon != null) ...[
                buttonIcon!,
                Text(
                  buttonText != null ? buttonText! : "Placholder",
                  style: TextStyle(color: textColor),
                ),
                Opacity(opacity: 0.0, child: buttonIcon!)
              ],

              // if buttonIcon is null, then add these following Widgets
              if(buttonIcon == null) ...[
                Container(),
                Text(
                  buttonText != null ? buttonText! : "Placholder",
                  style: TextStyle(color: textColor),
                ),
                Container(),
              ]

            ],
          ),
        ),
      ),
    );
  }
}