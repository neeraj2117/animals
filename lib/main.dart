import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:straybud/providers/user_provider.dart';
import 'package:straybud/responsive/mobile_screen_layout.dart';
import 'package:straybud/responsive/responsive_layout.dart';
import 'package:straybud/responsive/web_screen_layout.dart';
import 'package:straybud/screens/login_screen.dart';
import 'package:straybud/utils/colors.dart';
import 'package:wiredash/wiredash.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC-z0Kb9mPix2jAxJk90hyrxprCLnvfss8",
          appId: "1:187536621091:web:666f2e2cf304e1b7b33b96",
          messagingSenderId: "187536621091",
          projectId: "strayss-dd97c",
          storageBucket: 'strayss-dd97c.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  FlutterEmailSender();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      projectId: 'feedback-07ybc3a',
      secret: '4phExBHOHgzs-fzINjnANBsvvng2H9m9',
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'StrayBud',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
