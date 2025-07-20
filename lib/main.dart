import 'package:cyber_mobile/account/business/interactors/account_interactor.dart';
import 'package:cyber_mobile/account/ui/frameworks/account_service_network.dart';
import 'package:cyber_mobile/routers.dart';
import 'package:cyber_mobile/service/business/interactors/document_interactor.dart';
import 'package:cyber_mobile/service/ui/frameworks/document_service_network.dart';
import 'package:cyber_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.sessionToken});
  final String? sessionToken;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Cyber Mobile +',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
