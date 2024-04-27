import 'package:flutter/material.dart';

class UserChats extends StatelessWidget {
  const UserChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
            child: Row(
              children: [Text("Hello Ramzan")],
            ),
          ),
        ],
      ),
    );
  }
}
