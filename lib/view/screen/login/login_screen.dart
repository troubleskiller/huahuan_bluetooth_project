import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/view/screen/main_screen.dart';

TextEditingController userEdit = TextEditingController();
TextEditingController passwordEdit = TextEditingController();

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people),
              const SizedBox(
                width: 2,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: userEdit,
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.password),
            const SizedBox(
              width: 2,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: passwordEdit,
                obscureText: true,
                keyboardType: TextInputType.text,
              ),
            ),
          ]),
          ElevatedButton(
            onPressed: () {
              if (userEdit.text == "admin" && passwordEdit.text == "123456") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen()));
              } else if (userEdit.text == "user" &&
                  passwordEdit.text == "123456") {
                ///todo function to detect if it's admin account
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen()));
              }
            },
            child: const Text("login"),
          ),
        ],
      ),
    );
  }
}
