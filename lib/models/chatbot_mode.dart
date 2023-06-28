class Chatbot {
  bool isActive;
  String language;
  List<String> knowledgeBase;
  List<String> userHistory;

  Chatbot({
    required this.isActive,
    required this.language,
    required this.knowledgeBase,
    required this.userHistory,
  });

  factory Chatbot.fromJson(Map<String, dynamic> json) {
    return Chatbot(
      isActive: json['isActive'] as bool,
      language: json['language'] as String,
      knowledgeBase: List<String>.from(json['knowledgeBase']),
      userHistory: List<String>.from(json['userHistory']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'language': language,
      'knowledgeBase': knowledgeBase,
      'userHistory': userHistory,
    };
  }
}
