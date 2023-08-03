import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/splash_screen.dart';
// import 'package:flutter_application_1/pages/splash_screen.dart';
import 'package:flutter_application_1/storage/secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class UserName extends StatefulWidget {
  const UserName({super.key});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  String? errorText;

  TextEditingController userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('USERNAME',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  child: TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                    errorText: errorText,
                    errorStyle: const TextStyle(fontSize: 20),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
              )),
              const SizedBox(
                height: 50,
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        if (userNameController.text.isNotEmpty) {
                          SecureStorage().writeData(
                              storageUsername, userNameController.text.trim());
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const HomePage()));
                        } else {
                          setState(() {
                            errorText = "Please enter a username";
                          });
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(color: Colors.green)))),
                      child: const Text(
                        "OK",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
