import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Register());
}

class Register extends StatelessWidget {
  const Register({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RegisterPage(title: 'Resgister Form'),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool is_password_visible = false;
  bool is_verify_password_visible = false;

  String username = "";
  String password = "";
  String verify_password = "";

  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();
  TextEditingController controller_verify_password = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            //
            Row(
              children: [
                Spacer(),
                Container(
                  width: 120, //
                  alignment: Alignment.centerRight,
                  child: Text("Username: "),
                ),

                SizedBox(
                  width: 300,
                  child: TextField(
                    //
                    controller: controller_username,
                  ),
                ),
                Spacer(),
              ],
            ),

            Row(
              children: [
                Spacer(),
                Container(
                  width: 120, //
                  alignment: Alignment.centerRight,
                  child: Text("Password: "),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    //
                    controller: controller_password,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          //
                          is_password_visible = !is_password_visible;
                          setState(() {});
                        },
                        icon: is_password_visible ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                      ),
                    ),
                    obscureText: !is_password_visible,
                  ),
                ),
                Spacer(),
              ],
            ),

            Row(
              children: [
                Spacer(),
                Container(
                  width: 120, //
                  alignment: Alignment.centerRight,
                  child: Text("Verify Password: "),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    //
                    controller: controller_verify_password,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          //
                          is_verify_password_visible = !is_verify_password_visible;
                          setState(() {});
                        },
                        icon: is_verify_password_visible ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                      ),
                    ),
                    obscureText: !is_verify_password_visible,
                  ),
                ),
                Spacer(),
              ],
            ),

            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                //

                username = controller_username.text;
                password = controller_password.text;
                verify_password = controller_verify_password.text;

                if (username.length < 5) {
                  print("username shorter than 5");
                  return;
                }

                if (verify_password != password) {
                  print("verify password incorrect.");
                  return;
                }

                db
                    .collection("collection_credential") //
                    .add({
                      "username": username, //
                      "password": password, //
                    });
                print("register success.");
                //
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
