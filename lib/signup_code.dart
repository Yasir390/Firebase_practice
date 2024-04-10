import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/utils.dart';

class SignupCode {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Utils utils = Utils();

  Future<void> signUpUser(String email, String password, Function(bool isLoading) setLoading) async {
    setLoading(true);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), // Good practice to trim
        password: password.trim(),
      );
      setLoading(false);
      // Handle success (e.g., navigate to another screen)
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      utils.toastMsg(e.message ?? "An error occurred");
    } catch (e) {
      setLoading(false);
      utils.toastMsg("An unexpected error occurred");
    }
  }
}
