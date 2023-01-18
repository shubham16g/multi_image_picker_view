import 'package:flutter/material.dart';

import 'custom/custom_1.dart';

class CustomExamples extends StatelessWidget {
  const CustomExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Custom Examples:',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Custom1()));
            },
            child: const Text('Custom 1'),
          ),
        ],
      ),
    );
  }
}
