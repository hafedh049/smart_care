import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../stuff/classes.dart';
import '../../stuff/functions.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 30),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 12, backgroundColor: blue), SizedBox(width: 50)]),
            Row(children: const <Widget>[Spacer(), CircleAvatar(radius: 4, backgroundColor: blue), SizedBox(width: 30)]),
            const SizedBox(height: 20),
            CustomizedText(text: AppLocalizations.of(context)!.dashboard, fontSize: 35, fontWeight: FontWeight.bold, color: white),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                children: adminCards(context)
                    .map(
                      (Map<String, dynamic> card) => GestureDetector(
                        onTap: () async {
                          goTo(card["widget"]);
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: card["color"]),
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(height: 100, width: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkBlue)),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CustomizedText(text: card["name"], color: darkBlue, fontSize: 22, fontWeight: FontWeight.bold),
                                      const SizedBox(height: 10),
                                      Icon(card["icon"], size: 25, color: darkBlue),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 100, width: 5, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkBlue)),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) => AnimatedContainer(duration: 700.ms, height: MediaQuery.of(context).padding.bottom > 0 ? 40 : 20)),
          ],
        ),
      ),
    );
  }
}
