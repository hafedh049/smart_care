import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_care/authentification/sign_in.dart';
import 'package:smart_care/error/error_room.dart';
import 'package:smart_care/screens/screens.dart';
import 'package:smart_care/stuff/classes.dart';
import 'package:smart_care/stuff/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChoicesBox extends StatelessWidget {
  const ChoicesBox({super.key});

  @override
  Widget build(BuildContext context) {
    //FutureBuilder howa widget t5alik testana data mte3k lin tji de n'importe quel source (API,...)
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      //yilzm ta3teha el future eli bch tistaneh, future houwa 3ibara 3la traitement ya5edh wa9t bch ya7dher (async -> await)
      //lahne el future mte3i howa eni njib les roles ta3 el user ml firestore
      future: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
      //builder howa el fonction eli tebninili el widget eli nheb aleha 7asb el state ta3 el future(error,completed,waiting)
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        //snapshot howa el variable eli ya7tawi 3al state ta3 el stream/future w ya7tawi 3al data wl error
        if (snapshot.hasData) {
          //hedhi list des roles (String)
          final List<dynamic> roles = snapshot.data!.get("roles_list");
          //ken el list feha role we7ed ma8ir maydhaherlou el pick up box direct y3adih sinin ya5tar e role mte3ou
          if (roles.length == 1) {
            //screen hia el menu principale eli fih el home,chat,dashboard,workflow,....
            return const Screens(firstScreen: 0);
          } else {
            //lahne sna3t list of bools 3la gid list des roles bch naaml traitement 3al state mta3 checkboxes yaani checked wale
            final List<bool> rolesList = List.generate(roles.length, (int index) => false);
            //ignoring: hedhi 3maltha bch ken user tap mara wa7da 3la ay role maach ynajm ytapi cbon 5tare selecta ka3ba
            bool ignore = false;
            return Scaffold(
              backgroundColor: darkBlue,
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: grey.withOpacity(.2)),
                    //statefulbuilder y5alik ta3ml setstate l subtree mou3ayna fl widget tree mte3k ya3ni partie mou3ayna
                    child: StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setS) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //hedhi widget ta3 text sna3tha na fl functions.dart file ya3ni custom text
                            CustomizedText(text: AppLocalizations.of(context)!.continueAs /*Applocalizations hedhi mas2oula 3al langue,ya3ni kol kilma 3andha key mte3ha 7asb system language*/, fontSize: 25, color: blue, fontWeight: FontWeight.bold),
                            const SizedBox(height: 10),
                            //fi 3odh manab9a n7ot kol checkbox wa7adha 3malt for loop bch na9s ml code mte3i
                            for (int role = 0; role < roles.length; role++)
                              IgnorePointer(
                                ignoring: ignore,
                                child: CheckboxListTile(
                                  checkColor: darkBlue,
                                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  title: CustomizedText(text: roles[role][0].toUpperCase() + roles[role].substring(1), fontSize: 16, color: white),
                                  value: rolesList[role],
                                  onChanged: (bool? value) async {
                                    //lahne bch na3ml mise à jour bch yben lil user eli houwa checka role ml roles
                                    setS(() {
                                      rolesList[role] = value!;
                                      ignore = true;
                                    });
                                    //na fl firestore 3andi list des roles w 3andi current_role lina maw el user 5tar role bch n7ot el current role lil role eli 5tarou
                                    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"role": roles[role]}).then(
                                      (void value) async {
                                        //ba3ed net3ada lil screens mte3i
                                        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Screens(firstScreen: 0)));
                                      },
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const SignIn())),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(5)),
                                child: const Icon(FontAwesomeIcons.chevronLeft, color: white, size: 25),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //fi 7alet future mizel makmelch n7otou loading indicator
          return const Center(child: CircularProgressIndicator(color: blue));
        } else {
          //fi 7alet sar error naffichouh fi page wa7dou
          return ErrorRoom(error: snapshot.error.toString());
        }
      },
    );
  }
}
