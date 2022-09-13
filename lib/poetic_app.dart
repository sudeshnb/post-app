import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/theme/cubit/theme_cubit.dart';
import 'package:poetic_app/core/utils/dismiss_keyboard.dart';
import 'package:poetic_app/features/providers/user_provider.dart';
import 'package:poetic_app/features/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'core/routes/routes.dart';

class PoeticApp extends StatelessWidget {
  const PoeticApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        ],
        child: LayoutBuilder(
          builder: (context, layout) {
            return OrientationBuilder(
              builder: (context, orientation) {
                SizeOF().init(layout, orientation);

                return DismissKeyboard(
                  child:
                      BlocBuilder<ThemeCubit, bool>(builder: (context, state) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Poetic App',
                      // darkTheme: AppTheme.darkTheme,
                      theme: AppTheme.lightTheme,
                      // themeMode: state ? ThemeMode.dark : ThemeMode.light,
                      onGenerateRoute: (settings) =>
                          RouteGenerator.generateRoute(settings),
                      initialRoute: '/',
                      home: const SplashPage(),
                      // home: ExampleCupertinoDownloadButton(),
                    );
                  }),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
