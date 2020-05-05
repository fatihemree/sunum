import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:UQS/Services/test.dart';
import 'package:UQS/Models/service.dart';

//functions for concerning the database for services
class ServiceDatabase {
  final String uid;
  final String category;
  final int categoryIndex;
  
  ServiceDatabase({this.uid, this.categoryIndex, this.category});

  //create an instance basi sa collection na 'services' halin sa database
  final CollectionReference serviceCollection =
      Firestore.instance.collection('services');

  //create a list of instances of class Service(see service.dart under Models)
  //This returns snapshots of data under the documents included in the collection
  //and assigns these values to the instances in the list
  List<Service> _serviceListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print("servis liste");
      print(doc);
      return Service(
        // abbreviation: doc.data['abbreviation'] ?? '',
        // address: doc.data['address'] ?? '',
        // displayName: doc.data['displayName'] ?? '',
        // email: doc.data['email'] ?? '',
        // phoneNumber: doc.data['phoneNumber'] ?? '',
        // photoUrl: doc.data['photoUrl'] ?? '',
        abbreviation: test["okul"][countUni]["abbreviation"] ?? '',
        address: test["okul"][countUni]["address"] ?? '',
        displayName: test["okul"][countUni]["displayName"] ?? '',
        email: test["okul"][countUni]["email"] ?? '',
        phoneNumber: test["okul"][countUni]["phoneNumber"] ?? '',
        photoUrl: test["okul"][countUni]["img"] ?? '',
        ticketCount: doc.data['ticketCount'] ?? 0,
        ticketCountDone: doc.data['ticketCountDone'] ?? 0,
        uid: doc.data['uid'] ?? '',
        categoryIndex: doc.data['categoryIndex'] ?? 0,
      );
    }).toList();
  }

  //creating an instance of the class Service(ara sa models na folder) para istore ang data halin sa database
  //tickects Database
  //deneme
  Service _serviceDataFromSnapshot(DocumentSnapshot snapshot) {
    countUni = (countUni < limitUni ) ? countUni += 1 : 0;
    return Service(
      // abbreviation: snapshot.data['abbreviation'],
      // address: snapshot.data['address'],
      // displayName: snapshot.data['displayName'] ?? '',
      // email: snapshot.data['email'] ?? '',
      // phoneNumber: snapshot.data['phoneNumber'] ?? '',
      // photoUrl: snapshot.data['photoUrl'] ?? '',
       abbreviation: test["okul"][countUni]["abbreviation"] ?? '',
        address: test["okul"][countUni]["address"] ?? '',
        displayName: test["okul"][countUni]["displayName"] ?? '',
        email: test["okul"][countUni]["email"] ?? '',
        phoneNumber: test["okul"][countUni]["phoneNumber"] ?? '',
        photoUrl: test["okul"][countUni]["img"] ?? '',
      ticketCount: snapshot.data['ticketCount'] ?? 0,
      ticketCountDone: snapshot.data['ticketCountDone'] ?? 0,
      uid: snapshot.data['uid'] ?? '',
      categoryIndex: snapshot.data['categoryIndex'] ?? 0,
    );
  }

