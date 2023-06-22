import 'dart:convert';

import 'package:docs_clone/models/error_model.dart';
import 'package:docs_clone/models/user.dart';
import 'package:docs_clone/repository/shared_prefereces_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import '../constants/strings.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    sharedRepository: SharedRepository(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final SharedRepository _sharedRepository;

  AuthRepository({required GoogleSignIn googleSignIn, required Client client, required SharedRepository sharedRepository})
      : _googleSignIn = googleSignIn,
        _client = client, _sharedRepository=sharedRepository;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occured', data: null);
    try {
      // final user = await _googleSignIn.signInSilently();
     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
      final credential = GoogleAuthProvider.credential(
         accessToken: googleAuth?.accessToken,
         idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      print(user!.displayName);
      
        final userModel = UserModel(
            name: user.displayName??"",
            email: user.email ??"",
            photoUrl: user.photoURL??"",
            uid: '',
            token: '');

        var res = await _client.post(
          Uri.parse('$uri/api/signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: userModel.toJson(),
        );

        switch (res.statusCode) {
          case 200:
            final newUser = userModel.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            _sharedRepository.setToken(newUser.token);
            break;
        }
      
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _sharedRepository.getToken();

      if (token != null) {
        var res = await _client.get(Uri.parse('$uri/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
        switch (res.statusCode) {
          case 200:
          print(res.body);
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            print(newUser.name);
            error = ErrorModel(error: null, data: newUser);
            print("error: ");
            _sharedRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _sharedRepository.setToken('');
  }
}
