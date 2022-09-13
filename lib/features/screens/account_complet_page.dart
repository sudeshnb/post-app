import 'package:flutter/material.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/colors.dart';
import 'package:poetic_app/core/utils/global_variable.dart';
import 'package:poetic_app/core/utils/overlay.dart';
import 'package:poetic_app/core/utils/strings.dart';
import 'package:poetic_app/core/utils/text_style.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/resources/auth_methods.dart';
import 'package:poetic_app/features/screens/widgets/custom_round_btn.dart';
import 'package:poetic_app/features/screens/widgets/interests.dart';

import 'widgets/search_country.dart';
import 'widgets/text_field_input.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({Key? key}) : super(key: key);

  @override
  State<AccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  final _enterPhoneNumber = TextEditingController();
  Map<String, dynamic> data = {"name": "Sri lanka", "code": "+94"};
  String accountT = '';
  Map<String, dynamic>? dataResult;
  bool _isLoading = false;
  // bool isATShow = false;
  bool isShowBtn = true;
  bool isIShow = false;
  bool isIShowBtn = true;

  List interests = [];

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

  void addInterestsType(String value) {
    // setState(() => account.remove(value));
    setState(() {
      interests.add(value);
      if (interests.length > 5) {
        isIShow = false;
      }
      if (interests.isEmpty) {
        isIShowBtn = true;
      }
    });
  }

  void removeInterests(String value) {
    // setState(() => account.remove(value));
    setState(() {
      interests.remove(value);
      if (interests.length > 5) {
        isIShow = false;
      }
      if (interests.isEmpty) {
        isIShowBtn = true;
      }
    });
  }

  // void getData(String code, String name) {
  //   setState(() {
  //     data = {"name": name, "code": code};
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    _enterPhoneNumber.dispose();
  }

  void signUpUser() async {
    // if (_enterPhoneNumber.text.isNotEmpty) {
    // if (value != 0) {
    if (accountT.isNotEmpty) {
      // if (interests.isNotEmpty) {
      // set loading to true
      setState(() => _isLoading = true);
      // signup user using our authmethodds
      String res = await AuthMethods().accounteSetUp(
        // gender: value == 1 ? 'Male' : 'Female',
        interst: interests,
        country: data['name'],
        phoneNo: '${data['code']}${_enterPhoneNumber.text}',
        accountType: accountT,
      );
      // if string returned is sucess, user has been created
      if (res == "success") {
        setState(() => _isLoading = false);

        // navigate to the home screen
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/HomePage',
          (route) => false,
        );
      } else {
        setState(() => _isLoading = false);
        // show the error
        showAutoCloseDialog(context, 'registration failed', 'error');
      }
    } else {
      showAutoCloseDialog(context, 'Please select your account type', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: RemoveOverlay(
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6 * SizeOF.width!),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5 * SizeOF.height!),
                Text(setupHeadding, style: completeTitle),
                SizedBox(height: 5 * SizeOF.height!),
                buildPhoneNumber(),
                // SizedBox(height: 5 * SizeOF.height!),
                // buildSelectGender(theme),
                SizedBox(height: 2 * SizeOF.height!),
                buildAccountType(theme),
                SizedBox(height: 3 * SizeOF.height!),
                buildInterest(theme),
                if (!_isLoading)
                  CustomRoundBtn(onTap: signUpUser, text: "continue"),
                if (_isLoading) const CircularProgressIndicator(),
                SizedBox(height: 5 * SizeOF.height!),
              ],
            ),
          )),
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
          style: dontHaveAccount,
        ),
        SizedBox(height: 2 * SizeOF.height!),
        Interests(
          onTap: addInterestsType,
          onRemove: removeInterests,
        ),
      ],
    );
  }

  Column buildAccountType(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2 * SizeOF.height!),
        DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            accountT.isEmpty ? setupAccount : accountT,
            style: dontHaveAccount,
          ),
          items: accountTypes.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: completeDropdown,
              ),
            );
          }).toList(),
          onChanged: (data) {
            setState(() {
              accountT = data!;
              // isATShow = true;
            });
          },
        )
      ],
    );
  }

  // Column buildSelectGender(ThemeData theme) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         setupGender,
  //         style: dontHaveAccount,
  //       ),
  //       SizedBox(height: 2 * SizeOF.height!),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           customRadioButton('Male', 1, theme),
  //           SizedBox(width: 5 * SizeOF.width!),
  //           customRadioButton('Female', 2, theme),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget customRadioButton(String text, int index, ThemeData theme) {
  //   return OutlinedButton(
  //     onPressed: () {
  //       setState(() => value = index);
  //     },
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         color: (value == index) ? blueColor : theme.textColor,
  //       ),
  //     ),
  //   );
  // }
  void showCuntryPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return ShearchCountry(
          onTap: getData,
        );
      },
    );
  }

  void getData(String code, String name) {
    setState(() {
      data = {"name": name, "code": code};
    });
  }

  Row buildPhoneNumber() {
    var theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: showCuntryPicker,
          child: Container(
            height: 12 * SizeOF.width!,
            width: 20 * SizeOF.width!,
            padding: EdgeInsets.all(2 * SizeOF.width!),
            color: theme.phoneCodeColor,
            child: Center(
              child: Text(
                data['code'],
                style:
                    TextStyle(color: textColor, fontSize: 2.5 * SizeOF.text!),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 65 * SizeOF.width!,
          child: TextFieldInput(
            hintText: 'Enter your phone number',
            textInputType: TextInputType.phone,
            textEditingController: _enterPhoneNumber,
          ),
        ),
      ],
    );
  }
}
