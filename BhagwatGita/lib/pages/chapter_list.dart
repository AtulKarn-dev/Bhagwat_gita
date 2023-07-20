import 'package:flutter/material.dart';
import 'package:flutter_application_1/responses/chapter_verse_response.dart';
import 'package:http/http.dart' as http;
import 'splash_screen.dart';

class ChapterList extends StatefulWidget {
  final String id;

  const ChapterList({super.key, required this.id});

  @override
  State<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  Future<List<ChapterVerse>?> getChapterVerse() async {
    http.Response response = await http.get(Uri.parse(
        'https://bhagavadgita.io/api/v1/chapters/${widget.id}/verses?access_token=$token'));
    if (response.statusCode == 200) {
      return chapterVerseFromJson(response.body);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

                // Text('Chapter: ${snapshot.data![1].chapterNumber}',
                //     style: const TextStyle(
                //         fontWeight: FontWeight.bold, fontSize: 22)),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16),
                        )),
                        subtitle: Column(
                          children: [
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Text(
                            //   'Verse: ${data.verseNumber}',
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w800, fontSize: 16),
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              data.meaning,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 227, 153, 41)),
                            ),
                            Text(
                              data.transliteration.replaceAll('\n', ''),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
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
