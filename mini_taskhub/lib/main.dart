import 'package:flutter/material.dart';
import 'package:mini_taskhub/pages/Splash.dart';
import 'package:mini_taskhub/pages/create_task.dart';
import 'package:mini_taskhub/pages/home.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRpemhsZmZnc2plcHhzZ3ViZXd4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0MDUyNDIsImV4cCI6MjA2MDk4MTI0Mn0._oTuJVZ4Mzy35XyUVrvpRsnWyvBe2gk-NsnMGODiG6A",
    url: "https://tizhlffgsjepxsgubewx.supabase.co", 
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<bool>(
        future: _checkIfUserLoggedIn(),  // Call the function to check login status
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashWidget();  // Show Splash screen while checking login
          } else if (snapshot.hasError) {
            return const SplashWidget();  // In case of error, show splash
          } else {
            return snapshot.data == true ? const HomeScreenWidget() : const SplashWidget();  // Redirect based on login status
          }
        },
      ),
    );
  }

  Future<bool> _checkIfUserLoggedIn() async {
    final user = Supabase.instance.client.auth.currentUser;
    return user != null;  // Return true if user is logged in
  }
}
