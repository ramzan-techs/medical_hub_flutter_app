import 'package:flutter/material.dart';

import '../../../../main.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: mq.width * .4,
        width: mq.width * .3,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 133, 201, 135),
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Icon(Icons.heart_broken),
        ),
      ),
    );
  }
}
