class Validate {
  static String? validateEmail(String email) {
    RegExp emailRegex = RegExp(r"[a-z0-9_\-]+@[a-z]+\.[a-z]{2,3}");
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  static String? validatePassword(String password) {
    if (password.isEmpty || password.length < 8) {
      return "Invalid Password";
    } else {
      return null;
    }
  }

  static String? validateUser(String name) {
    if (name.isEmpty || name.length <= 3) {
      return "Invalid Username";
    } else {
      return null;
    }
  }
}
