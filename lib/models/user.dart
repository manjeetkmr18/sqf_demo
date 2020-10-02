class User {
  static const tblUser = 'users';
  static const colId = 'id';
  static const colName = 'name';
  static const colMobile = 'mobile';
  static const colEmail = 'email';
  static const colInterest = 'interest';
  static const colAddress = 'address';

  int id;
  String name;
  String mobile;
  String email;
  String interest;
  String address;

  User({this.id, this.name, this.mobile});

  User.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    mobile = map[colMobile];
    email = map[colEmail];
    interest = map[colInterest];
    address = map[colAddress];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colMobile: mobile , colEmail: email , colInterest: interest , colAddress: address};
    if (id != null) {
      map['colId'] = id;
    }
    return map;
  }
}
