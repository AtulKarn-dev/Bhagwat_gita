// To parse this JSON data, do
//
//     final chapter1Verse = chapter1VerseFromJson(jsonString);

import 'dart:convert';

List<ChapterVerse> chapterVerseFromJson(String str) => List<ChapterVerse>.from(json.decode(str).map((x) => ChapterVerse.fromJson(x)));

String chapterVerseToJson(List<ChapterVerse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChapterVerse {
    int chapterNumber;
    String meaning;
    String text;
    String transliteration;
    String verseNumber;
    String wordMeanings;

    ChapterVerse({
        required this.chapterNumber,
        required this.meaning,
        required this.text,
        required this.transliteration,
        required this.verseNumber,
        required this.wordMeanings,
    });

    factory ChapterVerse.fromJson(Map<String, dynamic> json) => ChapterVerse(
        chapterNumber: json["chapter_number"],
        meaning: json["meaning"],
        text: json["text"],
        transliteration: json["transliteration"],
        verseNumber: json["verse_number"],
        wordMeanings: json["word_meanings"],
    );

    Map<String, dynamic> toJson() => {
        "chapter_number": chapterNumber,
        "meaning": meaning,
        "text": text,
        "transliteration": transliteration,
        "verse_number": verseNumber,
        "word_meanings": wordMeanings,
    };
}



