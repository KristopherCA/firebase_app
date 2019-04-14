import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'board.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Board',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Board> boardMessages = List();
  Board board;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyAlert = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();

    board = Board("", "");
    databaseReference = database.reference().child('Community Board');
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Community Board'),
          centerTitle: true,
          backgroundColor: Colors.red.shade800,
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 0,
              child: Center(
                  child: Form(
                      key: formKey,
                      child: Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.subject,
                              color: Colors.black,
                            ),
                            title: TextFormField(
                              initialValue: "",
                              onSaved: (val) => board.subject = val,
                              validator: (val) => val == "" ? val : null,
                              decoration: InputDecoration(labelText: 'Subject'),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.message,
                              color: Colors.black,
                            ),
                            title: TextFormField(
                              initialValue: "",
                              onSaved: (val) => board.body = val,
                              validator: (val) => val == "" ? val : null,
                              decoration: InputDecoration(labelText: 'Body'),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              handleSubmit();
                            },
                            child: Text(
                              'Post',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.red.shade800,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          )
                        ],
                      ))),
            ),
            Flexible(
                child: FirebaseAnimatedList(
                    query: databaseReference,
                    itemBuilder: (_, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showAlertMessage(
                                    context,
                                    Container(
                                      constraints: BoxConstraints(
                                          maxHeight: 300.0,
                                          maxWidth: 300.0,
                                          minWidth: 200.0,
                                          minHeight: 100.0),
                                      child: ListView(
                                        padding: EdgeInsets.all(2.0),
                                        children: <Widget>[
                                          Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Flexible(
                                                    flex: 0,
                                                    child: Center(
                                                        child: Form(
                                                      key: formKeyAlert,
                                                      child: Flex(
                                                        direction:
                                                            Axis.vertical,
                                                        children: <Widget>[
                                                          ListTile(
                                                            leading: Icon(
                                                              Icons.subject,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            title:
                                                                TextFormField(
                                                              initialValue: "",
                                                              onSaved: (valalert) =>
                                                                  board.subject =
                                                                      valalert,
                                                              validator: (valalert) =>
                                                                  valalert == ""
                                                                      ? valalert
                                                                      : null,
                                                              decoration:
                                                                  InputDecoration(
                                                                      labelText:
                                                                          'Subject'),
                                                            ),
                                                          ),
                                                          ListTile(
                                                            leading: Icon(
                                                              Icons.message,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            title:
                                                                TextFormField(
                                                              initialValue: "",
                                                              onSaved: (valalert) =>
                                                                  board.body =
                                                                      valalert,
                                                              validator: (valalert) =>
                                                                  valalert == ""
                                                                      ? valalert
                                                                      : null,
                                                              decoration:
                                                                  InputDecoration(
                                                                      labelText:
                                                                          'Body'),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20.0,
                                                                    bottom:
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: <
                                                                  Widget>[
                                                                FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    handleUpdate(
                                                                        boardMessages[index]
                                                                            .key);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Update',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  color: Colors
                                                                      .red
                                                                      .shade800,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0)),
                                                                ),
                                                                FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  color: Colors
                                                                      .red
                                                                      .shade800,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0)),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )))
                                              ]),
                                        ],
                                      ),
                                    ),
                                    index);
                              }),
                          trailing: Listener(
                            key: Key(boardMessages[index].key),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPointerDown: (pointerEvent) =>
                                handleRemove(boardMessages[index].key),
                          ),
                          title: Text(boardMessages[index].subject),
                          subtitle: Text(boardMessages[index].body),
                        ),
                      );
                    }))
          ],
        ));
  }

  void _onEntryAdded(Event event) {
    setState(() {
      //read from firebase
      boardMessages.add(Board.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      FocusScope.of(context).requestFocus(FocusNode());
      //save to firebase
      databaseReference.push().set(board.toJson());
      setState(() {});
    }
  }

  void _onEntryChanged(Event event) {
    var oldEntry = boardMessages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      boardMessages[boardMessages.indexOf(oldEntry)] =
          Board.fromSnapshot(event.snapshot);
    });
  }

  dynamic showAlertMessage<edit>(
      BuildContext context, Container list, int index) {
    var edit = AlertDialog(
      title: Text('Edit'),
      content: list,
    );
    showDialog(context: context, builder: (context) => edit);
  }

  void handleRemove(String key) {
    //delete from firebase
    databaseReference.child(key).remove();
    setState(() {});
  }

  void handleUpdate(String key) {
    final FormState form = formKeyAlert.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      //update firebase
      databaseReference.child(key).set(board.toJson());
      setState(() {});
    }
  }
}
