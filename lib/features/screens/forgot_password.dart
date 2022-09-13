import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/utils/colors.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/strings.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/core/validater/email.dart';
import 'package:poetic_app/features/screens/widgets/custom_round_btn.dart';
import 'package:poetic_app/features/screens/widgets/text_field_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RemoveOverlay(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6 * SizeOF.width!),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Text(
                        forgotPassTitle,
                        textAlign: TextAlign.center,
                        style: forgotpassTitle,
                      ),
                      SizedBox(height: 8 * SizeOF.height!),
                      TextFieldInput(
                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                      ),
                      SizedBox(height: 8 * SizeOF.height!),
                      if (!_isLoading)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6 * SizeOF.width!),
                          child: CustomRoundBtn(
                            onTap: forgotPassword,
                            text: 'Reset Password',
                          ),
                        ),
                      if (_isLoading)
                        const CircularProgressIndicator(color: primaryColor),
                    ]),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/LoginPage',
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future forgotPassword() async {
    if (_emailController.text.isNotEmpty) {
      if (Email.validator(_emailController.text)) {
        // set loading to true
        setState(() => _isLoading = true);
        try {
          await FirebaseAuth.instance
              .sendPasswordResetEmail(
            email: _emailController.text.trim(),
          )
              .whenComplete(() {
            setState(() => _isLoading = false);

            showAutoCloseDialog(
                context, 'Check your email to reset your password', 'error');
          });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            showAutoCloseDialog(context, 'Failed user not found', 'error');
          } else if (e.code == 'wrong-password') {}
        }
      } else {
        showAutoCloseDialog(context, 'Invalid email format', 'error');
      }
    } else {
      showAutoCloseDialog(context, 'Not allow empty value', 'error');
    }
  }
}
