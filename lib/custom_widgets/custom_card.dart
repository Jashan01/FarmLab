import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  //const CustomButton({key}) : super(key: key);
  CustomCard(
      { @required this.text ,
        @required this.value });
  final String text;
  final String value;
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Container(
        height: 80,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                text,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 30.0,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

