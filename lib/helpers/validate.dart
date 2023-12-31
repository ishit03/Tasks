class Validate {
  static RegExp emailRegex = RegExp(r"[a-z0-9_\-]+@[a-z]+\.[a-z]{2,3}");

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty || !emailRegex.hasMatch(email)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty || password.length < 8) {
      return "Invalid Password";
    } else {
      return null;
    }
  }

  static String? validateUser(String? name) {
    if (name == null || name.isEmpty || name.length <= 3) {
      return "Invalid Username";
    } else {
      return null;
    }
  }

  static String? validateTask(String? task) {
    if (task == null || task.isEmpty) {
      return 'Task cannot be empty';
    } else {
      return null;
    }
  }
}
