import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RouteErrorPage extends StatelessWidget {
  final String error;
  const RouteErrorPage({super.key, required this.error});

  static Route<dynamic> routeArgumentsError() =>
      routeError(error: 'Invalid passed arguments');

  static Route<dynamic> routeError(
          {String error = 'Unknown route exception'}) =>
      MaterialPageRoute(builder: (context) => RouteErrorPage(error: error));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Route Error",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.red),
              ),
              const Gap(20),
              Text(
                error,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
