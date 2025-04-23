import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_taskhub/pages/Login.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  static String routeName = 'Splash';
  static String routePath = '/splash';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF212730),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/Screenshot 2025-04-23 002301.png',
                      width: 86.5,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: AlignmentDirectional.center,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/Screenshot 2025-04-23 002317.png',
                    width: 350,
                    height: MediaQuery.of(context).size.height * 0.35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/Manage your Task with DayTask.png',
                    width: 350,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFED36A),
                  minimumSize: const Size(350, 55),
                ),
                child: Text(
                  "Let's Start",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
