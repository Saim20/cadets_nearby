class AppUser {
  int cNumber;
  int intake;
  int treatCount;
  int latSector;
  int longSector;
  int coupons;
  double lat;
  double long;
  String id;
  String fullName;
  String college;
  String cName;
  String email;
  String photoUrl;
  String phone;
  String fbUrl;
  String instaUrl;
  String designation;
  String profession;
  String address;
  String verified;
  DateTime timeStamp;
  DateTime premiumTo;
  bool pLocation;
  bool premium;
  bool pPhone;
  bool celeb;
  bool treatHead;
  bool treatHunter;
  bool pAlways;
  bool pMaps;
  bool manualDp;
  bool contact;

  AppUser({
    required this.cName,
    required this.cNumber,
    required this.fullName,
    required this.college,
    required this.email,
    required this.intake,
    required this.premium,
    required this.pLocation,
    required this.pPhone,
    required this.verified,
    required this.celeb,
    required this.treatHead,
    required this.treatHunter,
    required this.id,
    required this.timeStamp,
    required this.fbUrl,
    required this.instaUrl,
    required this.designation,
    required this.profession,
    required this.manualDp,
    required this.treatCount,
    required this.latSector,
    required this.address,
    required this.contact,
    required this.coupons,
    required this.premiumTo,
    required this.longSector,
    this.photoUrl = '',
    this.lat = 0,
    this.long = 0,
    this.phone = '',
    this.pAlways = false,
    this.pMaps = false,
  });

  bool equals(AppUser user) => user.id == id;
  bool notEquals(AppUser user) => user.id != id;
}
