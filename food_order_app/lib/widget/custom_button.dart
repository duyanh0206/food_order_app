import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isDisabled;
  final double borderRadius;
  final double fontSize;
  final double paddingVertical;
  final BorderSide? border;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.deepOrange,
    this.textColor = Colors.white,
    this.isDisabled = false,
    this.borderRadius = 12.0,
    this.fontSize = 16.0,
    this.paddingVertical = 14.0,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: paddingVertical),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: border ?? BorderSide.none,
          ),
          textStyle: TextStyle(fontSize: fontSize),
        ),
        child: Text(text, style: TextStyle(color: textColor)),
      ),
    );
  }
}
