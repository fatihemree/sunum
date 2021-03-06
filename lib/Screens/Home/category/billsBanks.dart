import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:UQS/Models/service.dart';
import 'package:UQS/Screens/Home/viewService.dart';
import 'package:UQS/Services/serviceDatabase.dart';
import 'package:logger/logger.dart';
class BillsBanks extends StatefulWidget {
  @override
  _BillsBanksState createState() => _BillsBanksState();
}

class _BillsBanksState extends State<BillsBanks> {
  final String categoryName = "banks";
  @override
  Widget build(BuildContext context) {
    print('bills');
    final service1 = Provider.of<List<BillsBanksCategory>>(context) ?? [];
    //service1.removeAt(1);
    return Container(
      height: 600,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage('assets/hastane.jpg'), fit: BoxFit.cover)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                    Colors.black.withOpacity(.4),
                    Colors.black.withOpacity(.2),
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Hastaneler",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: GridView.builder(
                  physics: ScrollPhysics(),
                  itemCount: service1.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return StreamProvider<List<BillsBanksCategory>>.value(
                      value: ServiceDatabase().billsbanksCategory,
                      child: BillsBanksTile(service: service1[index]),
                    );
                  }))
        ],
      ),
    );
  }
}

class BillsBanksTile extends StatelessWidget {
  final BillsBanksCategory service;
  BillsBanksTile({this.service, int index});

  //show snackbar method
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _showSnackBar() {
    final snackBar = SnackBar(
      content: Text(
        'Ticket created succesfully',
        style: TextStyle(fontSize: 15.0),
      ),
      duration: new Duration(seconds: 5),
      backgroundColor: Colors.green,
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return service != null
        ? Padding(
            padding: EdgeInsets.all(0),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(16, 127, 246, 1),
                        Color.fromRGBO(16, 127, 246, 1),
                      ])),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Transform.translate(
                      offset: Offset(0, -0),
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewService(
                                  displayName: service.displayName,
                                  abbreviation: service.abbreviation,
                                  email: service.email,
                                  phoneNumber: service.phoneNumber,
                                  photoUrl: service.photoUrl,
                                  address: service.address,
                                  categoryIndex: service.categoryIndex,
                                  ticketCount: service.ticketCount,
                                   ticketCountDone: service.ticketCountDone,
                                  uid: service.uid)));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 45, vertical: 40),
                          child: CachedNetworkImage(
                            imageUrl: '${service.photoUrl}',
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  )),
            ))
        : null;
  }
}
