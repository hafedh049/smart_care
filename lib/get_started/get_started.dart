import 'package:flutter/material.dart';
import 'package:smart_care/get_started/primary_prevention.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/primaly_prevention/doctor.jfif"), fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 170),
              CustomizedText(text: AppLocalizations.of(context)!.virtual, color: blue, fontWeight: FontWeight.bold),
              CustomizedText(text: AppLocalizations.of(context)!.ecosystem, color: darkBlue, fontWeight: FontWeight.bold),
              CustomizedText(text: AppLocalizations.of(context)!.specializedhealthcareonasingletechplatformsimplifyingaccesstoanyoneanywhere, color: black, fontSize: 16),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => PrimaryPrevention()));
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .6,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blue),
                    child: Center(child: CustomizedText(text: AppLocalizations.of(context)!.continue_, color: black, fontWeight: FontWeight.bold, fontSize: 25)),
                  ),
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
