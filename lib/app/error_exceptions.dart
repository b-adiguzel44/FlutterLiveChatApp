class OccuredExceptions {

  static String show(String errorCode) {

    switch(errorCode) {
      case "email-already-in-use":
        return "Bu e-posta adresi zaten kullanımda. Lütfen başka bir e-posta adresi deneyiniz.";
      case "invalid-credential":
        return "Bu e-posta adresi geçersiz. Lütfen başka bir e-posta adresi deneyiniz.";
      default:
        return "Bir hata oluştu";
    }
  }

}