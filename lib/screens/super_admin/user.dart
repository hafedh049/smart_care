import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/globals.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            CustomizedText(text: "Manage User".tr, fontSize: 24),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                itemBuilder: (BuildContext context, int index) => Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.1)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 120,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                            child: Center(child: CustomizedText(text: "Company".tr, fontSize: 18)),
                          ),
                          const Spacer(),
                          const Icon(FontAwesomeIcons.ellipsisVertical, size: 15),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Center(child: CircleAvatar(radius: 50, backgroundImage: CachedNetworkImageProvider(avuRL))),
                      const SizedBox(height: 20),
                      Center(child: CustomizedText(text: "Admin".tr, fontSize: 24, color: blue, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Center(child: CustomizedText(text: "hafedhgunichi@gmail.com".tr, fontSize: 16, color: blue)),
                      const SizedBox(height: 20),
                      Center(child: CustomizedText(text: DateTime.now().toString().split(".")[0], fontSize: 18)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          CustomizedText(text: "Free Plan".tr, fontSize: 18, fontWeight: FontWeight.bold),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 2, color: blue)),
                            child: CustomizedText(text: "Upgrade Plan".tr, fontSize: 16, color: blue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1, thickness: 1, indent: 5, endIndent: 5, color: grey),
                      const SizedBox(height: 20),
                      CustomizedText(text: "Plan Expired : UNLIMITED".tr, fontSize: 18, fontWeight: FontWeight.bold),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: grey.withOpacity(.6)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.users, size: 15),
                                SizedBox(width: 10),
                                CustomizedText(text: "1", fontSize: 14),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.users, size: 15),
                                SizedBox(width: 10),
                                CustomizedText(text: "0", fontSize: 14),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.users, size: 15),
                                SizedBox(width: 10),
                                CustomizedText(text: "0", fontSize: 14),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
