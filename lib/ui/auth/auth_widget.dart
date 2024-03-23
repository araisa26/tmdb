import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:themoviedb/library/provider.dart';
import 'package:themoviedb/ui/auth/auth_model.dart';
import 'package:themoviedb/ui/theme/app_bar_icons_svg.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
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
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  AppBarIsonsSvg.themoviedbIcon,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                FormWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  FormWidget({super.key});
  final textsyle = const TextStyle(fontSize: (16), color: Colors.black);
  final textfieldDecoration = const InputDecoration(
    border: OutlineInputBorder(),
  );

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<AuthModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ErrorMessageWidget(),
        const Text(
          "Username",
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 5),
        TextField(
          controller: model?.loginTextController,
          obscureText: false,
          decoration: textfieldDecoration,
          style: textsyle,
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
          controller: model?.passwordTextController,
          obscureText: true,
          decoration: textfieldDecoration,
          style: textsyle,
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            _AuthButtonWidget(),
            SizedBox(
              width: 10,
            ),
            _ResetPasswordButton(),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AuthModel>(context);
    return ElevatedButton(
      onPressed: () {
        model.auth(context);
      },
      child: model!.canAuthStart
          ? SizedBox(
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

class _ResetPasswordButton extends StatelessWidget {
  const _ResetPasswordButton({super.key});
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<AuthModel>(context);
    final onPressed = () => {
          model?.loginTextController.text = "",
          model?.passwordTextController.text = "",
          model?.resertPassword(),
        };
    return TextButton(onPressed: onPressed, child: const Text('Reset'));
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final errorMessage = NotifierProvider.watch<AuthModel>(context)?.errorText;
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
