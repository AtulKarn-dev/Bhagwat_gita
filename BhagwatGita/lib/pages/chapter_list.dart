import 'package:flutter/material.dart';
import 'package:flutter_application_1/responses/chapter_verse_response.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../database/db.dart';
import 'splash_screen.dart';

class ChapterList extends StatefulWidget {
  final String id;

  const ChapterList({super.key, required this.id});

  @override
  State<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  Future<List<ChapterVerse>?> getChapterVerse() async {
    print('from db');
    // if ((await SQLiteDbProvider.db.queryAllRow(tblVerse)).isNotEmpty) {
    List<Map<String, dynamic>> chapterMapList = await SQLiteDbProvider.db
        .queryAllRowWithId(tblVerse, int.parse(widget.id));

    List<ChapterVerse> chapterVerse = [];
    for (Map<String, dynamic> verse in chapterMapList) {
      chapterVerse.add(ChapterVerse.fromJson(verse));
      print(ChapterVerse.fromJson(verse).chapterNumber);
    }
    return chapterVerse;
    // } else {
    //   http.Response response = await http.get(Uri.parse(
    //       'https://bhagavadgita.io/api/v1/chapters/${widget.id}/verses?access_token=$token'));
    //   if (response.statusCode == 200) {
    //     List<ChapterVerse> chapterVerse = chapterVerseFromJson(response.body);

    //     for (ChapterVerse verse in chapterVerse) {
    //       SQLiteDbProvider.db.insert(tblVerse, verse.toJson());
    //     }
    //     return chapterVerse;
    //   } else {
    //     return null;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Chapter ${widget.id}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: FutureBuilder<List<ChapterVerse>?>(
          future: getChapterVerse(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      ChapterVerse data = snapshot.data![index];
                      return Card(
                          child: ListTile(
                        title: Center(
                            child: Text(
                          'Verse: ${data.verseNumber}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16),
                        )),
                        subtitle: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              data.meaning,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 227, 153, 41)),
                            ),
                            Text(
                              data.transliteration,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.wordMeanings,
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ));
                    }),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    ));
  }
}
