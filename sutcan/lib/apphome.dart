import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sutcan/home.dart';

class AppHome extends StatefulWidget {
  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  String emailLogin = 'TEST';
  String name = 'TEST';
  String uids = '';
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  //Explicit

  // Method
  Widget showEmailLogin() {
    return Text(
      '$emailLogin',
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );
  }

  Widget showHeader() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          showEmailLogin(),
        ],
      ),
      decoration: BoxDecoration(color: Colors.orange),
    );
  }

  Widget showDrawer() {
    return Drawer(
      
      child: ListView(
        children: <Widget>[
          showHeader(),
          Center(
              child: Text('$name',
                  style: TextStyle(fontSize: 20.0, color: Colors.black)))
        ],
      ),
    );
  }

  Future<void> findDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {
      emailLogin = firebaseUser.email;
      uids = firebaseUser.uid;
    });
    return emailLogin;
  }

  List<myData> allData = [];
  @override
  void initState() {
    findDisplayName();
    getdata();
    //   DatabaseReference ref = FirebaseDatabase.instance.reference();
    //   ref.child('Users').once().then((DataSnapshot snap) {
    //     var keys = snap.value.uids;
    //     var data = snap.value;
    //     allData.clear();
    // for(var key in keys){
    //   myData d = new myData(
    //     data[key]['Email'],
    //     data[key]['Name'],
    //   );
    //   allData.add(d);
    // }
    //   });
    super.initState();
  }

  void getdata() async {
    DatabaseReference databaseReference =
        firebaseDatabase.reference().child('Users');
    await databaseReference.once().then((DataSnapshot dataSnapshot) {
      // print('Data ==> ${datasnapshot.value}');
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        if (key == uids) {
          print(values['Email']);
          setState(() {
            name = values['Name'];
          });
          print(values['Name']);
        }

        // print(values['Name']);
      });
    });
  }

  Widget signOutBt() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Sign Up',
      onPressed: () {
        myAlert();
      },
    );
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Are You Sure'),
              content: Text('Do You Want Sign Out'),
              actions: <Widget>[
                cancleButton(),
                okButton(),
              ]);
        });
  }

  Widget okButton() {
    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
        processSignout();
      },
    );
  }

  Future<void> processSignout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  Widget cancleButton() {
    return FlatButton(
      child: Text('Cancle'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('AppHome'),
        actions: <Widget>[signOutBt()],
      ),
      drawer: showDrawer(),
      
      drawerScrimColor: Colors.white30,
     body: ListView(
        children: <Widget>[
          Center(
           // child: loader(),
          )
        ],
      ),
    );
    
  }
}

class myData {
  myData(data, data2);
}
