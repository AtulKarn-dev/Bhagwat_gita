import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/database/db.dart';
import 'package:flutter_application_1/pages/chapter_list.dart';
import 'package:flutter_application_1/pages/username.dart';
import 'package:flutter_application_1/responses/chapter_response.dart';
import 'package:flutter_application_1/pages/splash_screen.dart';
import 'package:flutter_application_1/responses/chapter_verse_response.dart';
import 'package:flutter_application_1/storage/secure_storage.dart';
import 'package:flutter_application_1/widget/show_more.dart';
import 'package:http/http.dart' as http;

import '../database/db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Chapters>?> futureChapter;

  Future<List<Chapters>?> getChapter() async {
    //if db ma data cha vane web bata taanne code chahiyena tyo case ma hami db batai taanchaun
    if ((await SQLiteDbProvider.db.queryAllRow(tblChapter)).isNotEmpty) {
      print('from db');
      List<Map<String, dynamic>> chapterMapList = await SQLiteDbProvider.db
          .queryAllRow(tblChapter); // gets data from local database (sqflite)

      List<Chapters> chapters = [];
      for (Map<String, dynamic> chapter in chapterMapList) {
        chapters.add(Chapters.fromJson(chapter));
      }
      return chapters;
    } else {
      //if not found in local database
      print('from web');
      http.Response response =
          await http.get(Uri.parse(//gets data from api(web)
              'https://bhagavadgita.io/api/v1/chapters?access_token=$token'));
      if (response.statusCode == 200) {
        //db ma store garnu paryo

        List<Chapters> chapters = chaptersFromJson(response.body);

        for (Chapters chapter in chapters) {
          //stores in local database(sqflite)
          SQLiteDbProvider.db.insert(tblChapter, chapter.toJson());

          http.Response responseO = await http.get(Uri.parse(
              'https://bhagavadgita.io/api/v1/chapters/${chapter.chapterNumber}/verses?access_token=$token'));
          if (responseO.statusCode == 200) {
            List<ChapterVerse> chapterVerse =
                chapterVerseFromJson(responseO.body);

            for (ChapterVerse verse in chapterVerse) {
              SQLiteDbProvider.db.insert(tblVerse, verse.toJson());
            }
          }
        }
        return chapters;
      } else {
        return null;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SecureStorage().readData(storageUsername).then((v) {
      setState(() {
        print(v);
      });
    });
    futureChapter = getChapter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Bhagawad Gita',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            InkWell(
                onTap: () {
                  print(1);
                  SecureStorage().deleteData(storageUsername);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => UserName()));
                },
                child: Text('     '))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: FutureBuilder<List<Chapters>?>(
              future: futureChapter,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        Chapters data = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ChapterList(
                                          id: data.chapterNumber.toString())));
                            },
                            leading: Text((index + 1).toString()),
                            title: Text(
                              data.nameMeaning.replaceAll('"', ''),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(children: [
                              const SizedBox(
                                height: 15,
                              ),
                              DescriptionTextWidget(
                                text: data.chapterSummary,
                              ),
                            ]),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        );
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }
}
