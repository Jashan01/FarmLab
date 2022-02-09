import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  //const CustomButton({key}) : super(key: key);
  CustomCard(
      { @required this.text ,
        @required this.value,
        @required this.fsize1 ,
        @required this.fsize2,
        @required this.ht ,
        @required this.wd,
        @required this.br
      });
  final String text;
  final String value;
  final double fsize1;
  final double fsize2;
  final double ht;
  final double wd;
  final double br;

  @override
  Widget build(BuildContext context) {
    return  Container(

        decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(br),
            boxShadow: [new BoxShadow(
              color: Color(0xFFBDBDBD).withOpacity(0.4),
              spreadRadius: 0.5,
              blurRadius: 2.0,
              offset: Offset(1,2)
            ),]
        ),

        width: wd,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(6,8,6,10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                text,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: fsize1,
                  color: Color(0xFFBDBDBD),
                ),
              ),
              SizedBox(
                height: ht,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: fsize2,
                  color: Color(0xFF151515),
                  fontWeight: FontWeight.w700
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
    );
  }
}

