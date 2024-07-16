import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logic_app/controllers/user_controller.dart';
import 'package:logic_app/firebase_options.dart';
import 'package:logic_app/pages/home_page.dart';
import 'package:logic_app/pages/login_page.dart';
import 'package:logic_app/utils/create_text_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(
        context, "Montserrat Alternates", "Montserrat Alternates");
    // MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 219, 164, 11),
        textTheme: textTheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 219, 164, 11),
        textTheme: GoogleFonts.montserratAlternatesTextTheme(Typography.englishLike2014),
        // textTheme: textTheme,
        brightness: Brightness.dark,
      ),
      home: UserController.user != null ? const HomePage() : const LoginPage(),
    );
  }
}
