class JunMath {
  static int parseInt(String str) {
    try {
      if (str == null) return 0;
      if (str == "null") return 0;
      return int.parse(str);
    } catch (e) {
      return 0;
    }
  }

  static bool parseBool(String str){
    if(str is String &&
        (str.toLowerCase()=='true' || str.toLowerCase()=='1')){
      return true;
    }else{
      return false;
    }
  }
}