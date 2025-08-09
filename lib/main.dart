import 'package:cyber_mobile/account/business/interactors/account_interactor.dart';
import 'package:cyber_mobile/account/ui/frameworks/account_service_network.dart';
import 'package:cyber_mobile/routers.dart';
import 'package:cyber_mobile/service/business/interactors/document_interactor.dart';
import 'package:cyber_mobile/service/ui/frameworks/document_service_network.dart';
import 'package:cyber_mobile/service/ui/templates/theme_manager.dart';
import 'package:cyber_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_helper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔹 Initialisation base de données SQLite
  await DatabaseHelper.instance.database;

  final accountService = AccountServiceNetwork();
  final documentService = DocumentServiceNetwork();

  final accountInteractor = AccountInteractor.build(accountService);
  final documentInteractor = DocumentInteractor.build(documentService);

  //
  runApp(
    ProviderScope(
      overrides: [
        // Override the account service provider with the network implementation
        accountInteractorProvider.overrideWithValue(accountInteractor),
        documentInteractorProvider.overrideWithValue(documentInteractor),
      ],
      child: MyApp(sessionToken: ''),
    ),
  );
}

final themeManager = ThemeManager();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.sessionToken});
  final String? sessionToken;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

//final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Cyber Mobile +',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeManager.themeMode,
          routerConfig: ref.watch(routerProvider),
        );
      },
    );
  }
}
