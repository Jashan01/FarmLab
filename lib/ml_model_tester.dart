import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MlModelTester extends StatefulWidget {
  const MlModelTester({Key key}) : super(key: key);

  @override
  _MlModelTesterState createState() => _MlModelTesterState();
}

class _MlModelTesterState extends State<MlModelTester> {
  var data='no value';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Edit Profile")),
      ),
      body: Center(
        child: Column(
          children: [
            Text(data),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                Interpreter interpreter = await Interpreter.fromAsset('model.tflite');

                // For ex: if input tensor shape [1,5] and type is float32
                var input = [200.21];

                // if output tensor shape [1,2] and type is float32
                var output = [[0.0]];

                interpreter.run(input, output);
                interpreter.run(input, output);
                setState(() {
                  data=output.toString();
                });
              },
              child: Text('ML model tester'),
            ),
          ],
        ),
      ),
    );
  }
}
