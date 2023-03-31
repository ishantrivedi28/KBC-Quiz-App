import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  static final uidkey = "isdjfidsjfojsd";
  static final lkey = "isdjfsfeaggrsdgidsjfojsd";
  static final rkey = "dhvcxnivdifejfjidzji";
  static final nkey = "agegeafewfergerg";
  static final mkey = "agrcfvikjfdjvofj";
  static final pkey = "hcvchuhfkejanpwekofck";
  static final audKey = "iadfioasjdfijsaofwerwerdfgs";
  static final jokKey = "asidfjoidjfaijsdfoij";
  static final fiftyKey = "iasjfidjjcvjdijfgirejfeaioj";
  static final expKey = "isajfisjdfjsdsidjfijdifjidj";

  static Future<bool> saveuserID(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(uidkey, uid);
  }

  static Future<String?> getuserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(uidkey);
  }

  static Future<bool> saveMoney(String money) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(mkey, money);
  }

  static Future<String?> getMoney() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(mkey);
  }

  static Future<bool> saveName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(nkey, name);
  }

  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(nkey);
  }

  static Future<bool> saveLevel(String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(lkey, level);
  }

  static Future<String?> getLevel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(lkey);
  }

  static Future<bool> saveUrl(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(pkey, url);
  }

  static Future<String?> getUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(pkey);
  }

  static Future<bool> saveRank(String rank) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(rkey, rank);
  }

  static Future<String?> getRank() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(rkey);
  }

  static Future<bool> saveAud(bool isAvail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(audKey, isAvail);
  }

  static Future<bool?> getAud() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(audKey);
  }

  static Future<bool> saveJok(bool isAvail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(jokKey, isAvail);
  }

  static Future<bool?> getJok() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(jokKey);
  }

  static Future<bool> saveFifty(bool isAvail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(fiftyKey, isAvail);
  }

  static Future<bool?> getFifty() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(fiftyKey);
  }

  static Future<bool> saveExp(bool isAvail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(expKey, isAvail);
  }

  static Future<bool?> getExp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(expKey);
  }
}
