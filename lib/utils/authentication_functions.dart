import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';

String tempVerificationId = '';
FirebaseAuth auth = FirebaseAuth.instance;

void requestOtp(phoneNumber) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await auth.verifyPhoneNumber(
    phoneNumber: "+91$phoneNumber",
    verificationCompleted: (PhoneAuthCredential credential) async {},
    verificationFailed: (FirebaseAuthException e) {},
    codeSent: (String verificationId, int? resendToken) {
      tempVerificationId = verificationId;
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

Future<bool> verifyOtp(String otp) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: tempVerificationId, smsCode: otp);
  try {
    UserCredential _ = await auth.signInWithCredential(credential);
    return true;
  } catch (error) {
    return false;
  }
}

void logOutFromFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth.signOut().then((value) {
    print("User Signed Out from Firebase");
  });
  await GoogleSignIn().signOut();
}

Future<bool> signInWithGoogle() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
  if (gUser != null) {
    final GoogleSignInAuthentication gAuth = await gUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    UserCredential _ = await auth.signInWithCredential(credential);
    return true;
  } else {
    return false;
  }
}
