import 'package:get/get.dart';
import 'package:smart_care/languages/de.dart';
import 'package:smart_care/languages/en.dart';
import 'package:smart_care/languages/fr.dart';

class LanguageTemplateTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {"en_US": english, "fr_FR": french, "de_DE": german};
}
