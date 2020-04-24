import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supplyside/datamodels/item.dart';
import 'package:supplyside/util/item_consts.dart';
import 'package:supplyside/util/firestore_orders.dart';
import 'package:supplyside/locator.dart';

enum Status {
  ordered,
  pending,
  shipped,
  arrived,
  delivered
}

/// A Supply Request is an individual request for a single item
class SupplyRequest {

  SupplyRequest({this.requestNo,@required this.amtOrdered,@required this.item, this.status});

  String requestNo;
  int amtOrdered;
  Item item;
  Status status;

  SupplyRequest.fromData(String id, Map<String, dynamic> data)
    : item = itemFromName(data['item']),
      requestNo = id,
      amtOrdered = data['amtOrdered'],
      status = SupplyRequest.stringToStatus(data['status']);

  String statusToString(){
    switch (status) {
      case Status.delivered:
        return 'Delivered';
      case Status.ordered:
        return 'Ordered';
      case Status.arrived:
        return 'Arrived at Distribution';
      default: return 'TBD';
    }
  }

  static Status stringToStatus(String s) {
    switch (s) {
      case 'Delivered':
        return Status.delivered;
      case 'Ordered':
        return Status.ordered;
      case 'Arrived at Distribution':
        return Status.arrived;
      default: return null;
    }
  }

}


/// A SupplyOrder is an overall request for a group of items
class SupplyOrder {

  SupplyOrder({this.supplyNo, this.requests, this.status, this.userId});

  String userId;
  String supplyNo;
  List<String> requests;
  Status status;
  Timestamp timestamp;

  SupplyOrder.fromData(String id, Map<String, dynamic> data)
    : userId = data['userId'],
      supplyNo = id, // change to some hash of doc.documentID
      requests = List.from(data['requests']),
      status = SupplyRequest.stringToStatus(data['status']),
      timestamp = data['time'];
  
  List<String> getRequests() {
    return requests;
  }
}

