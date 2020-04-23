import 'package:supplyside/datamodels/item.dart';


Item aerosolBox = 
  Item('Aersol Box', 
    'assets/images/aerosol_box.png', 
    'Prevent c19 in the air', 
    [ItemRequirement.laserCutter]
  );
Item bodySuit = 
  Item('Body Suit', 
    'assets/images/body_suit.jpg', 
    '', 
    []
  );
Item faceShield = 
  Item('Face Shield', 
    'assets/images/face_shield.jpeg', 
    'To protect your face', 
    [ItemRequirement.fabricator]
  );
Item gloves = 
  Item('Gloves', 
    'assets/images/gloves.jpg', 
    '', 
    []
  );
Item goggles = 
  Item('Goggles', 
    'assets/images/goggles.jpeg', 
    '', 
    []
  );
Item n95Regular = 
  Item('N95 Regular', 
    'assets/images/n95_regular.jpg', 
    '', 
    []
  );
Item n95Small = 
  Item('N95 Small', 
    'assets/images/n95_small.jpeg', 
    '', 
    []
  );
Item sanitizer = 
  Item('Sanitizer', 
    'assets/images/hand_sanitizer.jpeg', 
    '', 
    []
  );
Item surgicalMask = 
  Item('Surgical Mask', 
    'assets/images/surgical_mask.png', 
    '', 
    []
  );
Item wipes = 
  Item('Wipes', 
    'assets/images/wipes.jpg', 
    '', 
    []
  );

List<Item> itemsToRequest = [ aerosolBox, bodySuit, faceShield,
  gloves, goggles, n95Regular, n95Small, sanitizer, surgicalMask, wipes];