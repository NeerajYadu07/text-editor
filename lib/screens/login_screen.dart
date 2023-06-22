import 'package:docs_clone/constants/colors.dart';
import 'package:docs_clone/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';



class LoginScreen extends ConsumerWidget {
  static const String routeName='login-screen';
  const LoginScreen({super.key});


  void signInWithGoogle(WidgetRef ref,BuildContext context) async{
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle();
    if(errorModel.error==null){
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace('/');
    
    }
    
    
    else{
      print(errorModel.error);
      sMessenger.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
        body: Center(
      child: ElevatedButton.icon(
        onPressed: () =>signInWithGoogle(ref,context),
        icon: Image.asset(
          'assets/images/g-logo-2.png',
          height: 20,
        ),
        label: const Text(
          'Sign-in with google',
          style: TextStyle(color: kBlackColor),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 50),
          backgroundColor: kWhiteColor,
        ),
      ),
    ));
  }
}