//get service stream from the database (returns a list of services)
  Stream<List<Service>> get service {
    return serviceCollection
        .where("categoryIndex", isEqualTo: categoryIndex)
        // .orderBy('timestamp', descending: false)//basehan ya ang timestamp kung ano ang order sang list sng active tickets
        .snapshots()
        .map(_serviceListFromSnapshot);
  }

  // UNIVERISTY

  List<UniversityCategory> _serviceListUniversityFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      countUni = (countUni < limitUni) ? countUni += 1 : 0;
      // print("counter uni ${countUni}");
      return UniversityCategory(
        // abbreviation: doc.data['abbreviation'] ?? '',
        // address: doc.data['address'] ?? '',
        // displayName: doc.data['displayName'] ?? '',
        // email: doc.data['email'] ?? '',
        // phoneNumber: doc.data['phoneNumber'] ?? '',
        // photoUrl: test["okul"][countUni]["img"] ?? '', // abbreviation: doc.data['abbreviation'] ?? '',
        //photoUrl: doc.data['photoUrl'] ?? '',
        abbreviation: test["okul"][countUni]["abbreviation"] ?? '',
        address: test["okul"][countUni]["address"] ?? '',
        displayName: test["okul"][countUni]["displayName"] ?? '',
        email: test["okul"][countUni]["email"] ?? '',
        phoneNumber: test["okul"][countUni]["phoneNumber"] ?? '',
        photoUrl: test["okul"][countUni]["img"] ?? '',
        ticketCount: doc.data['ticketCount'] ?? 0,
        ticketCountDone: doc.data['ticketCountDone'] ?? 0,
        uid: doc.data['uid'] ?? '',
        categoryIndex: doc.data['categoryIndex'] ?? 0,
      );
    }).toList();
    
  }

  Stream<List<UniversityCategory>> get universityCategory {
    return serviceCollection
        .where("categoryIndex", isEqualTo: 0)
        .snapshots()
        .map(_serviceListUniversityFromSnapshot);
  }

  // ----------

  //  GOVERNMENT

  List<GovernmentCategory> _serviceListGovernmentFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //countEvent = (countEvent < 1) ? countEvent += 1 : 0;
      return GovernmentCategory(
        // abbreviation: doc.data['abbreviation'] ?? '',
        // address: doc.data['address'] ?? '',
        // displayName: doc.data['displayName'] ?? '',
        // email: doc.data['email'] ?? '',
        // phoneNumber: doc.data['phoneNumber'] ?? '',
        // photoUrl: doc.data['photoUrl'] ?? '',
        abbreviation: test["event"][0]["abbreviation"] ?? '',
        address: test["event"][0]["address"] ?? '',
        displayName: test["event"][0]["displayName"] ?? '',
        email: test["event"][0]["email"] ?? '',
        phoneNumber: test["event"][0]["phoneNumber"] ?? '',
        photoUrl: test["event"][0]["img"] ?? '',
        ticketCount: doc.data['ticketCount'] ?? 0,
        ticketCountDone: doc.data['ticketCountDone'] ?? 0,
        uid: doc.data['uid'] ?? '',
        categoryIndex: doc.data['categoryIndex'] ?? 0,
      );
    }).toList();
  }

  Stream<List<GovernmentCategory>> get governmentCategory {
    return serviceCollection
        .where("categoryIndex", isEqualTo: 1)
        .snapshots()
        .map(_serviceListGovernmentFromSnapshot);
  }

  // --------

  //  Bill/bank

  List<BillsBanksCategory> _serviceListBillsBanksFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      countHastane = (countHastane < 1) ? countHastane += 1 : 0;
      return BillsBanksCategory(
        // abbreviation: doc.data['abbreviation'] ?? '',
        // address: doc.data['address'] ?? '',
        // displayName: doc.data['displayName'] ?? '',
        // email: doc.data['email'] ?? '',
        // phoneNumber: doc.data['phoneNumber'] ?? '',
        // photoUrl: doc.data['photoUrl'] ?? '',
        abbreviation: test["hastane"][countHastane]["abbreviation"] ?? '',
        address: test["hastane"][countHastane]["address"] ?? '',
        displayName: test["hastane"][countHastane]["displayName"] ?? '',
        email: test["hastane"][countHastane]["email"] ?? '',
        phoneNumber: test["hastane"][countHastane]["phoneNumber"] ?? '',
        photoUrl: test["hastane"][countHastane]["img"] ?? '',
        ticketCount: doc.data['ticketCount'] ?? 0,
        ticketCountDone: doc.data['ticketCountDone'] ?? 0,
        uid: doc.data['uid'] ?? '',
        categoryIndex: doc.data['categoryIndex'] ?? 0,
      );
    }).toList();
  }

  Stream<List<BillsBanksCategory>> get billsbanksCategory {
    return serviceCollection
        .where("categoryIndex", isEqualTo: 2)
        .snapshots()
        .map(_serviceListBillsBanksFromSnapshot);
  }

  // --------

  //get serviceData stream from the database (returns specific data of a service)
  Stream<Service> get serviceData {
    return serviceCollection
        .document(uid)
        .snapshots()
        .map(_serviceDataFromSnapshot);
  }
}

/*
.

//get service stream from the database (returns a list of services)
  Stream<List<Service>> get serviceCategory {
    return serviceCollection
        .where("categoryIndex", isEqualTo: categoryIndex)
        // .orderBy('timestamp', descending: false)//basehan ya ang timestamp kung ano ang order sang list sng active tickets
        .snapshots()
        .map(_specificCategoryIndex);
  }


.collection("services")
.where("categoryIndex", "==", 0)

  //get serviceData stream from the database (returns specific data of a service)
  Stream<List<Service>> get specificService {
    return serviceCollection
        .where('categoryIndex', isEqualTo: 1)
       // .orderBy('timestamp', descending: false)//basehan ya ang timestamp kung ano ang order sang list sng active tickets
        .snapshots()
        .map(_specificCategoryIndex);
  } */

/*
  //test
  List<Service> _specificCategoryIndex(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Service(
        abbreviation: doc.data['abbreviation'],
        address: doc.data['address'],
        displayName: doc.data['displayName'] ?? '',
        email: doc.data['email'] ?? '',
        phoneNumber: doc.data['phoneNumber'] ?? '',
        photoUrl: doc.data['photoUrl'] ?? '',
        ticketCount: doc.data['ticketCount'] ?? '',
        uid: doc.data['uid'] ?? '',
        categoryIndex: doc.data['categoryIndex'] ?? '',
        category: doc.data['category'] ?? '', 
      );
    }).toList();
  } */
