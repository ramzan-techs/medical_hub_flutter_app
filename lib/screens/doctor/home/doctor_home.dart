import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_hub/api/doctor_apis.dart';
import 'package:medical_hub/constants.dart';

import 'package:medical_hub/main.dart';
import 'package:medical_hub/widgets/animated_text_and_method.dart';
import 'package:shimmer/shimmer.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DoctorApis.getSelfInfo(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: buildShimmer());

            //if all or some data is loaded show it
            case ConnectionState.active:
            case ConnectionState.done:
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Constants().secondaryColor,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: mq.width * 0.6,
                                child: Text(
                                  "Hello Dr.${DoctorApis.self.name}",
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                              const Text(
                                "Hava a good day!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * .33),
                            child: CachedNetworkImage(
                              height: mq.width * .16,
                              width: mq.width * .16,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const Icon(Icons.person),
                              imageUrl: DoctorApis.self.profileImageUrl,
                              errorWidget: (context, url, error) =>
                                  const Icon(CupertinoIcons.person),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const MethodWidget(),
                  const SizedBox(
                    height: 40,
                  ),
                  if (!DoctorApis.self.isUpdated)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red.withOpacity(.3),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Please update your profile e.g city, \naddress, phone no and bio etc for better\nclient experience",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  if (DoctorApis.self.isUpdated)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.withOpacity(.3),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Profile updated successfully, Thank you",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (DoctorApis.self.isUpdated && !DoctorApis.self.isReviewed)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red.withOpacity(.3),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Your profile is under review, its status\n will be updated within two days!",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  if (DoctorApis.self.isUpdated &&
                      DoctorApis.self.isReviewed & DoctorApis.self.isApproved)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.withOpacity(.3),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Your profile has been approved, you \n are live now. Thank you!",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  if (DoctorApis.self.isUpdated &&
                      DoctorApis.self.isReviewed &&
                      !DoctorApis.self.isApproved)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red.withOpacity(.3),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Your profile has been rejected, please\n update your profile again",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                ],
              );
          }
        });
  }

  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 100.0,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
