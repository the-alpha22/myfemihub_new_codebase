import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/constants/firebase.dart';
import 'package:bridge_ai/models/user.dart';
import 'package:bridge_ai/pages/authentication/login.dart';
import 'package:bridge_ai/waiting.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  bool isLoggedIn = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController(text: "+256");
  TextEditingController channelid = TextEditingController();
  String usersCollection = "users";
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> userModel = Rxn<UserModel>();
  final currentRoute = Get.currentRoute;

  @override
  void onReady() async {
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);

    firebaseUser.bindStream(user);

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  handleAuthChanged(_firebaseUser) async {
    //get user data from firestore
    if (auth.currentUser != null) {
      userModel.bindStream(streamFirestoreUser());
    }

    if (auth.currentUser == null) {
      print('Send to signin');
      Get.offAllNamed("/onboarding");
    } else {
      isLoggedIn = true;
      Get.offAllNamed("/redirect");
    }
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => auth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => auth.authStateChanges();

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamFirestoreUser() {
    print('streamFirestoreUser()');

    return _db
        .collection(usersCollection)
        .doc(firebaseUser.value!.uid)
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot.data()!));
  }

  //get the firestore user from the firestore collection
  Future<UserModel> getFirestoreUser() {
    return _db
        .collection(usersCollection)
        .doc(firebaseUser.value!.uid)
        .get()
        .then(
            (documentSnapshot) => UserModel.fromMap(documentSnapshot.data()!));
  }

  void signIn(BuildContext context) async {
    showLoading(context);
    try {
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        _clearControllers();
        dismissLoadingWidget();
        notificationPrompt.showNotification(
            flutterLocalNotificationsPlugin,
            "Hey there 🥰",
            "Welcome back to femihub",
            "login",
            "login",
            1,
            "/home");
        isLoggedIn = true;
      });
    } catch (e) {
      debugPrint(e.toString());
      dismissLoadingWidget();
      if (e.toString() ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        Fluttertoast.showToast(
            msg: "Looks like you entered a wrong password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.toString() ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        Fluttertoast.showToast(
            msg: "It seems you don't have an account",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Looks like you are offline",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  signUp(BuildContext context, String stage) async {
    showLoading(context);
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        String _userId = result.user!.uid;
        _addUserToFirestore(_userId, stage);
        sendEmail(
            "${name.text.trim().capitalize}",
            email.text.trim(),
            "Congratulations on creating an account with bridge_ai! We're so excited to have you on board.\n\nbridge_ai is a comprehensive mobile application designed to support and empower women throughout their journey of pregnancy and motherhood. We offer a range of features and resources to ensure a smooth and healthy pregnancy experience, personalized care, and access to expert healthcare professionals.\n\nWe're so glad you're here!",
            "Welcome to bridge_ai");
        _clearControllers();
        dismissLoadingWidget();
        notificationPrompt.showNotification(
            flutterLocalNotificationsPlugin,
            "Hey ${name.text.trim().capitalize}",
            "Welcome to bridge_ai Community🥰",
            "signup",
            "signup",
            1,
            "/home");
        isLoggedIn = true;
      });
    } catch (e) {
      debugPrint(e.toString());
      dismissLoadingWidget();
      if (e.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        Fluttertoast.showToast(
            msg: "The email address already has an account with us",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Seems you are offline",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
  /////////////////////////////////////////////
  ///with google
  ///
  ///
  checkEmailAvailability(String emailAddress) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: emailAddress)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  checkAccountVerification(String? emailAddress, String? phoneNumber) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: emailAddress)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  signInWithGoogle(BuildContext context) async {
    try {
      print("\n=========Starting Google Sign in Process=============\n");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print("\n=========Starting Google Sign in Google Auth=============\n");

      if (googleUser == null) {
        // If the sign-in process was aborted (user canceled the flow)
        print("Sign-in process was canceled by the user.");
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      print("\n=========Starting Google Sign in Credentials=============\n");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print("\n=========Credential: ${credential}=============\n");
      print("\n=========${googleUser.email}=============\n");

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((result) async {
        bool oldUser = await checkEmailAvailability(googleUser.email);
        if (!oldUser) {
          String _userId = result.user!.uid;
          name.text = (googleUser.displayName != null
              ? googleUser.displayName
                  : googleUser.email.replaceAll("@gmail.com", "")) ?? "";
          email.text = googleUser.email;
          phone.text = result.user!.phoneNumber ?? "";
          _addUserToFirestore(_userId, 'Not Yet Pregnant');
          _clearControllers();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Account Created Successfully",
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Welcome Back",
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        }
      });
    } on Exception catch (e) {
      // TODO
      print('\n=================exception $e============\n');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "${e.toString()}",
        style: GoogleFonts.montserrat(
          fontSize: 12,
          color: Colors.white,
        ),
      )));
    }
  }

