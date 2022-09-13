import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/colors.dart';
import 'package:poetic_app/core/utils/global_variable.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/strings.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/resources/storage_methods.dart';
import 'package:poetic_app/features/screens/widgets/text_field_input.dart';

import 'widgets/custom_b_sheet.dart';
import 'widgets/edit_interests.dart';
import 'widgets/select_languages.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Map<String, dynamic> data = {"country": "Sri lanka"};
  bool isLoading = false;
  List selectLanguage = [];
  List<dynamic>? dataRetrieved;

  List<dynamic>? data;
  String accountT = '';
  String country = '';

  Uint8List? _image;
  var userData = {};
  @override
  void initState() {
    super.initState();
    getData();
    _getCountriesData();
  }

  Future _getCountriesData() async {
    final String response =
        await rootBundle.loadString('assets/countries.json');
    dataRetrieved = await json.decode(response) as List<dynamic>;
    setState(() {
      data = dataRetrieved;
    });
  }

  getData() async {
    if (mounted) {
      setState(() => isLoading = true);
      // data = dataRetrieved;
    }

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    if (mounted) {
      setState(() => _image = im);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _countryController.dispose();
    _phoneNoController.dispose();
  }

  void updateUser() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      if (mounted) {
        setState(() => isLoading = true);
        if (_emailController.text.isNotEmpty) {
          users.doc(userData['uid']).update({'email': _emailController.text});
          await _auth.currentUser!.updateEmail(_emailController.text);
        }
        if (_passwordController.text.isNotEmpty) {
          await _auth.currentUser!.updatePassword(_passwordController.text);
        }
        if (_image != null) {
          String photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', _image!, false);
          users.doc(userData['uid']).update({'photoUrl': photoUrl});
        }
        if (_usernameController.text.isNotEmpty) {
          users
              .doc(userData['uid'])
              .update({'username': _usernameController.text});
        }
        if (_bioController.text.isNotEmpty) {
          users.doc(userData['uid']).update({'bio': _bioController.text});
        }
        if (country.isNotEmpty) {
          users.doc(userData['uid']).update({'country': country});
        }
        if (_phoneNoController.text.isNotEmpty) {
          users
              .doc(userData['uid'])
              .update({'phoneNo': _phoneNoController.text});
        }
        if (accountT.isNotEmpty) {
          users.doc(userData['uid']).update({'accountType': accountT});
        }
        setState(() => isLoading = false);
      }

      showAutoCloseDialog(context, 'success', 'done');
    } catch (_) {
      if (mounted) {
        setState(() => isLoading = false);
      }

      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
  }

  void refLanguage() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/HomePage',
              (route) => false,
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: updateUser,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 3 * SizeOF.height!,
                vertical: 1.2 * SizeOF.height!,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5 * SizeOF.height!),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 30],
                  colors: <Color>[
                    Color(0XFF33001B),
                    Color(0XFFFF0084),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0XFFAE0000).withOpacity(0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 2 * SizeOF.text!,
                    letterSpacing: 1,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : SafeArea(
              child: RemoveOverlay(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 6 * SizeOF.width!)
                        .copyWith(bottom: 10 * SizeOF.height!),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _image != null
                                  ? CircleAvatar(
                                      radius: 64,
                                      backgroundImage: MemoryImage(_image!),
                                      backgroundColor: appBarColor,
                                    )
                                  : CircleAvatar(
                                      radius: 64,
                                      backgroundImage:
                                          NetworkImage(userData['photoUrl']),
                                      backgroundColor: appBarColor,
                                    ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: theme.textBoxColor,
                                  child: IconButton(
                                    onPressed: selectImage,
                                    icon: const Icon(Icons.add_a_photo),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        buildUsernameTile(theme),
                        buildBioTile(theme),
                        buildCountryTile(theme),
                        buildLanguages(theme),
                        buildPhoneNoTile(theme),
                        buildAccountType(theme),
                        buildEmailTile(theme),
                        buildPasswordTile(theme),
                        buildInterest(theme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Column buildInterest(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          setupInterest,
          style: postcardUsername,
        ),
        SizedBox(height: 2 * SizeOF.height!),
        InkWell(
          onTap: () {
            showModalBottomSheet(
                elevation: 0,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return EditInterests(
                    userData: userData['interst'],
                    onTap: refLanguage,
                  );
                });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
            decoration: BoxDecoration(
              color: theme.textBoxColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  if (userData['interst'].isEmpty)
                    TextSpan(
                      text: 'please select your interest',
                      style: TextStyle(
                        color: const Color(0XFF5458F7),
                        fontWeight: FontWeight.w500,
                        fontSize: 2 * SizeOF.text!,
                      ),
                    ),
                  if (userData['interst'].isNotEmpty)
                    for (int k = 0; k < userData['interst'].length; k++)
                      TextSpan(
                        text: '# ${userData['interst'][k]} ',
                        style: completeDropdown.copyWith(
                          color: const Color(0XFF5458F7),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column buildCountryTile(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Country',
          style: postcardUsername,
        ),
        SizedBox(height: 1 * SizeOF.height!),
        InkWell(
          onTap: () {
            showModalBottomSheet(
                elevation: 0,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return CustomBSheet(
                      childs: data!.map((value) {
                    return TextButton(
                      onPressed: () {
                        setState(() => country = value['country']);
                        Navigator.pop(context);
                      },
                      child: Text(
                        value['country'],
                        style: completeDropdown,
                      ),
                    );
                  }).toList());
                });
          },
          child: Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
            decoration: BoxDecoration(
              color: theme.textBoxColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              country.isEmpty
                  ? userData['country'].isEmpty
                      ? 'please select your country'
                      : userData['country']
                  : country,
              style: dontHaveAccount,
            ),
          ),
        ),
      ],
    );
  }

  Column buildAccountType(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Type',
          style: postcardUsername,
        ),
        SizedBox(height: 1 * SizeOF.height!),
        InkWell(
            onTap: () {
              showModalBottomSheet(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return CustomBSheet(
                        childs: accountTypes.map((value) {
                      return TextButton(
                        onPressed: () {
                          setState(() => accountT = value);
                          Navigator.pop(context);
                        },
                        child: Text(
                          value,
                          style: completeDropdown,
                        ),
                      );
                    }).toList());
                  });
            },
            child: Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
              decoration: BoxDecoration(
                color: theme.textBoxColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                accountT.isEmpty ? userData['accountType'] : accountT,
                style: dontHaveAccount,
              ),
            )),
      ],
    );
  }

  Widget buildUsernameTile(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: 2 * SizeOF.height!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Username',
            style: postcardUsername,
          ),
          SizedBox(height: 1 * SizeOF.height!),
          TextFieldInput(
            hintText: userData['username'],
            textInputType: TextInputType.text,
            textEditingController: _usernameController,
          ),
        ],
      ),
    );
  }

  Widget buildBioTile(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: 2 * SizeOF.height!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Bio',
            style: postcardUsername,
          ),
          SizedBox(height: 1 * SizeOF.height!),
          TextFieldInput(
            hintText: userData['bio'],
            textInputType: TextInputType.text,
            textEditingController: _bioController,
          ),
        ],
      ),
    );
  }

  Widget buildLanguages(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: 2 * SizeOF.height!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Language',
            style: postcardUsername,
          ),
          SizedBox(height: 1 * SizeOF.height!),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return LanguageSheet(
                      userData: userData['languages'],
                      onTap: refLanguage,
                    );
                  });
            },
            child: Container(
              // height: 50,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
              // padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: theme.textBoxColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    if (userData['languages'].isEmpty)
                      TextSpan(
                        text: 'please select your language',
                        style: TextStyle(
                          color: const Color(0XFF5458F7),
                          fontWeight: FontWeight.w500,
                          fontSize: 2 * SizeOF.text!,
                        ),
                      ),
                    if (userData['languages'].isNotEmpty)
                      for (int k = 0; k < userData['languages'].length; k++)
                        TextSpan(
                          text: '# ${userData['languages'][k]} ',
                          style: completeDropdown.copyWith(
                              color: const Color(0XFF5458F7)),
                        ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPhoneNoTile(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: 2 * SizeOF.height!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Phone number',
            style: postcardUsername,
          ),
          SizedBox(height: 1 * SizeOF.height!),
          TextFieldInput(
            hintText: userData['phoneNo'],
            textInputType: TextInputType.text,
            textEditingController: _phoneNoController,
          ),
        ],
      ),
    );
  }

  Widget buildEmailTile(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: 2 * SizeOF.height!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Email',
            style: postcardUsername,
          ),
          SizedBox(height: 1 * SizeOF.height!),
          TextFieldInput(
            hintText: userData['email'],
            textInputType: TextInputType.text,
            textEditingController: _emailController,
          ),
        ],
      ),
    );
  }

  Widget buildPasswordTile(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: 2 * SizeOF.height!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Password',
            style: postcardUsername,
          ),
          SizedBox(height: 1 * SizeOF.height!),
          TextFieldInput(
            hintText: '.............',
            textInputType: TextInputType.text,
            isPass: true,
            textEditingController: _passwordController,
          ),
        ],
      ),
    );
  }
}
