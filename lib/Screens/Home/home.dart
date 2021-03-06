import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:UQS/Miscellaneous/loading.dart';
import 'package:UQS/Models/ticket.dart';
import 'package:UQS/Models/user.dart';
import 'package:UQS/Models/notification.dart';
import 'package:UQS/Screens/Home/customlisttile.dart';
import 'package:UQS/Models/service.dart';
import 'package:UQS/Screens/Home/profilepage.dart';
import 'package:UQS/Screens/Home/serviceList.dart';
import 'package:UQS/Screens/Home/ticketsWrapper.dart';
import 'package:UQS/Screens/Home/userTile.dart';
import 'package:UQS/Services/authservice.dart';
import 'package:UQS/Services/serviceDatabase.dart';
import 'package:UQS/Services/ticketDatabase.dart';
import 'package:UQS/Services/userDatabase.dart';
import 'package:UQS/Services/notificationDatabase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedNaviation = 0;
  final _pageOptions = [
    TicketsDashboard(),
    ServiceList(),
    Profilepage(),
  ];

  

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  //show snackbar method
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _showSnackBar(Map<String, dynamic> message) {
    final snackBar = SnackBar(
      content: Text(
        message['notification']['body'],
        style: TextStyle(fontSize: 15.0),
      ),
      action: SnackBarAction(label: 'Okay', onPressed: () => null),
      duration: new Duration(seconds: 5),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage:  $message");
        _showSnackBar(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch:  $message");
        final snackbar = SnackBar(
          content: Text('Yay! A SnackBar!'),
          action: SnackBarAction(label: 'Okay', onPressed: () => null),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      },
    );

    final User user = Provider.of<User>(context);
    //wrapped the whole scaffold widget with streamprovider to grant the whole widget tree access to the data provided by the stream
    return user != null
        ? MultiProvider(
            providers: [
              StreamProvider<List<Service>>.value(
                  value: ServiceDatabase().service),
              StreamProvider<List<UniversityCategory>>.value(
                  value: ServiceDatabase().universityCategory),
              StreamProvider<List<GovernmentCategory>>.value(
                  value: ServiceDatabase().governmentCategory),
              StreamProvider<List<BillsBanksCategory>>.value(
                  value: ServiceDatabase().billsbanksCategory),
              StreamProvider<List<Ticket>>.value(
                  value:
                      TicketDatabase(ticketOwnerUid: user.uid).activeTickets),
              StreamProvider<List<Done>>.value(
                  value: TicketDatabase(ticketOwnerUid: user.uid).doneTickets),
              StreamProvider<List<Cancelled>>.value(
                  value: TicketDatabase(ticketOwnerUid: user.uid).cancelled),
              StreamProvider<User>.value(
                  value: DatabaseService(uid: user.uid).userData),
              StreamProvider<List<Notif>>.value(
                  value: NotificationDatabase(notifOwnerUid: user.uid)
                      .notification)
            ],
            child: SafeArea(
                child: new Scaffold(
                    key: _scaffoldKey,
                    extendBody: true,
                    resizeToAvoidBottomPadding: true,
                    drawer: Drawer(child: DrawerList()),
                    body: _pageOptions[_selectedNaviation],
                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex: _selectedNaviation,
                      onTap: (int index) {
                        setState(() {
                          _selectedNaviation = index;
                        });
                      },
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), title: Text('Anasayfa')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.work), title: Text('Hizmetler')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.hourglass_full),
                            title: Text('Profil')),
                      ],
                    ))),
          )
        : Loading();
  }
}

class DrawerList extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Colors.lightBlueAccent,
            Colors.lightBlue,
            Colors.blueAccent,
          ])),
          child: UserTile(),
        ),
        CostumListile(Icons.person, 'Profile', () {
          Navigator.popAndPushNamed(context, '/profile');
        }),
        CostumListile(Icons.notifications, 'Notification', () => {}),
        CostumListile(Icons.settings, 'Settings', () => {}),
        CostumListile(Icons.help, 'Help', () => {}),
        CostumListile(Icons.lock, 'Log out', () async {
          //calls sign out function from AuthService()
          await _auth.signOut().then((result) => {Navigator.pop(context)});
        }),
      ],
    );
  }
}

// responsible for sending the device fcm token
_saveDeviceToken() async {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user = await _auth.currentUser();
  final CollectionReference fcmTokensColl =
      Firestore.instance.collection('fcmTokens');

  String fcmToken = await _fcm.getToken();
//düzeltilecek
  if (fcmToken != null) {
    // inject the fcm token to database
    await fcmTokensColl.document(user.uid).setData({
      'userUid': user.uid,
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    });
  }
}
