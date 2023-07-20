import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/chapter_list.dart';
import 'package:flutter_application_1/responses/chapter_response.dart';
import 'package:flutter_application_1/pages/splash_screen.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    late Future<List<Chapters>?> futureChapter;

  Future<List<Chapters>?> getChapter() async {
    http.Response response = await http.get(Uri.parse(
        'https://bhagavadgita.io/api/v1/chapters?access_token=$token'));
    if (response.statusCode == 200) {
      return chaptersFromJson(response.body);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  
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
        )),
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
                                       ChapterList(id:data.chapterNumber.toString())));
                            },
                            leading: Text((index + 1).toString()),
                            title: Text(
                              data.nameMeaning.split("\"")[1],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(children: [
                             const SizedBox(
                                height: 15,
                              ),
                              Text(data.chapterSummary,
                                  maxLines: 3, overflow: TextOverflow.ellipsis),
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


