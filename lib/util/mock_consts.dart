import 'package:supplyside/datamodels/item.dart';
import 'package:supplyside/datamodels/order.dart';

String faceShildImg = 'https://s3-us-west-2.amazonaws.com/issuewireassets/primg/27694/thumb_first-nih-recommended-3d-printed-face-shield-for-covid-19-launched-by-design-that-matter60.jpg';
String aBoxImg = 'https://matchgrademed.com/wp-content/uploads/2020/04/Stackable-Aerosol-Box.jpg';
Item faceShield = Item('Face Shield', faceShildImg, 'To protect your face', [ItemRequirement.fabricator]);
Item aerosolBox = Item('Aersol Box', aBoxImg, 'Prevent c19 in the air', [ItemRequirement.laserCutter]);


List<Item> itemsToRequest = [faceShield, aerosolBox];

List<SupplyRequest> TEST_REQS = [SupplyRequest(item: faceShield, amtOrdered: 6, status: Status.ordered), 
  SupplyRequest(item: faceShield, amtOrdered: 23, status: Status.ordered), ];
