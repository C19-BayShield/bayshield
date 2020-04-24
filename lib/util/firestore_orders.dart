import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplyside/datamodels/order.dart';

import '../datamodels/order.dart';

class FirestoreOrders {
  final CollectionReference _ordersRef = Firestore.instance.collection("orders");
  final CollectionReference _requestsRef = Firestore.instance.collection("requests");

  Future<List<SupplyOrder>> getOrders(String userId) async {
    try {
      QuerySnapshot qShot =
        await _ordersRef.where("userId", isEqualTo: userId).getDocuments();
      return qShot.documents.map(
      (doc) =>
          SupplyOrder.fromData(doc.documentID, doc.data)
        ).toList();
    } catch (e) {
      print(e.message);
      return null;
    }
  }


  Future getRequest(String requestId) async {
     try {
      var doc = await _requestsRef.document(requestId).get();
      return SupplyRequest.fromData(doc.documentID, doc.data);
    } catch (e) {
      print(e.message);
      return null;
    }
  }
}