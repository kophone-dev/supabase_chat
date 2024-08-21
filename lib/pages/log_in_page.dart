import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_chat/blocs/log_in_bloc.dart';
import 'package:supabase_chat/constants/dimens.dart';
import 'package:supabase_chat/constants/strings.dart';
import 'package:supabase_chat/constants/styles.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInBloc(),
      child: Consumer<LogInBloc>(
        builder: (context, bloc, child) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ProfileIcon(),
                  const SizedBox(
                    height: kMarginMedium2,
                  ),
                  // Email Text Field
                  CustomTextField(
                    labelText: kEmailLabel,
                    hintText: kEmailHint,
                    errorText: bloc.emailError,
                    controller: bloc.emailController,
                    onChanged: (value) {
                      bloc.changeEmail(value);
                    },
                  ),
                  const SizedBox(
                    height: kMarginMedium2,
                  ),

                  // Password Text Field
                  CustomTextField(
                    labelText: kPasswordLabel,
                    hintText: kPasswordHint,
                    isPassword: true,
                    helperText: bloc.passwordApprovedText,
                    errorText: bloc.passwordError,
                    controller: bloc.passwordController,
                    onChanged: (value) {
                      bloc.changePassword(value);
                    },
                  ),
                  const SizedBox(
                    height: kMarginMedium2,
                  ),

                  // Confirm Password
                  Visibility(
                    visible: bloc.isRegister,
                    child: CustomTextField(
                      labelText: kConfirmPasswordLabel,
                      hintText: kPasswordHint,
                      isPassword: true,
                      controller: bloc.confirmPasswordController,
                      onChanged: (value) {},
                    ),
                  ),
                  Visibility(
                    visible: bloc.isRegister,
                    child: const SizedBox(
                      height: kMarginMedium2,
                    ),
                  ),

                  // Log in button Text
                  LogInButton(
                    text: bloc.isRegister ? kRegisterBtnText : kLogInBtnText,
                    isEnable: bloc.isLogInAvailable(),
                    onTap: () {
                      bloc.onTapButton(context);
                    },
                  ),
                  const SizedBox(
                    height: kMarginMedium,
                  ),
                  Visibility(
                    visible: !bloc.isRegister,
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: '$kRegisterDes ',
                          style: TextStyle(
                            fontSize: kTextRegular,
                            color: Colors.black,
                          )),
                      TextSpan(
                          text: kRegisterHere,
                          style: const TextStyle(fontSize: kTextRegular, color: Colors.black, fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              bloc.changeRegister();
                            })
                    ])),
                  ),
                  Visibility(
                    visible: bloc.isRegister,
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: '$kAlreadyRegister ',
                          style: TextStyle(
                            fontSize: kTextRegular,
                            color: Colors.black,
                          )),
                      TextSpan(
                          text: kLogInHere,
                          style: const TextStyle(fontSize: kTextRegular, color: Colors.black, fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              bloc.changeRegister();
                            })
                    ])),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogInButton extends StatelessWidget {
  final Function onTap;
  final bool isEnable;
  final String text;
  const LogInButton({
    super.key,
    required this.onTap,
    required this.isEnable,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: kButtonHeight,
        decoration: BoxDecoration(color: isEnable ? Colors.red : Colors.grey, borderRadius: BorderRadius.circular(kButtonBorderRadius)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Function(String) onChanged;
  final bool isPassword;
  final bool isNumber;
  final bool isPhoneNumber;
  final String? helperText;
  final TextEditingController? controller;
  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    required this.onChanged,
    this.isPassword = false,
    this.isNumber = false,
    this.isPhoneNumber = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(kTextFieldBorderRadius),
      ),
      padding: EdgeInsets.only(
        left: kMarginMedium2,
        right: kMarginMedium2,
        top: kMarginMedium,
        bottom: errorText != null ? kMarginMedium2 : kMarginMedium,
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : (isPhoneNumber ? TextInputType.phone : null),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: kTextFieldNoBorder,
          errorBorder: kTextFieldNoBorder,
          enabledBorder: kTextFieldNoBorder,
          disabledBorder: kTextFieldNoBorder,
          focusedErrorBorder: kTextFieldNoBorder,
          focusedBorder: kTextFieldNoBorder,
          helperText: helperText,
          helperStyle: const TextStyle(color: Colors.black),
          label: labelText != null ? Text(labelText!) : null,
          labelStyle: const TextStyle(color: Colors.black),
          hintText: hintText,
          errorText: errorText,
        ),
        onChanged: (value) {
          onChanged(value);
        },
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kProfileContainerSize,
        height: kProfileContainerSize,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.red, width: kProfileContainerBorderSize)),
        child: const Icon(
          Icons.person,
          size: kProfileIconSize,
          color: Colors.red,
        ),
      ),
    );
  }
}
