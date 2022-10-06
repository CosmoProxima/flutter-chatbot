import 'package:bubble/bubble.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Asist extends StatefulWidget {
  const Asist({Key? key}) : super(key: key);

  @override
  _AsistState createState() => _AsistState();
}

class _AsistState extends State<Asist> {
  FirebaseAuth? auth;
  User? user;
  String? subscriptionPlanPrice, userId, documentId;
  bool? isSubscribe;

  void response(messageInsert) async {
    DialogAuthCredentials dialogAuthCredentials =
        await DialogAuthCredentials.fromFile('assets/services.json');

    final DialogFlowtter dialogFlowtter =
        DialogFlowtter(credentials: dialogAuthCredentials, sessionId: '12345');

    final QueryInput queryInput = QueryInput(
      text: TextInput(
        text: messageInsert,
        languageCode: 'en',
      ),
    );

    final params = QueryParameters(
      contexts: [
        Context(
            name:
                'projects/{project_id=}/locations/{project_id=}/agent/environments/{environment_id=}/users/{user_id=}/sessions/{session_id=}/contexts/start',
            lifespanCount: 10),
      ],
    );

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: queryInput,
    );
    print(response.message?.text?.text?[0]);
    setState(() {
      messsages
          .insert(0, {"data": 0, "message": response.message?.text?.text?[0]});
    });
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                  child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38),
                    topRight: Radius.circular(38),
                    bottomLeft: Radius.circular(38),
                    bottomRight: Radius.circular(38),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(238, 195, 54, 1),
                      Color.fromRGBO(238, 195, 54, 0)
                    ],
                  ),
                ),
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"])),
              )),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                height: 5.0,
                color: Colors.greenAccent,
              ),
              Container(
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color.fromRGBO(220, 220, 220, 1),
                          ),
                          padding: const EdgeInsets.only(left: 15),
                          child: Center(
                            child: TextFormField(
                              controller: messageInsert,
                              decoration: const InputDecoration(
                                hintText: "Enter a Message...",
                                hintStyle: TextStyle(color: Colors.black26),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                      icon: const Icon(
                        Icons.send,
                        size: 30.0,
                        color: Colors.greenAccent,
                      ),
                      onPressed: () {
                        if (messageInsert.text.isEmpty) {
                          print("empty message");
                        } else {
                          setState(() {
                            messsages.insert(
                                0, {"data": 1, "message": messageInsert.text});
                          });
                          response(messageInsert.text);
                          messageInsert.clear();
                        }
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      }),
                ),
              ),
              const SizedBox(
                height: 15.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget chat(String message, int data) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 60,
                  width: 60,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("images/robot.jpg"),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Bubble(
                radius: const Radius.circular(15.0),
                color: data == 0
                    ? const Color.fromRGBO(23, 157, 139, 1)
                    : Colors.orangeAccent,
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                          child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          message,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          data == 1
              ? Container(
                  height: 60,
                  width: 60,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("images/default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
