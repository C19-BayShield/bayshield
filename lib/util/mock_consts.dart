import 'package:supplyside/datamodels/item.dart';
import 'package:supplyside/datamodels/order.dart';

String faceShildImg = "assets/images/face_shield_icon.png";
String aBoxImg = 'https://matchgrademed.com/wp-content/uploads/2020/04/Stackable-Aerosol-Box.jpg';
Item faceShield = Item('Face Shield', faceShildImg, 'To protect your face', [ItemRequirement.fabricator]);
Item aerosolBox = Item('Aersol Box', aBoxImg, 'Prevent pathogens in the air', [ItemRequirement.laserCutter]);


List<Item> itemsToRequest = [faceShield, aerosolBox];

List<SupplyRequest> TEST_REQS = [SupplyRequest(item: faceShield, amtOrdered: 6, status: Status.ordered), 
  SupplyRequest(item: faceShield, amtOrdered: 23, status: Status.ordered), ];
