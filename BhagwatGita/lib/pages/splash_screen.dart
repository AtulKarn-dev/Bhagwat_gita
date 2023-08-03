import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/database/db.dart';
import 'package:flutter_application_1/pages/username.dart';
import 'package:flutter_application_1/responses/auth.dart';
import 'package:flutter_application_1/storage/secure_storage.dart';
import 'dart:math' as math;
import 'dart:async';
import 'home_page.dart';
import 'package:http/http.dart' as http;

String token = '';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  Future<bool> getdata() async {
    if ((await SQLiteDbProvider.db.queryAllRow(tblChapter)).isEmpty) {
      http.Response response = await http
          .post(Uri.parse('https://bhagavadgita.io/auth/oauth/token'), body: {
        'client_id': 'MmApEMWzZSLWcCgS7XSl0Ol2oP8noBR90k15bw8M',
        'client_secret': '6qDR3UXt3UWOPIeK7a1aq2IH0Xsghg2jfOdwRAoCG6u69X8Qbh',
        'grant_type': 'client_credentials',
        'scope': 'verse chapter'
      });
      if (response.statusCode == 200) {
        Token token1 = tokenFromJson(response.body);
        token = token1.accessToken;
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _init().then((v) {
      getdata().then((v) {
        if (v == true) {
          Timer(const Duration(seconds: 1), () async {
            if ((await SecureStorage().readData(storageUsername) ?? "") != "") {
              SecureStorage().readData(storageUsername);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const HomePage()));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const UserName()));
            }
          });
        } else {
          //alert dialog there is some issue
        }
      });
    });
  }

  Future<void> _init() async {
    await SQLiteDbProvider.db.initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Transform.rotate(
            angle: -math.pi / 3.5,
            child: Container(
                height: 400,
                width: 300,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          'assets/images/Gita.png',
                        )))),
          ),
          Transform.translate(
            offset: const Offset(0, -150),
            child: const Text('Bhagawad Gita',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromARGB(255, 236, 148, 16),
                    fontFamily: 'Samarkan Normal',
                    fontSize: 50,
                    height: 1,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 30,
          ),
          CircularProgressIndicator()
        ]),
      ),
    );
  }
}
