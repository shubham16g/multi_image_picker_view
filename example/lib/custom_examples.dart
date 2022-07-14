import 'package:flutter/material.dart';

import 'custom/custom_1.dart';

class CustomExamples extends StatelessWidget {
  const CustomExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Custom Examples:',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Custom1()));
          },
          child: Text('Custom 1'),
        ),
      ],
    );
  }
}
