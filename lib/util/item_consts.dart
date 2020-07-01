import 'package:supplyside/datamodels/item.dart';

Item aerosolBox = 
  Item('Aersol Box', 
    'assets/images/aerosol_box.png', 
    'Prevent c19 in the air', 
    [ItemRequirement.laserCutter]
  );
Item gown = 
  Item('Gown', 
    'assets/images/gown_card.png', 
    '', 
    []
  );
Item faceShield = 
  Item('Face Shield', 
    'assets/images/face_shield_card.png', 
    'To protect your face', 
    [ItemRequirement.fabricator]
  );
Item gloves = 
  Item('Gloves', 
    'assets/images/gloves_card.png', 
    '', 
    []
  );
Item goggles = 
  Item('Goggles', 
    'assets/images/goggles_card.png', 
    '', 
    []
  );
Item n95Regular = 
  Item('N95 Regular', 
    'assets/images/n95_card.png', 
    '', 
    []
  );
Item n95Small = 
  Item('N95 Small', 
    'assets/images/n95_card.png', 
    '', 
    []
  );
Item sanitizer = 
  Item('Sanitizer', 
    'assets/images/sanitizer_card.png', 
    '', 
    []
  );
Item surgicalMask = 
  Item('Surgical Mask', 
    'assets/images/surgical_mask_card.jpg', 
    '', 
    []
  );
Item wipes = 
  Item('Wipes', 
    'assets/images/logo_small.png', 
    '', 
    []
  );

List<Item> itemsToRequest = [ aerosolBox, gown, faceShield,
  gloves, goggles, n95Regular, n95Small, sanitizer, surgicalMask, wipes];

Item itemFromName(String name) {
  switch (name) {
    case 'Aersol Box':
      return aerosolBox;
    break;
    case 'Gown':
      return gown;
    break;
    case 'Face Shield':
      return faceShield;
    break;
    case 'Gloves':
      return gloves;
    break;
    case 'Goggles':
      return goggles;
    break;
    case 'N95 Regular':
      return n95Regular;
    break;
    case 'N95 Small':
      return n95Small;
    break;
    case 'Sanitizer':
      return sanitizer;
    case 'Surgical Mask':
      return surgicalMask;
    case 'Wipes':
      return wipes;
    break;
    default:
      return null;
  }
}