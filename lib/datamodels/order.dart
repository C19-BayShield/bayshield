import 'package:flutter/material.dart';
import 'package:supplyside/datamodels/item.dart';

enum Status {
  ordered,
  pending,
  shipped,
  delivered
}

/// A Supply Request is an individual request for a single item
class SupplyRequest {

  SupplyRequest({this.requestNo,@required this.amtOrdered,@required this.item, this.status});

  String requestNo;
  int amtOrdered;
  Item item;
  Status status;

  String statusToString(){
    print(status);
    switch (status) {
      case Status.delivered:
        return 'Delivered';
      case Status.ordered:
        return 'Ordered';
      default: return 'TBD';
    }
    
  }
}


/// A SupplyOrder is an overall request for a group of items
class SupplyOrder {

  SupplyOrder({this.supplyNo, this.requests, this.status});

  String supplyNo;
  List<SupplyRequest> requests;
  Status status;
}

