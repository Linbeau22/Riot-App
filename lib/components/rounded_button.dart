import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {required this.label, required this.onPressed, required this.color});

  final String label;
  final GestureTapCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      height: 45,
      width: MediaQuery.of(context).size.width / 1.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: color,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'SourceCodePro',
          ),
        ),
      ),
    );
  }
}
