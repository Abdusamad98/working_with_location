import 'package:flutter/material.dart';

class MyCustomExpansion extends StatelessWidget {
  const MyCustomExpansion(
      {Key? key,
      required this.types,
      required this.typeText,
      required this.onPresses})
      : super(key: key);

  final List<String> types;
  final String typeText;
  final ValueChanged<String> onPresses;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        typeText.isEmpty ? "Manzil turini tanlang!" : typeText,
      ),
      children: List.generate(types.length, (index) {
        String currency = types[index];
        return SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              onPresses.call(currency);
            },
            child: Text(currency),
          ),
        );
      }),
    );
  }
}
