import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_care/get_started/primary_prevention.dart';
import 'package:smart_care/utils/classes.dart';
import 'package:smart_care/utils/globals.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/primaly_preventions/doctor.jfif"), fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 170),
              CustomizedText(text: 'virtual'.tr, fontWeight: FontWeight.bold),
              CustomizedText(text: 'ecosystem'.tr, fontWeight: FontWeight.bold),
              CustomizedText(text: 'specializedhealthcareonasingletechplatformsimplifyingaccesstoanyoneanywhere'.tr, fontSize: 16),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PrimaryPrevention())),
                  child: Container(height: 60, width: MediaQuery.of(context).size.width * .6, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue), child: Center(child: CustomizedText(text: 'continue_'.tr, fontWeight: FontWeight.bold, fontSize: 25))),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
