import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'application.dart';
import 'register.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const MyHomePage(title: 'Login Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool is_password_visible = false;

  FirebaseFirestore db = FirebaseFirestore.instance;

  String username = "";
  String password = "";

  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // create collection
    // db.collection("collection_test").doc("init").set();

    // delete collection
    // db.collection("collection_test").doc("init").delete();

    // init collection
    // db.collection("collection_credential").doc("init").set({});

    // add document
    // db.collection("collection_credential").add({
    //   "username": "admin",
    //   "password": "admin", //
    // });

    // db.collection("collection_credential").add({
    //   "username": "user",
    //   "password": "user", //
    // });

    // read document
    // db.collection("collection_credential").get().then((q) {
    //   for (var doc in q.docs) {
    //     print(doc.data());
    //   }
    // });

    // search
    // db
    //     .collection("collection_credential") //
    //     .where("username", isEqualTo: "user") //
    //     .get() //
    //     .then((q) {
    //       for (var doc in q.docs) {
    //         print(doc.data());
    //       }
    //     });

    // delete
    // db
    //     .collection("collection_credential") //
    //     .where("username", isEqualTo: "for_delete") //
    //     .get() //
    //     .then((q) {
    //       for (var doc in q.docs) {
    //         doc.reference.delete();
    //       }
    //     });

    // update
    // db
    //     .collection("collection_credential") //
    //     .where("username", isEqualTo: "user") //
    //     .get() //
    //     .then((q) {
    //       for (var doc in q.docs) {
    //         doc.reference.update({
    //           "username": "user_updated", //
    //           "password": "user_updated", //
    //         });
    //       }
    //     });
  }

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
                Text("Username: "),
                SizedBox(width: 300, child: TextField(controller: controller_username)),
                Spacer(),
              ],
            ),

            Row(
              children: [
                Spacer(),
                Text("Password: "),
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
                      ), //
                    ),
                    obscureText: !is_password_visible,
                  ),
                ),
                Spacer(),
              ],
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    username = controller_username.text;
                    password = controller_password.text;

                    db
                        .collection("collection_credential") //
                        .where("username", isEqualTo: username) //
                        .where("password", isEqualTo: password) //
                        .get() //
                        .then((q) {
                          if (q.docs.isEmpty) {
                            print("login failed.");
                          } else {
                            print("login success.");
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ApplicationPage(title: "Application Form"), //
                              ),
                            );
                          }
                        });

                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => ApplicationPage(title: "Application Form"), //
                    //   ),
                    // );
                  },
                  child: Text("Login"),
                ),
                SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    //
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(title: "Register Form"), //
                      ),
                    );
                  },
                  child: Text("Register"),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
