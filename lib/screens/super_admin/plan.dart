import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            CustomizedText(text: "Manage Plan".tr, fontSize: 24),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                itemBuilder: (BuildContext context, int index) => Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.1)),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 30),
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[CustomizedText(text: "\$0".tr, fontSize: 25, fontWeight: FontWeight.bold), CustomizedText(text: " / Month".tr, fontSize: 18)]),
                              const SizedBox(height: 20),
                              Center(child: CustomizedText(text: "Duration : UNLIMITED".tr, fontSize: 18)),
                              const SizedBox(height: 30),
                              Center(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: const <String>["5 Users", "5 Customers", "5 Vendors", "5 Clients", "Enable Account", "Enable CRM", "Enable HRM", "Enable Project", "Enable POS"]
                                      .map(
                                        (String e) => Row(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: blue, width: 2)),
                                              child: const Center(child: Icon(FontAwesomeIcons.plus, size: 15)),
                                            ),
                                            const SizedBox(width: 20),
                                            CustomizedText(text: e, fontSize: 14),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                width: 60,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                                child: const Center(child: Icon(FontAwesomeIcons.pen, size: 15, color: white)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 120,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: blue),
                      child: Center(child: CustomizedText(text: "FREE PLAN".tr, fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
