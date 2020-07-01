import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplyside/datamodels/order.dart';

import '../datamodels/order.dart';

class FirestoreOrders {
  final CollectionReference _ordersRef = Firestore.instance.collection("orders");
  final CollectionReference _requestsRef = Firestore.instance.collection("requests");

  Future createOrder(SupplyOrder order) async {
    try {
      DocumentReference docRef = await _ordersRef.add(order.toJson());
      print('Saved order to db on: $order.time');
      String orderID = docRef.documentID;
      order.setSupplyNo(orderID);
    } catch (e) {
      return e.message;
    }
  }

  Future createRequest(SupplyRequest request) async {
    try {
      DocumentReference docRef = await _requestsRef.add(request.toJson());
      print('Saved request to db');
      String reqID = docRef.documentID;
      request.setRequestNo(reqID);
      return reqID;
    } catch (e) {
      return e.message;
    }
  }

  Future deleteRequest(SupplyOrder order, String requestID) async {
    try {
      order.deleteRequest(requestID);
      if (order.getRequests().length == 0) {
        await deleteOrder(order.supplyNo);
      } else {
        await _ordersRef.document(order.supplyNo).
      updateData({"requests": order.requests});
      }
      await _requestsRef.document(requestID).delete();
      print('Deleted request no: $requestID');
    } catch (e) {
      return e.message;
    }
  }

  Future deleteOrder(String id) async {
    try {
      await _ordersRef.document(id).delete();
      print('Deleted order no: $id');
    } catch (e) {
      return e.message;
    }
  }

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
      print('Error: $e');
    }
  }
}