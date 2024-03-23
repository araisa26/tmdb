import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/domain/blocs/auth_bloc.dart';
import 'package:themoviedb/ui/auth/auth_view_cubit.dart';
import 'package:themoviedb/resources/icons/app_bar_icons_svg.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewCubit, AuthCubitState>(
        listener: (context, state) {
          if (state is AuthProgressScreenState) {
            MainNavigation.resetNavigation(context);
          }
        },
        child: Provider(
          create: (create) => DataAuth(),
          child: Scaffold(
            appBar: AppBar(
              actions: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: SvgPicture.string(
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
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
          ),
        ));
  }
}

class FormWidget extends StatelessWidget {
  const FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authDataStorage = context.read<DataAuth>();
    final cubit = context.read<AuthViewCubit>();
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
          onChanged: (text) => authDataStorage.login = text,
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
          onChanged: (text) => authDataStorage.password = text,
          controller: cubit.state.password,
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
    final authDataStorage = context.read<DataAuth>();

    final bloc = context.watch<AuthViewCubit>();
    return ElevatedButton(
      onPressed: () {
        bloc.auth(
            login: authDataStorage.login, password: authDataStorage.password);
      },
      child: bloc.state.canAuthStart == true
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

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget();
  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewCubit c) {
      final state = c.state;
      return state is AuthFailureScreenState ? state.errorText : null;
    });
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class ResetPasswordButton extends StatelessWidget {
  const ResetPasswordButton({super.key});
  @override
  Widget build(BuildContext context) {
    final bloc = context.select((AuthViewCubit bloc) {
      return bloc;
    });

    return TextButton(
        onPressed: () => bloc.authBloc.add(AuthLogoutEvent()),
        child: const Text('Reset'));
  }
}
