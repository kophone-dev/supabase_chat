import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_chat/model/model.dart';
import 'package:supabase_chat/model/model_impl.dart';
import 'package:supabase_chat/pages/chat_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogInBloc extends ChangeNotifier {
  bool isDisposed = false;
  String? email;
  String? emailError;
  String? passwordError;
  String? password;
  String? passwordApprovedText;
  String? confrimPasswordError;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isRegister = false;
  final Model _model = ModelImpl();

  LogInBloc() {}

  bool isLogInAvailable() {
    return emailController.text.isNotEmpty && passwordController.text.isNotEmpty && emailError == null && passwordError == null;
  }

  //---------------------------------------------------------------

  void changeRegister() {
    isRegister = !isRegister;
    safeNotifyListeners();
  }

  void onTapButton(BuildContext context) async {
    if (isRegister) {
      if (passwordController.text != confirmPasswordController.text) {
        Fluttertoast.showToast(msg: "Passwords are not matched");
        return;
      }
      AuthResponse? response = await _model.register(email: emailController.text, password: passwordController.text);
      if (response?.session != null) {
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ChatPage()),
            (route) => false,
          );
        }
      }
    } else {
      AuthResponse? response = await _model.logIn(email: emailController.text, password: passwordController.text);

      if (response?.session != null) {
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ChatPage()),
            (route) => false,
          );
        }
      }
    }
  }

  // ----------------------------------------------------------------

  // Email Section
  void changeEmail(String value) {
    email = value;
    validateEmail();
  }

  void validateEmail() {
    if (email?.isEmpty ?? true) {
      emailError = 'Email is Empty';
      safeNotifyListeners();
      return;
    }
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    bool isEmailPatternCorrect = email?.contains(RegExp(emailPattern)) ?? false;
    if (!isEmailPatternCorrect) {
      emailError = 'Email Pattern is not formatted';

      return;
    } else {
      emailError = null;
    }
    safeNotifyListeners();
  }

  //-----------------------------------------------------------------------

  // Password Section
  void changePassword(String value) {
    password = value;
    validatePassword();
  }

  void validatePassword() {
    if (!isRegister) {
      return;
    }
    if (password?.isEmpty ?? true) {
      passwordError = 'Password is empty';
      notifyListeners();
      return;
    }
    if (password == '123456') {
      passwordError = 'Password is too easy';
      notifyListeners();
      return;
    }

    if ((password?.length ?? 0) < 6) {
      passwordError = 'Password is too short';
      notifyListeners();
      return;
    }

    passwordError = null;
    passwordApprovedText = 'Password is strong';
    notifyListeners();
  }

  void safeNotifyListeners() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
