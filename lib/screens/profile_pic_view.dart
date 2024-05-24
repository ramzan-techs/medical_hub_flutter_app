import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:medical_hub/main.dart';
import 'package:shimmer/shimmer.dart';

class ProfileDialog extends StatelessWidget {
  final String name;
  final String imageUrl;
  const ProfileDialog({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          name,
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        height: mq.height,
        width: mq.width,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: mq.height * 0.2,
              ),
              CachedNetworkImage(
                height: mq.height * 0.4,
                width: mq.width,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.lightGreen,
                    child: const Text("")),
                imageUrl: imageUrl,
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),
    );
    // return AlertDialog(
    //   contentPadding: EdgeInsets.zero,
    //   backgroundColor: Colors.white.withOpacity(0.9),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    //   content: SizedBox(
    //     height: mq.height * 0.3,
    //     width: mq.width * 0.6,
    //     child: Stack(children: [
    //       Positioned(
    //         top: mq.height * 0.055,
    //         left: mq.width * 0.09,
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(mq.height * .33),
    //           child: CachedNetworkImage(
    //             height: mq.width * .5,
    //             width: mq.width * .5,
    //             fit: BoxFit.cover,
    //             placeholder: (context, url) => Shimmer.fromColors(
    //                 baseColor: Colors.grey,
    //                 highlightColor: Colors.lightGreen,
    //                 child: const Text("")),
    //             imageUrl: imageUrl,
    //             errorWidget: (context, url, error) =>
    //                 const Icon(CupertinoIcons.person),
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //           top: mq.height * 0.015,
    //           left: mq.width * 0.04,
    //           width: mq.width * 0.5,
    //           child: Text(
    //             name,
    //             style:
    //                 const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    //           )),
    //       Positioned(
    //           top: 1,
    //           right: 1,
    //           child: MaterialButton(
    //             minWidth: 0,
    //             shape: const CircleBorder(),
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             child: const Icon(
    //               Icons.close,
    //               size: 30,
    //             ),
    //           ))
    //     ]),
    //   ),
    // );
  }
}
