import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService{
  final SupabaseClient _supabase = Supabase.instance.client;
//signin with email and password
Future<AuthResponse> signInWithEmailPassword(String email,String password) async{
return await _supabase.auth.signInWithPassword(email:email,password:password);

}
//signup with email and password
Future<AuthResponse> signupWithEmailPassword(String email, String password)async{
return await _supabase.auth.signUp(email:email,password:password);
}
//signout
Future<void> signOut() async{
  await _supabase.auth.signOut();
}
//get user email
String? getCurrentUserEmail(){
final session =_supabase.auth.currentSession;
final user=session?.user;
return user?.email;
}


}
