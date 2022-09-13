import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:flutter/services.dart' show rootBundle;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  Uint8List? _image;
  String token = '';
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty) {
      if (Email.validator(_emailController.text)) {
        if (Password.validator(_passwordController.text)) {
          ByteData bytes = await rootBundle.load('assets/image/l60Hf.png');
          final Uint8List list = bytes.buffer.asUint8List();
          // set loading to true
          setState(() => _isLoading = true);
          if (_image == null) {
            setState(() => _image = list);
          }
          // signup user using our authmethodds
          String res = await AuthMethods().signUpUser(
              email: _emailController.text,
              password: _passwordController.text,
              username: _usernameController.text,
              token: token,
              file: _image!);
          // if string returned is sucess, user has been created
          if (res == "Success") {
            setState(() => _isLoading = false);

            // navigate to the account setup page
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/AccountSetup',
              (route) => false,
            );
          } else {
            setState(() => _isLoading = false);

            showAutoCloseDialog(
                context, 'Register failed. already used this email', 'error');
          }
        } else {
          showAutoCloseDialog(
              context,
              'Invalid password format. must be used 8 characters 0-9 a-z A-Z',
              'error');
        }
      } else {
        showAutoCloseDialog(context, 'Invalid email format', 'error');
      }
    } else {
      showAutoCloseDialog(context, 'Not allow empty text field', 'error');
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() => _image = im);
  }

  getTokenId() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() => token = value!);
    });
  }

  @override
  void initState() {
    getTokenId();
    super.initState();
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

  Widget buildProfilePicPick(theme) => Stack(
        children: [
          _image != null
              ? CircleAvatar(
                  radius: 64,
                  backgroundImage: MemoryImage(_image!),
                  backgroundColor: theme.backgroundColor,
                )
              : CircleAvatar(
                  radius: 64,
                  backgroundImage: const AssetImage('assets/image/l60Hf.png'),
                  backgroundColor: theme.backgroundColor,
                ),
          Positioned(
            bottom: -10,
            left: 80,
            child: IconButton(
              onPressed: selectImage,
              icon: const Icon(Icons.add_a_photo),
            ),
          )
        ],
      );
  Widget buildBodyContent(context) {
    var theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6 * SizeOF.width!),
      alignment: Alignment.center,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5 * SizeOF.height!),
          Text(signupHeadding, style: authPageTitle),
          SizedBox(height: 2 * SizeOF.height!),
          Text(
            signupSubHeaddding,
            textAlign: TextAlign.center,
            style: authPageSubTitle,
          ),
          SizedBox(height: 5 * SizeOF.height!),
          buildProfilePicPick(theme),
          SizedBox(height: 3.2 * SizeOF.height!),
          TextFieldInput(
            hintText: 'Enter your username',
            textInputType: TextInputType.text,
            textEditingController: _usernameController,
          ),
          SizedBox(height: 3.2 * SizeOF.height!),
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
          // SizedBox(height: 5 * SizeOF.height!),
          // buildPhoneNumber(),
          SizedBox(height: 5 * SizeOF.height!),
          if (!_isLoading)
            CustomRoundBtn(
              onTap: signUpUser,
              text: 'Signup ',
            ),
          if (_isLoading) const CircularProgressIndicator(),
          SizedBox(height: 5 * SizeOF.height!),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'Already have an account? ',
                  style: dontHaveAccount,
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/LoginPage',
                  (route) => false,
                ),
                child: Container(
                  child: Text(' Login', style: btnLoginSignup),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          ),
          Flexible(
            child: Container(),
            flex: 2,
          ),
        ],
      ),
    );
  }

  // void showCuntryPicker() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return ShearchCountry(
  //         onTap: getData,
  //       );
  //     },
  //   );
  // }

  // void getData(String code, String name) {
  //   setState(() {
  //     data = {"name": name, "code": code};
  //   });
  // }
}
