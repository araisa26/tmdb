import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/ui/auth/auth_model.dart';
import 'package:themoviedb/resources/icons/app_bar_icons_svg.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: SvgPicture.string(
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  AppBarIsonsSvg.themoviedbIcon,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Column(
          children: [
            SizedBox(
              height: 30,
            ),
            FormWidget(),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                AuthButtonWidget(),
                SizedBox(
                  width: 10,
                ),
                ResetPasswordButton(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  const FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        const Text(
          "Username",
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 5),
        TextField(
          controller: model.loginTextController,
          obscureText: false,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: (16), color: Colors.black),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Password",
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 5),
        TextField(
          controller: model.passwordTextController,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: (16), color: Colors.black),
        ),
      ],
    );
  }
}

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthModel>();
    return ElevatedButton(
      onPressed: () {
        model.auth(context);
      },
      child: model.canAuthStart
          ? const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Text('Sign'),
    );
  }
}

class ResetPasswordButton extends StatelessWidget {
  const ResetPasswordButton({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthModel>();
    return TextButton(
        onPressed: () => model.resert(), child: const Text('Reset'));
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget();
  @override
  Widget build(BuildContext context) {
    final errorMessage = context.watch<AuthModel>().errorText;
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
