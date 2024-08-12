import 'package:app_ui/app_ui.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [EmailAuthProvider()],
      headerBuilder: (context, constraints, shrinkOffset) => const _AppLogo(),
      sideBuilder: (context, constraints) => const _AppLogo(),
      breakpoint: AppScreenSize.desktopBreakpoint,
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppInsets.xLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/deadline.png',
            width: AppInsets.xxLarge,
            height: AppInsets.xxLarge,
          ),
          const SizedBox(height: AppInsets.medium),
          Text(
            AppLocalizations.of(context)!.appName,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}
