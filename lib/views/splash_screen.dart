import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ntf_marketplace/configs/color_config.dart';
import 'package:flutter_ntf_marketplace/configs/text_config.dart';
import 'package:flutter_ntf_marketplace/generated/l10n.dart';
import 'package:flutter_ntf_marketplace/view_models/splash_bloc/splash/splash_bloc.dart';
import 'package:flutter_ntf_marketplace/views/login/login_screen.dart';
import 'package:flutter_ntf_marketplace/views/onboarding_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';

import '../view_models/auth_bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "/splash";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthBloc _authBloc;
  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(_authBloc),
      child: const Scaffold(
        backgroundColor: AppColors.kColor1,
        body: _BodyScreen(),
      ),
    );
  }
}

class _BodyScreen extends StatefulWidget {
  const _BodyScreen({Key? key}) : super(key: key);

  @override
  __BodyScreenState createState() => __BodyScreenState();
}

class __BodyScreenState extends State<_BodyScreen> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 2000));
      context.read<SplashBloc>().add(const SplashEvent.splashInit());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) => state.when(
        firstRun: (value) {
          if (value) {
            Navigator.pushNamedAndRemoveUntil(
                context, OnboardingScreen.id, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.id, (route) => false);
          }
          return null;
        },
        initial: () {},
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'icon_app',
              child: SvgPicture.asset(
                'assets/icons/icon_app.svg',
                height: 211.w,
                width: 211.w,
              ),
            ),
            SizedBox(
              height: 27.h,
            ),
            Text(
              s.appName,
              style: TextConfigs.kHeader1_9,
            )
          ],
        ),
      ),
    );
  }
}
