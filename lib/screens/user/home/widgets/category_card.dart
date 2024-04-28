import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class CategoryCard extends StatelessWidget {
  final String imagePath;
  const CategoryCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: mq.width * 0.36,
        height: mq.width * 0.35,
        child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            shadowColor: Colors.green,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                placeholder: (context, url) => const Icon(Icons.person),
                imageUrl: imagePath,
                errorWidget: (context, url, error) =>
                    const Icon(CupertinoIcons.person),
              ),
            )),
      ),
    );
  }
}
