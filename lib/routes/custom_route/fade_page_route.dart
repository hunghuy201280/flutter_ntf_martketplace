import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {
  final Widget page;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);
  FadePageRoute({RouteSettings? settings, required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          settings: settings,
        );
}