signInWithApple(BuildContext context) async {
    try {
      String sha256ofString(String input) {
        final bytes = utf8.encode(input); // Convert input string to bytes
        final digest = sha256.convert(bytes); // Generate SHA-256 hash
        return digest.toString(); // Convert hash to hexadecimal string
      }

      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      print("\n=========Retrieving Apple Sign in Credentials=============\n");
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'obtek.mymedikoz.app',
          redirectUri: Uri.parse(
            'https://mymedikoz-app.firebaseapp.com/__/auth/handler',
          ),
        ),
      );
      print("\n=========Starting Apple Sign in=============\n");

      if (appleCredential.authorizationCode.isEmpty) {
        // If the sign-in process was aborted (user canceled the flow)
        print("Sign-in process was canceled by the user.");
        return;
      }
      print(
        "\n=========Starting Apple Sign in Credentials OAuth=============\n",
      );

      final outhCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(outhCredential).then((
        result,
      ) async {
        bool oldUser = await checkEmailAvailability(
          appleCredential.email ?? "",
        );
        if (!oldUser) {
          String _userId = result.user!.uid;
          name.text =
              (appleCredential.givenName != null
                  ? appleCredential.givenName
                  : result.user!.displayName != null
                  ? result.user!.displayName!.split(" ").first
                  : (appleCredential.email ?? "")
                      .replaceAll("@gmail.com", "")
                      .replaceAll("@icloud.com", "")) ??
              "";
          email.text = appleCredential.email ?? "";
          phone.text = result.user!.phoneNumber ?? "";
          _addUserToFirestore(_userId, 'Not Yet Pregnant');
          _clearControllers();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Account Created Successfully",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Welcome Back",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
      });
    } on Exception catch (e) {
      // TODO
      print('\n=================exception $e============\n');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${e.toString()}",
            style: GoogleFonts.quicksand(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    }
  }


  void resetpassword(BuildContext context) async {
    showLoading(context);
    try {
      await auth
          .sendPasswordResetEmail(email: email.text.trim())
          .then((result) {
        dismissLoadingWidget();
        Fluttertoast.showToast(
            msg: "Reset link has been sent to your email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black.withOpacity(0.7),
            textColor: Colors.white,
            fontSize: 16.0);
        Get.offAll(() => Login());
      });
    } catch (e) {
      debugPrint(e.toString());
      dismissLoadingWidget();
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black.withOpacity(0.7),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void signOut() async {
    auth.signOut();
  }

  void signInWithEmailandLink() async {
    await auth
        .sendSignInLinkToEmail(
            email: email.text.trim(),
            actionCodeSettings: ActionCodeSettings(
              url: "https://bridgeai.page.link/",
              handleCodeInApp: true,
              androidPackageName: "obtek.technologies.bridge_ai",
              androidMinimumVersion: "1",
            ))
        .then((value) {
      print("email sent");
    });
  }

  didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data!.link;

      if (deepLink != null) {
        handleLink(deepLink);
        print(deepLink.userInfo);
      }
    } catch (e) {
      print(e);
    }
  }

  void handleLink(Uri? link) async {
    if (link != null) {
      print(email.text.trim());
      final UserCredential? user =
          await FirebaseAuth.instance.signInWithEmailLink(
        email: email.text.trim(),
        emailLink: link.toString(),
      );
      if (user != null) {
        print(user.credential);
      }
    } else {
      print("link is null");
    }
  }

  void sendEmail(
      String name, String email, String content, String subject) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': "service_hhthruv",
          'template_id': "template_7qe3535",
          'user_id': "XUOcEJp3cEew5NNai",
          'accessToken': "LyMrwY7O8bovubs4_ztTU",
          'template_params': {
            'subject': subject,
            'to_name': name,
            'to_email': email,
            'message': content
          }
        }));
    return print("${response.statusCode}");
  }

  _addUserToFirestore(String userId, String stage) {
    firebaseFirestore.collection(usersCollection).doc(userId).set({
      "name": name.text.trim(),
      "id": userId,
      "email": email.text.trim(),
      "phone": phone.text.trim(),
      "stage": stage,
      "admin": false,
      "paid": false,
      "nurse": false,
      "report": false,
      "medicalcard": false,
      "assignednurse": "",
      "pic": "",
      "balance": 0,
      "tokens": 0,
      "medications": [],
      "appointments": [],
      "chatids": [],
    });
    Fluttertoast.showToast(
        msg: "Account created successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _clearControllers() {
    name.clear();
    email.clear();
    password.clear();
    phone.clear();
  }

  updateUserData(Map<String, dynamic> data) {
    logger.i("UPDATED");
    firebaseFirestore
        .collection(usersCollection)
        .doc(firebaseUser.value!.uid)
        .update(data);
  }

  Stream<UserModel> listenToUser() => firebaseFirestore
      .collection(usersCollection)
      .doc(firebaseUser.value!.uid)
      .snapshots()
      .map((snapshot) => UserModel.fromSnapshot(snapshot));
}
