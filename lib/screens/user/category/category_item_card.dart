import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/screens/user/doctors_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';

import 'category_screen.dart';

class CategoryItemCard extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;
  final String categoryName;
  final bool isSubCatgeries;
  const CategoryItemCard(
      {super.key,
      required this.height,
      required this.width,
      required this.imageUrl,
      required this.categoryName,
      required this.isSubCatgeries});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSubCatgeries
            ? Navigator.push(
                context,
                PageTransition(
                    child: const DoctorsScreen(),
                    type: PageTransitionType.scale,
                    alignment: Alignment.centerRight,
                    duration: const Duration(milliseconds: 1200)))
            : Navigator.push(
                context,
                PageTransition(
                    child: CategoryScreen(categoryName: categoryName),
                    type: PageTransitionType.scale,
                    alignment: Alignment.centerRight,
                    duration: const Duration(milliseconds: 1200)));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: width,
            height: isSubCatgeries ? height * 0.8 : height * 0.6,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              shadowColor: Colors.green,
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[200]!,
                        child: Container(
                          color: Colors.white,
                        )),
                    imageUrl: imageUrl,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                    ),
                  )),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            width: width - 10,
            child: Text(
              categoryName,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: isSubCatgeries ? 22 : 18,
                  fontWeight: FontWeight.w500,
                  color: Constants().secondaryTextColor),
            ),
          )
        ],
      ),
    );
  }
}
