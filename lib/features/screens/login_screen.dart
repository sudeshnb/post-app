import 'package:flutter/material.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/strings.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/core/validater/email.dart';
import 'package:poetic_app/core/validater/password.dart';
import 'package:poetic_app/features/resources/auth_methods.dart';
import 'package:poetic_app/features/screens/widgets/custom_round_btn.dart';
import 'package:poetic_app/features/screens/widgets/text_field_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if (Email.validator(_emailController.text)) {
        if (Password.validator(_passwordController.text)) {
          setState(() => _isLoading = true);

          String res = await AuthMethods().loginUser(
              email: _emailController.text, password: _passwordController.text);

          if (res == 'success') {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/HomePage',
              (route) => false,
            );
            setState(() => _isLoading = false);
          } else {
            setState(() => _isLoading = false);

            showAutoCloseDialog(context, 'Login failed', 'error');
          }
        } else {
          showAutoCloseDialog(context, 'Invalid password format', 'error');
        }
      } else {
        showAutoCloseDialog(context, 'Invalid email format', 'error');
      }
    } else {
      showAutoCloseDialog(context, 'Not allow empty text field', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RemoveOverlay(
          child: SingleChildScrollView(
            child: buildBodyContent(context),
          ),
        ),
      ),
    );
  }

  Padding buildBodyContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6 * SizeOF.width!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10 * SizeOF.height!),
          Text(
            loginHeadding,
            style: authPageTitle,
          ),
          Text(
            loginSubHeadding,
            textAlign: TextAlign.center,
            style: authPageSubTitle,
          ),
          SizedBox(height: 10 * SizeOF.height!),
          TextFieldInput(
            hintText: 'Enter your email',
            textInputType: TextInputType.emailAddress,
            textEditingController: _emailController,
          ),
          SizedBox(height: 3.2 * SizeOF.height!),
          TextFieldInput(
            hintText: 'Enter your password',
            textInputType: TextInputType.text,
            textEditingController: _passwordController,
            isPass: true,
          ),
          SizedBox(height: 5 * SizeOF.height!),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/ForgotPasswordPage',
                    (route) => false,
                  );
                },
                child: Text(
                  loginForgotPass,
                  style: authPageForgotPassword,
                ),
              ),
            ],
          ),
          SizedBox(height: 5 * SizeOF.height!),
          if (!_isLoading)
            CustomRoundBtn(
              onTap: loginUser,
              text: 'Login',
            ),
          if (_isLoading) const CircularProgressIndicator(),
          SizedBox(height: 8 * SizeOF.height!),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  loginSignup,
                  style: dontHaveAccount,
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/SignUpPage',
                  (route) => false,
                ),
                child: Container(
                  child: Text(
                    ' Signup',
                    style: btnLoginSignup,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          ),
          Flexible(child: Container(), flex: 2),
        ],
      ),
    );
  }
}
