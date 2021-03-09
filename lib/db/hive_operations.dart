import 'package:hive/hive.dart';

class Operations {
  var box = Hive.box('myBox');

  String get userPic {
    String userpic = box.get('ProfilePic');
    return userpic;
  }

  String get userName {
    String username = box.get('UserName');
    return username;
  }

  String get userEmail {
    String useremail = box.get('UserEmail');
    return useremail;
  }

  String get userId {
    String usrid = box.get('userId');
    return usrid;
  }
}
