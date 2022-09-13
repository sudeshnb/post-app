import 'package:flutter/material.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/light_theme.dart';

// var theme = Theme.of(context);

TextStyle authPageTitle = TextStyle(
  color: LightColor.textColor,
  fontSize: 5 * SizeOF.text!,
  fontWeight: FontWeight.bold,
);

TextStyle authPageSubTitle = TextStyle(
  color: LightColor.textColor,
  fontSize: 2 * SizeOF.text!,
);

TextStyle authPageForgotPassword = TextStyle(
  color: LightColor.textColor,
  fontSize: 2 * SizeOF.text!,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.5,
  // decoration: TextDecoration.underline,
);

TextStyle dontHaveAccount = TextStyle(
  color: LightColor.textColor,
  fontSize: 2.2 * SizeOF.text!,
);

TextStyle btnLoginSignup = TextStyle(
  fontWeight: FontWeight.bold,
  color: LightColor.textColor,
  fontSize: 2 * SizeOF.text!,
);

//
TextStyle forgotpassTitle = TextStyle(
  color: LightColor.textColor,
  fontSize: 2.8 * SizeOF.text!,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.3,
);
//
TextStyle completeTitle = TextStyle(
  color: LightColor.textColor,
  fontSize: 3 * SizeOF.text!,
  fontWeight: FontWeight.bold,
);
TextStyle completeSubTitle = TextStyle(
  color: LightColor.textColor,
  fontSize: 2.5 * SizeOF.text!,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.3,
);

TextStyle completeDropdown = TextStyle(
  color: LightColor.iconColor,
  fontSize: 2.2 * SizeOF.text!,
);
//postcard
//

TextStyle postcardUsername = TextStyle(
  color: LightColor.textColor,
  fontSize: 2.2 * SizeOF.text!,
  fontWeight: FontWeight.bold,
);
//

TextStyle postcardaccountType = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 1.7 * SizeOF.text!,
  color: LightColor.iconColor,
);
//
TextStyle profileAtype = TextStyle(
  color: LightColor.iconColor,
  fontWeight: FontWeight.w500,
  fontSize: 1.8 * SizeOF.text!,
);
//

TextStyle profilebio = TextStyle(
  color: LightColor.iconColor,
  fontSize: 2 * SizeOF.text!,
);
//
TextStyle peopleLastmsg = TextStyle(
  color: LightColor.iconColor,
  fontSize: 2 * SizeOF.text!,
  fontWeight: FontWeight.w600,
);
// message card

TextStyle chatMymsg = TextStyle(
  color: Colors.white.withOpacity(0.7),
  fontSize: 1.4 * SizeOF.text!,
  fontWeight: FontWeight.w600,
);

// splashpage

TextStyle logoName = TextStyle(
    color: Colors.white,
    letterSpacing: 1,
    fontSize: 40,
    // fontStyle: FontStyle.italic,
    fontFamily: 'Parnaso', // 'TW CEN MT',
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        offset: const Offset(0.0, 1.0),
        blurRadius: 10.0,
        color: Colors.white.withOpacity(0.5),
      ),
      Shadow(
        offset: const Offset(0.0, -1.0),
        blurRadius: 2.0,
        color: Colors.white.withOpacity(0.5),
      ),
      Shadow(
        offset: const Offset(1.0, 0.0),
        blurRadius: 2.0,
        color: Colors.white.withOpacity(0.5),
      ),
      Shadow(
        offset: const Offset(-1.0, 0.0),
        blurRadius: 2.0,
        color: Colors.white.withOpacity(0.5),
      ),
    ]);

TextStyle logoDarkName = TextStyle(
    color: Colors.black,
    letterSpacing: 1,
    fontSize: 40,
    // fontStyle: FontStyle.italic,
    fontFamily: 'Parnaso', // 'TW CEN MT',
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        offset: const Offset(0.0, 1.0),
        blurRadius: 1,
        color: Colors.white.withOpacity(0.9),
      ),
      Shadow(
        offset: const Offset(0.0, -0.0),
        blurRadius: 1,
        color: Colors.white.withOpacity(0.9),
      ),
      Shadow(
        offset: const Offset(0.0, 0.0),
        blurRadius: 1.0,
        color: Colors.white.withOpacity(0.9),
      ),
      Shadow(
        offset: const Offset(-2.0, 0.0),
        blurRadius: 1,
        color: Colors.white.withOpacity(0.9),
      ),
    ]);
