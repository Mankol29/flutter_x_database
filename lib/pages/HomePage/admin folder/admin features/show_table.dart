import 'package:flutter/material.dart';

class ShowTable extends StatelessWidget {
  const ShowTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.purple,
      ),
      height: 70,
      child: const Center(
        child: Text(
          "Wyswietl tabele.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}



