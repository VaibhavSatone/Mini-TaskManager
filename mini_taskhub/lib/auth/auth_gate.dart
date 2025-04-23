import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*
if authenticated -> home page
if unauthenticated -> login
*/
class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    //listen to auth state changes
    return StreamBuilder(stream: Supabase.instance.client.auth.onAuthStateChange, 
    //build appropriate page based on auth state
    builder: (context,snapshot){
      if(snapshot.connectionState ==ConnectionState.waiting){
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    
    //check if there is a valid session currently
    final session =snapshot.hasData ? snapshot.data!.session : null;
    if (session!=null){
      return Text('data');
    } else{
      return Text('1');
    }
    });
  }
}