import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();

  static final SQLiteDbProvider db = SQLiteDbProvider._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

/*

    {
        "chapter_number": 1,
        "chapter_summary": "\"The first chapter of the Bhagavad Gita - \"Arjuna Vishada Yoga\" introduces the setup, the setting, the characters and the circumstances that led to the epic battle of Mahabharata, fought between the Pandavas and the Kauravas. It outlines the reasons that led to the revelation of the of Bhagavad Gita.\nAs both armies stand ready for the battle, the mighty warrior Arjuna, on observing the warriors on both sides becomes increasingly sad and depressed due to the fear of losing his relatives and friends and the consequent sins attributed to killing his own relatives. So, he surrenders to Lord Krishna, seeking a solution. Thus, follows the wisdom of the Bhagavad Gita.\"",
        "name": "\"अर्जुनविषादयोग\"",
        "name_meaning": "\"Arjuna's Dilemma\"",
        "name_translation": "\"Arjuna Visada Yoga\"",
        "name_transliterated": "\"Arjun Viṣhād Yog\"",
        "verses_count": 47


         {
        "chapter_number": 1,
        "meaning": "Dhritarastra said: O Sanjaya, what did my sons and the sons of Pandu actually do when, eager for battle, they gathered together on the holy field of Kuruksetra?",
        "text": "धृतराष्ट्र उवाच |\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |\nमामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय ॥1॥\n",
        "transliteration": "dhṛitarāśhtra uvācha\ndharma-kṣhetre kuru-kṣhetre samavetā yuyutsavaḥ\nmāmakāḥ pāṇḍavāśhchaiva kimakurvata sañjaya\n",
        "verse_number": "1",
        "word_meanings": "dhṛitarāśhtraḥ uvācha—Dhritarashtra said; dharma-kṣhetre—the land of dharma; kuru-kṣhetre—at Kurukshetra; samavetāḥ—having gathered; yuyutsavaḥ—desiring to fight; māmakāḥ—my sons; pāṇḍavāḥ—the sons of Pandu; cha—and; eva—certainly; kim—what; akurvata—did they do; sañjaya—Sanjay\n"
    },
*/
  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "db_gita");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE tbl_chapter (chapter_number INTEGER PRIMARY KEY, chapter_summary TEXT,name TEXT,name_meaning TEXT, name_translation TEXT, name_transliterated TEXT,verses_count INTEGER)");

        await db.execute(
            "CREATE TABLE tbl_verse (verse_number TEXT, chapter_number INTEGER , meaning TEXT,text TEXT,transliteration TEXT, word_meanings TEXT)");

        print('db created');
      },
    );
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database? dbase = await db.database;
    int result = await dbase!
        .insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<Map<String, dynamic>>> queryAllRow(String table) async {
    Database? dbase = await db.database;
    return await dbase!.query(
      table,
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRowWithId(
      String table, int id) async {
    Database? dbase = await db.database;
    List<Map<String, dynamic>> data =
        await dbase!.query(table, where: 'chapter_number=?', whereArgs: [id]);
    return data;
  }

  Future<List<Map<String, dynamic>>> rawQueryRun(
      String table, String query) async {
    Database? dbase = await db.database;
    return await dbase!.rawQuery(query);
  }

  Future<int> update(String table, Map<String, dynamic> row, int id) async {
    Database? dbase = await db.database;
    return await dbase!.update(table, row, where: 'id=?', whereArgs: [id]);
  }

  Future<int> updateChapter(Map<String, dynamic> row, int id) async {
    Database? dbase = await db.database;
    return await dbase!
        .update('tbl_chapter', row, where: 'chapter_number=?', whereArgs: [id]);
  }
}
