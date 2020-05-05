import 'package:UQS/Miscellaneous/loading.dart';
import 'package:UQS/Models/ticket.dart';
import 'package:UQS/Models/user.dart';
import 'package:UQS/Services/serviceDatabase.dart';
import 'package:UQS/Services/ticketDatabase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:UQS/Models/service.dart';

import '../viewticket.dart';

var test = {
  "okul": {
    0: {
      "img":
          "https://raw.githubusercontent.com/fatihemree/sirabende/master/pau.png",
      "abbreviation": "PAÜ",
      "address": "Denizli",
      "phoneNumber": "123456789",
      "displayName": "PAÜ"
    },
    1: {
      "img":
          "https://raw.githubusercontent.com/fatihemree/sirabende/master/osmaniye.png",
      "abbreviation": "OKÜ",
      "address": "osmaniye",
      "phoneNumber": "123456789",
      "displayName": "OKü"
    },
    2: {
      "img":
          "https://raw.githubusercontent.com/fatihemree/sirabende/master/izmir.png",
      "abbreviation": "İZM",
      "address": "İzmir",
      "phoneNumber": "5464545646",
      "displayName": "İZM"
    },
    3: {
      "img":
          "https://raw.githubusercontent.com/fatihemree/sirabende/master/ankara.png",
      "abbreviation": "ANK",
      "address": "Ankara",
      "phoneNumber": "5464545646",
      "displayName": "ANK"
    },
  },
  "event": {
    0: {
      "img":
          "https://raw.githubusercontent.com/fatihemree/sirabende/master/pautiyatro.png",
      "abbreviation": "PAUTYT",
      "address": "Denizli",
      "phoneNumber": "5464545646",
      "displayName": "PAUTYT"
    }
  },
  "hastane": {
    0: {
      "img":
          "https://raw.githubusercontent.com/fatihemree/sirabende/master/pauhastane.jpg",
      "abbreviation": "PAUTYT",
      "address": "Denizli",
      "phoneNumber": "5464545646",
      "displayName": "PAUTYT"
    }
  },
};

class CancelledPage extends StatefulWidget {
  @override
  _CancelledPageState createState() => _CancelledPageState();
}

class _CancelledPageState extends State<CancelledPage> {
  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context);
    final tickets = Provider.of<List<Cancelled>>(context) ?? [];

    return tickets.length == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'No cancelled tickets',
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
            ],
          )
        : Container(
            height: screenData.size.height / 2,
            child: GridView.builder(
              physics: ScrollPhysics(),
              itemCount: tickets.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.9,
                  mainAxisSpacing: 0.5),
              itemBuilder: (context, index) {
                return StreamProvider<Service>.value(
                    value: ServiceDatabase(uid: tickets[index].serviceUid)
                        .serviceData,
                    child: ActiveTickets(tickets: tickets, index: index));
              },
            ),
          );
  }
}

class ActiveTickets extends StatelessWidget {
  const ActiveTickets({
    Key key,
    @required this.tickets,
    @required this.index,
  }) : super(key: key);

  final List<Cancelled> tickets;
  final int index;

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context);
    Service service = Provider.of<Service>(context);
    var ticketNo = '${tickets[index].ticketRaw}';
    var isalreadyNotified = '${tickets[index].alreadyNotified}';
    var zero = '0';
    var trigger = '${tickets[index].ticketRaw - tickets[index].trigger}';
    var refNo = '${tickets[index].refNo}';

    var kosul = tickets[index].ticketNo;
    var resimUpdate = "";
//loggerNoStack.i(kosul.substring(0, 3));
    switch (kosul.substring(0, 3)) {
      case "PAÜ":
        resimUpdate = test["okul"][0]["img"];
        break;
      case "ANK":
        resimUpdate = test["okul"][3]["img"];
        break;
      default:
    }

    trigger == zero
        ? isalreadyNotified == zero ? TicketDatabase().initNotify(refNo) : null
        : null;

    return service != null
        ? Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(16, 127, 246, 1),
                            Color.fromRGBO(16, 127, 246, 1),
                          ])),
                      child: Column(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                              top: 25,
                              left: 30,
                              right: 30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: CachedNetworkImage(
                                   // imageUrl: '${service.photoUrl}',
                                    imageUrl: resimUpdate,
                                    width: 75.0,
                                    height: 75.0,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${tickets[index].ticketNo}',
                                          style: TextStyle(
                                              fontSize:
                                                  screenData.size.height / 30,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '${tickets[index].ticketRaw - service.ticketCountDone} Person(s) before you',
                                          style: TextStyle(
                                              fontSize:
                                                  screenData.size.height / 60,
                                              color: Colors.white),
                                        ),
                                      ]),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.chevron_right,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ViewTicket(
                                                  displayName:
                                                      service.displayName,
                                                  abbreviation:
                                                      service.abbreviation,
                                                  email: service.email,
                                                  phoneNumber:
                                                      service.phoneNumber,
                                                 // photoUrl: service.photoUrl,
                                                  photoUrl: resimUpdate,
                                                  ticketCount:
                                                      service.ticketCount,
                                                  ticketNo: ticketNo,
                                                  refNo: refNo,
                                                  teller: tickets[index].teller,
                                                  ticketRaw:
                                                      tickets[index].ticketRaw,
                                                  categoryIndex:
                                                      service.categoryIndex,
                                                  ticketdone:
                                                      service.ticketCountDone,
                                                  uid: service.uid)));
                                    })
                              ],
                            )),
                      ]),
                    )),
              ]))
        : Loading();
  }
}
