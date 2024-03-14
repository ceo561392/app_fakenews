import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
    String? text;
    String? sentiment;

    News({
        this.text,
        this.sentiment,
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
        text: json["text"],
        sentiment: json["sentiment"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "sentiment": sentiment,
    };
}