import 'package:flutter/material.dart';

import 'package:poetic_app/features/screens/account_complet_page.dart';
import 'package:poetic_app/features/screens/add_post_screen.dart';
import 'package:poetic_app/features/screens/chat/chat_details.dart';
import 'package:poetic_app/features/screens/chat/people.dart';
import 'package:poetic_app/features/screens/comments_screen.dart';
import 'package:poetic_app/features/screens/forgot_password.dart';
import 'package:poetic_app/features/screens/home_page.dart';
import 'package:poetic_app/features/screens/login_screen.dart';
import 'package:poetic_app/features/screens/pages/wapper.dart';
import 'package:poetic_app/features/screens/post_edit_page.dart';
import 'package:poetic_app/features/screens/profile_edit_page.dart';
import 'package:poetic_app/features/screens/profile_screen.dart';
import 'package:poetic_app/features/screens/signup_page.dart';
import 'package:poetic_app/features/screens/social_media_link.dart';
import 'package:poetic_app/features/screens/widgets/charts.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings? settings) {
    final arguments = settings?.arguments;
    switch (settings?.name) {

// ProfileScreen ProfileEditPage MessageArguments
      case '/ChatDetail':
        MessageArguments msg = arguments as MessageArguments;
        return createRoute(child: ChatDetail(chat: msg));

      case '/ProfileScreen':
        String uid = arguments as String;
        return createRoute(child: ProfileScreen(uid: uid));

      case '/CommentsScreen':
        String postId = arguments as String;
        return createRoute(child: CommentsScreen(postId: postId));

      case '/SocialMediaLinkPage':
        return createRoute(child: const SocialMediaLinkPage());

      case '/PeoplePage':
        return createRoute(child: const PeoplePage());

      case '/AddPostScreen':
        return createRoute(child: const AddPostScreen());

      case '/ProfileEditPage':
        return createRoute(child: const ProfileEditPage());
      case '/AcoountsChartPage':
        return createRoute(child: AcoountsChartPage());

      case '/PostEditPage':
        PostEditArguments post = arguments as PostEditArguments;
        return createRoute(child: PostEditPage(post: post));

      // case '/FollowerPage':
      //   List followList = arguments as List;
      //   return createRoute(child: FollowerList(followList: followList));

      case '/ForgotPasswordPage':
        return createRoute(child: const ForgotPasswordPage());

      case '/SignUpPage':
        return createRoute(child: const SignUpPage());

      case '/LoginPage':
        return createRoute(child: const LoginPage());

      case '/HomePage':
        return createRoute(child: const HomePage());

      case '/Wapper':
        return createRoute(child: const Wapper());

      case '/AccountSetup':
        return createRoute(child: const AccountSetup());

      default:
        // If there is no such named route in the switch statement
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

Route createRoute({required Widget child}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(0.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class MessageArguments {
  final String friendUid;
  final String friendName;
  MessageArguments({
    required this.friendUid,
    required this.friendName,
  });
}

class PostEditArguments {
  final String postId;
  final dynamic p;
  PostEditArguments({required this.postId, required this.p});
}
