import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/transaction/transaction_bloc.dart';
import 'bloc/transaction/transaction_event.dart';
import 'data/repositories/transaction_repository.dart';
import 'bloc/portfolio/portfolio_bloc.dart';
import 'bloc/portfolio/portfolio_event.dart';
import 'data/repositories/portfolio_repository.dart';
import 'bloc/asset/asset_bloc.dart';
import 'bloc/asset/asset_event.dart';
import 'data/repositories/asset_repository.dart';
import 'data/repositories/market_api_repository.dart';
import 'view/navigationbar/bottom_navigation_bar.dart';
import 'view/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => TransactionBloc(transactionRepository: TransactionRepository())..add(LoadTransactions(FirebaseAuth.instance.currentUser?.uid ?? ''))),
        BlocProvider(create: (context) => PortfolioBloc(portfolioRepository: PortfolioRepository())..add(LoadPortfolios(FirebaseAuth.instance.currentUser?.uid ?? ''))),
        BlocProvider(create: (context) => AssetBloc(assetRepository: AssetRepository(), marketApiRepository: MarketApiRepository())..add(const LoadAssets())),
      ],
      child: MaterialApp(
        title: 'FinControl',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If a user is logged in, show the MainNavigationShell
        if (snapshot.hasData) {
          return const MainNavigationShell();
        }
        // Otherwise, show the splash/GetStartedView
        return const GetStartedView();
      },
    );
  }
}
