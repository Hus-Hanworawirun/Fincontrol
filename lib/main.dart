import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'data/repositories/auth_repository.dart';
import 'view/navigationbar/bottom_navigation_bar.dart';
import 'view/splash/splash_page.dart';
import 'core/theme/app_theme.dart';
import 'bloc/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  final authRepository = AuthRepository();
  final isLoggedIn = await authRepository.isLoggedIn();

  runApp(MyApp(authRepository: authRepository, isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final bool isLoggedIn;

  const MyApp({super.key, required this.authRepository, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => AuthBloc(authRepository: authRepository)),
        BlocProvider(create: (context) => TransactionBloc(transactionRepository: TransactionRepository())..add(LoadTransactions(''))),
        BlocProvider(create: (context) => PortfolioBloc(portfolioRepository: PortfolioRepository())..add(LoadPortfolios(''))),
        BlocProvider(create: (context) => AssetBloc(assetRepository: AssetRepository(), marketApiRepository: MarketApiRepository())..add(const LoadAssets())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'FinControl',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: isLoggedIn ? const MainNavigationShell() : const GetStartedView(),
          );
        },
      ),
    );
  }
}
