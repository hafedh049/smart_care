import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModalClass {
  late final String sourceId;
  late final String sourceName;
  late final String author;
  late final String title;
  late final String description;
  late final String url;
  late final String urlToImage;
  late final DateTime publishedAt;
  late final String content;
  late final String topic;
  late final String sourceUrl;

  ArticleModalClass({
    required this.sourceId,
    required this.sourceName,
    required this.sourceUrl,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.topic,
  });

  Map<String, dynamic> toMap() {
    return {
      'source': {
        'id': sourceId,
        'name': sourceName,
      },
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
      'topic': topic,
      'sourceUrl': sourceUrl,
    };
  }

  static ArticleModalClass fromMap(Map<String, dynamic> map) {
    return ArticleModalClass(
      sourceId: map["source"]['id'],
      sourceName: map["source"]['name'],
      sourceUrl: map['sourceUrl'],
      author: map['author'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      urlToImage: map['urlToImage'],
      publishedAt: DateTime.parse(map['publishedAt']),
      content: map['content'],
      topic: map['topic'],
    );
  }

  static Future<List<ArticleModalClass>> fetchArticles() async {
    final articlesSnapshot = await FirebaseFirestore.instance.collection('articles').get();

    return articlesSnapshot.docs.map((doc) => ArticleModalClass.fromMap(doc.data())).toList();
  }

  static Future<void> uploadArticle(ArticleModalClass article) async {
    await FirebaseFirestore.instance.collection('articles').doc().set(article.toMap());
  }
}
