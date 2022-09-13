// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/colors.dart';
import 'package:poetic_app/core/utils/utils.dart';
import 'package:poetic_app/features/screens/widgets/custom_round_btn.dart';
import 'package:poetic_app/features/screens/widgets/text_field_input.dart';

class SocialMediaLinkPage extends StatefulWidget {
  const SocialMediaLinkPage({Key? key}) : super(key: key);

  @override
  State<SocialMediaLinkPage> createState() => _SocialMediaLinkPageState();
}

class _SocialMediaLinkPageState extends State<SocialMediaLinkPage> {
  // final myId = FirebaseAuth.instance.currentUser!.uid;

  bool value = true;
  bool isLoading = false;

  var userData = {};
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    if (mounted) {
      setState(() => isLoading = true);
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
    } catch (_) {}
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/HomePage',
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : userData['socialLinks'].length > 0
              ? SizedBox(
                  height: height / 2,
                  child: BuildTextForm(
                    facebook: userData['socialLinks']['facebook'] ?? '',
                    instagram: userData['socialLinks']['instagram'] ?? '',
                    twitter: userData['socialLinks']['twitter'] ?? '',
                    isShow: userData['socialLinks']['isShow'],
                  ),
                )
              : SizedBox(
                  height: height / 2,
                  child: const BuildTextForm(
                    facebook: '',
                    instagram: '',
                    twitter: '',
                    isShow: true,
                  ),
                ),
    );
  }
}

class BuildTextForm extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const BuildTextForm({
    Key? key,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.isShow,
  });

  final String facebook;
  final String instagram;
  final String twitter;
  final bool isShow;

  @override
  State<BuildTextForm> createState() => _BuildTextFormState();
}

class _BuildTextFormState extends State<BuildTextForm> {
  TextEditingController facebookController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  final _dataBase = FirebaseFirestore.instance.collection('users');
  final myId = FirebaseAuth.instance.currentUser!.uid;

  // bool value = true;
  late bool value;
  @override
  void initState() {
    if (mounted) {
      setState(() {
        facebookController.text = widget.facebook;
        twitterController.text = widget.twitter;
        instagramController.text = widget.instagram;
        value = widget.isShow;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    facebookController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    super.dispose();
  }

  getUploadData() {
    try {
      _dataBase.doc(myId).update({
        'socialLinks': {
          'instagram': instagramController.text,
          'twitter': twitterController.text,
          'facebook': facebookController.text,
          'isShow': value
        }
      });

      showAutoCloseDialog(context, 'success', 'done');
    } catch (_) {
      showAutoCloseDialog(context, 'something went wrong', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: Container(), flex: 1),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.textBoxColor,
              child: SvgPicture.asset('assets/svg/Facebook.svg'),
            ),
            SizedBox(width: 3 * SizeOF.width!),
            SizedBox(
              width: 70 * SizeOF.width!,
              child: TextFieldInput(
                hintText: widget.facebook.isNotEmpty
                    ? widget.facebook
                    : 'Facebook username',
                textInputType: TextInputType.text,
                textEditingController: facebookController,
              ),
            ),
            SizedBox(width: 3 * SizeOF.width!),
            if (widget.facebook.isNotEmpty)
              const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  size: 15,
                  color: textColor,
                ),
              ),
          ],
        ),
        SizedBox(height: 3 * SizeOF.width!),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.textBoxColor,
              child: SvgPicture.asset('assets/svg/Instagram.svg'),
            ),
            SizedBox(width: 3 * SizeOF.width!),
            SizedBox(
              width: 70 * SizeOF.width!,
              child: TextFieldInput(
                hintText: widget.instagram.isNotEmpty
                    ? widget.instagram
                    : 'Instagram username',
                textInputType: TextInputType.text,
                textEditingController: instagramController,
              ),
            ),
            SizedBox(width: 3 * SizeOF.width!),
            if (widget.instagram.isNotEmpty)
              const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  size: 15,
                  color: textColor,
                ),
              ),
          ],
        ),
        SizedBox(height: 3 * SizeOF.width!),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.textBoxColor,
              child: SvgPicture.asset('assets/svg/Twitter.svg'),
            ),
            SizedBox(width: 3 * SizeOF.width!),
            SizedBox(
              width: 70 * SizeOF.width!,
              child: TextFieldInput(
                hintText: widget.twitter.isNotEmpty
                    ? widget.twitter
                    : 'Twitter username',
                textInputType: TextInputType.text,
                textEditingController: twitterController,
              ),
            ),
            SizedBox(width: 3 * SizeOF.width!),
            if (widget.twitter.isNotEmpty)
              const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  size: 15,
                  color: textColor,
                ),
              ),
          ],
        ),
        Flexible(child: Container(), flex: 4),
        CheckboxListTile(
            value: value,
            title: const Text(
                ' Do you want to share with other users on your social media link?'),
            onChanged: (onChanged) {
              setState(() => value = onChanged!);
              // getUploadData();
            }),
        Flexible(child: Container(), flex: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: CustomRoundBtn(onTap: getUploadData, text: 'Done'),
        )
      ],
    );
  }
}
