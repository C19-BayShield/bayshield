import 'package:supplyside/datamodels/item.dart';
import 'package:supplyside/datamodels/order.dart';


Item faceShield = Item('Face Shield', '', 'To protect your face', [ItemRequirement.fabricator]);
Item aerosolBox = Item('Aersol Box', '', 'Prevent c19 in the air', [ItemRequirement.laserCutter]);


List<Item> itemsToRequest = [faceShield, aerosolBox];

List<SupplyRequest> TEST_REQS = [SupplyRequest(item: faceShield, amtOrdered: 6, status: Status.ordered), 
  SupplyRequest(item: faceShield, amtOrdered: 23, status: Status.ordered), ];
