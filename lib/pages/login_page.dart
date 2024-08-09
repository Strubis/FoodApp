import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logic_app/controllers/user_controller.dart';
import 'package:iconly/iconly.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Food App',
                style: TextStyle(
                  fontSize: 25,
                  
                ),
              ),
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Image.asset('assets/food.png'),
              ),
              const Spacer(),
              Text(
                'Peça por aqui o seu lanche favorito!',
                style:
                    textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  'Faça o seu pedido com conforto e esteja pronto para receber cupons e ofertas especiais!',
                  textAlign: TextAlign.center,
                ),
              ),
              /**/
              FilledButton.tonalIcon(
                onPressed: () async {
                  try {
                    final user = await UserController.loginWithGoogle();
                    if (user != null && mounted) {
                      UserController.user = user;

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomePage()));
                    }
                  } on FirebaseAuthException catch (error) {
                    print(error.message);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          error.message ?? "Algo deu errado :(",
                        ),
                      ),
                    );
                  } catch (error) {
                    print(error);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          // error.toString(),
                          'Login é obrigatório!',
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(IconlyLight.login),
                label: const Text("Continue com Google"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
