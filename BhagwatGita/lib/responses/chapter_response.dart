// To parse this JSON data, do
//
//     final chapters = chaptersFromJson(jsonString);

import 'dart:convert';

List<Chapters> chaptersFromJson(String str) => List<Chapters>.from(json.decode(str).map((x) => Chapters.fromJson(x)));

String chaptersToJson(List<Chapters> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chapters {
    int chapterNumber;
    String chapterSummary;
    String name;
    String nameMeaning;
    String nameTranslation;
    String nameTransliterated;
    int versesCount;

    Chapters({
        required this.chapterNumber,
        required this.chapterSummary,
        required this.name,
        required this.nameMeaning,
        required this.nameTranslation,
        required this.nameTransliterated,
        required this.versesCount,
    });

    factory Chapters.fromJson(Map<String, dynamic> json) => Chapters(
        chapterNumber: json["chapter_number"],
        chapterSummary: json["chapter_summary"],
        name: json["name"],
        nameMeaning: json["name_meaning"],
        nameTranslation: json["name_translation"],
        nameTransliterated: json["name_transliterated"],
        versesCount: json["verses_count"],
    );

    Map<String, dynamic> toJson() => {
        "chapter_number": chapterNumber,
        "chapter_summary": chapterSummary,
        "name": name,
        "name_meaning": nameMeaning,
        "name_translation": nameTranslation,
        "name_transliterated": nameTransliterated,
        "verses_count": versesCount,
    };
}
