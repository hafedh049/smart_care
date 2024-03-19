import 'package:get/get.dart';
import 'package:smart_care/languages/en.dart';
import 'package:smart_care/languages/fr.dart';

class LanguageTemplateTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{"en_US": english, "fr_FR": french};
}
