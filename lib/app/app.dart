import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_care_app/dependency_injection.dart';
import 'package:tech_care_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:tech_care_app/features/message_viewer/presentation/bloc/message_viewer_bloc.dart';
import 'package:tech_care_app/features/user_preferences/presentation/bloc/user_preferences_bloc.dart';
import 'app_view.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // blocs

  late final UserPreferencesBloc _userPreferencesBloc;
  late final AuthBloc _authBloc;
  late final MessageViewerBloc _messageViewerBloc;

  @override
  void initState() {
    _userPreferencesBloc = di<UserPreferencesBloc>();
    _messageViewerBloc = di<MessageViewerBloc>();
    _authBloc = di<AuthBloc>();
    _userPreferencesBloc.add(UserPreferencesInitialEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserPreferencesBloc>.value(value: _userPreferencesBloc),
        BlocProvider<MessageViewerBloc>.value(value: _messageViewerBloc),
        BlocProvider<AuthBloc>.value(value: _authBloc),
      ],
      child: const AppView(),
    );
  }
}
