import 'package:frames/app/data/providers/firebase_provider.dart';
import 'package:frames/app/data/providers/session_db.dart';
import 'package:frames/app/data/providers/storage_provider.dart';
import 'package:frames/app/modules/authentication/repository.dart';
import 'package:frames/app/routes/routes.dart';
import 'package:frames/app/widgets/common_alerts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/providers/models/user_model.dart';

class AuthController extends GetxController {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmPasswordTextEditingController = TextEditingController();
  bool isLoginButtonEnabled = false;
  bool isRegisterButtonEnabled = false;

  late final AuthRepositry _authRepositry;

  bool isLoading = false;

  @override
  void onInit() {
    _authRepositry = AuthRepositry(firebaseProvider: FirebaseProvider());
    super.onInit();
  }

  void clearTextEditingController() {
    nameTextEditingController.clear();
    emailTextEditingController.clear();
    passwordTextEditingController.clear();
    confirmPasswordTextEditingController.clear();
  }

  void loginWithGoogle() async {
    CommonAlerts.showLoadingDialog();
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final GoogleSignInAccount? user = await googleSignIn.signIn();
      final GoogleSignInAuthentication auth = await user!.authentication;
      final UserCredential? userCredential =
          await _authRepositry.signInWithGoogle(auth);

      if (userCredential != null) {
        UserModel userModel = UserModel(
          email: userCredential.user!.email,
          displayName: userCredential.user!.displayName,
          phoneNumber: userCredential.user!.phoneNumber,
          photoUrl: userCredential.user!.photoURL,
          uid: userCredential.user!.uid,
          emailVerified: userCredential.user!.emailVerified,
        );

        if (userCredential.user != null) {
          final token = await userCredential.user!.getIdToken();
          if (token == null) return;
          SessionDB().setAuthStatus(true);
          SessionDB().setToken(token);
          StorageProvider().writeUserModel(userModel);
          Get.back();
          Get.offAndToNamed(AppRoute.appBase);
        }
      }
    } on FirebaseAuthException catch (e) {
      _firebaseExceptionShow(e);
      Get.back();
    } on PlatformException catch (e) {
      Get.back();
      CommonAlerts.showErrorSnack(message: e.code);
    } catch (e) {
      Get.back();
      CommonAlerts.showErrorSnack();
    }
  }

  void signUp() async {
    if (signUpFormKey.currentState!.validate()) {
      try {
        UserCredential? userCredential = await _authRepositry
            .createCredentialWithEmail(
                emailTextEditingController.text.trim(),
                nameTextEditingController.text,
                passwordTextEditingController.text.trim())
            .whenComplete(() {
          Get.defaultDialog(
              title: "Sign Up Successfull",
              content: Center(
                child: Column(
                  children: [
                    const Text(
                      "Click on ok and go to login page and use your credentials for Login",
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      child: const Text("Ok"),
                      onPressed: () {
                        Get.offAllNamed(AppRoute.loginScreen);
                      },
                    ),
                  ],
                ),
              ));
        });

        if (userCredential != null) {
          if (userCredential.user!.emailVerified) {
            userCredential.user!.sendEmailVerification();
          }
        }
      } on FirebaseAuthException catch (e) {
        _firebaseExceptionShow(e);
      } catch (e) {
        CommonAlerts.showErrorSnack();
      }
    }
  }

  void login() async {
    if (loginFormKey.currentState!.validate()) {
      try {
        UserCredential? userCredential =
            await _authRepositry.signInWithEmailPassword(
                emailTextEditingController.text.trim(),
                passwordTextEditingController.text.trim());
        if (userCredential != null) {
          UserModel userModel = UserModel(
            email: userCredential.user!.email,
            displayName: userCredential.user!.displayName ?? "",
            phoneNumber: userCredential.user!.phoneNumber ?? "",
            photoUrl: userCredential.user!.photoURL ?? "",
            uid: userCredential.user!.uid,
            emailVerified: userCredential.user!.emailVerified,
          );
          if (userCredential.user != null) {
            final token = await userCredential.user!.getIdToken();
            if (token == null) return;
            SessionDB().setAuthStatus(true);
            SessionDB().setToken(token);
            StorageProvider().writeUserModel(userModel);
            Get.offAndToNamed(AppRoute.appBase);
          }
        }
      } on FirebaseAuthException catch (e) {
        _firebaseExceptionShow(e);
      } catch (e) {
        CommonAlerts.showErrorSnack();
      }
    }
  }

  void updatePasswordVisiblity() {
    isPasswordVisible = !isPasswordVisible;
    update(["password"]);
  }

  void updateConfirmPasswordVisiblity() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    update(["password2"]);
  }

  _firebaseExceptionShow(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      CommonAlerts.showErrorSnack(
          message: "The password provided is too weak.");
    } else if (e.code == 'email-already-in-use') {
      CommonAlerts.showErrorSnack(
          message: "The account already exists for that email.");
    } else if (e.code == 'operation-not-allowed') {
      CommonAlerts.showErrorSnack(
          message: "There is a problem with auth service config");
    } else if (e.code == "network-request-failed") {
      CommonAlerts.showErrorSnack(
          message: "It seems your are not connected to Internet");
    } else {
      CommonAlerts.showErrorSnack(message: e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.defaultDialog(
          title: "Password reset email sent successfully",
          content: Column(
            children: [
              Text("Email: $email"),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("OK"))
            ],
          ));
    } catch (error) {
      Get.defaultDialog(
          title: "Some error occured while Password reset",
          content: Column(
            children: [
              Text("Error: $error"),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("OK"))
            ],
          ));
    }
  }
}
