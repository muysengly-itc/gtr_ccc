import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_001/barcode_scanner.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform) //
      .then((value) {
        print("Firebase initialized");
      });
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
      home: const ApplicationPage(title: 'Application Form'),
    );
  }
}

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> search_products = [];

  TextEditingController controller_bar_code = TextEditingController();
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_country = TextEditingController();
  TextEditingController controller_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    products.clear();

    await db //
        .collection("collection_product")
        .orderBy("created_at", descending: true)
        .get()
        .then((q) {
          for (var d in q.docs) {
            var data = {
              "id": d.id, //
              "bar_code": d.data().containsKey("bar_code") ? d.get("bar_code") : "", //
              "name": d.data().containsKey("name") ? d.get("name") : "", //
              "country": d.data().containsKey("country") ? d.get("country") : "", //
            };

            products.add(data);
          }
        });

    search();

    setState(() {});
  }

  void search() {
    search_products.clear();
    if (controller_search.text.isEmpty) {
      search_products = List.from(products);
    } else {
      search_products =
          products //
              .where((p) {
                return p["bar_code"].toString().contains(controller_search.text);
              })
              .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, //
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400, //
                  child: TextField(
                    //
                    controller: controller_search,
                    onChanged: (t) {
                      search();
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BarcodeScannerPage();
                            },
                          ),
                        )
                        .then((v) {
                          controller_search.text = v;
                          search();
                          setState(() {});
                        });
                  },
                  icon: Icon(Icons.barcode_reader),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: search_products.length,
                itemBuilder: (context, i) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          width: 160,
                          alignment: Alignment.center,
                          child: OutlinedButton(
                            onPressed: () {
                              //
                              controller_bar_code.text = search_products[i]["bar_code"];
                              showDialog(
                                context: context, //
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Edit Bar Code"), //
                                    content: TextField(controller: controller_bar_code),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () async {
                                          //
                                          var id = search_products[i]["id"];

                                          await db
                                              .collection("collection_product") //
                                              .doc(id)
                                              .update({"bar_code": controller_bar_code.text});

                                          Navigator.pop(context);

                                          init();
                                          setState(() {});
                                        },
                                        child: Text("Save"), //
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(search_products[i]["bar_code"]), //,
                          ),
                        ),

                        Container(
                          width: 160,
                          alignment: Alignment.center,
                          child: OutlinedButton(
                            onPressed: () {
                              //
                              controller_name.text = search_products[i]["name"];
                              showDialog(
                                context: context, //
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Edit Name"), //
                                    content: TextField(controller: controller_name),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () async {
                                          //
                                          var id = search_products[i]["id"];

                                          await db
                                              .collection("collection_product") //
                                              .doc(id)
                                              .update({"name": controller_name.text});

                                          Navigator.pop(context);

                                          init();
                                          setState(() {});
                                        },
                                        child: Text("Save"), //
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(search_products[i]["name"]), //
                          ),
                        ),

                        Container(
                          width: 160,
                          alignment: Alignment.center,
                          child: OutlinedButton(
                            onPressed: () {
                              //
                              controller_country.text = search_products[i]["country"];
                              showDialog(
                                context: context, //
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Edit country"), //
                                    content: TextField(controller: controller_country),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () async {
                                          //
                                          var id = search_products[i]["id"];

                                          await db
                                              .collection("collection_product") //
                                              .doc(id)
                                              .update({"country": controller_country.text});

                                          Navigator.pop(context);

                                          init();
                                          setState(() {});
                                        },
                                        child: Text("Save"), //
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(search_products[i]["country"]), //
                          ),
                        ),

                        // Spacer(),
                        IconButton(
                          onPressed: () async {
                            var id = search_products[i]["id"];

                            await db
                                .collection("collection_product") //
                                .doc(id) //
                                .delete(); //

                            init();
                            setState(() {});
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await db.collection("collection_product").add({
            "created_at": DateTime.now(), //
          });
          init();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
