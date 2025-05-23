import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_manager/pages/home.page.dart';
import 'package:books_manager/blocs/book_bloc/book_bloc.dart';
import 'package:books_manager/blocs/book_bloc/book_event.dart';
import 'package:books_manager/blocs/search_bloc/search_bloc.dart';
import 'package:books_manager/services/api_service.dart';
import 'package:books_manager/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService();
  await databaseService.init();

  runApp(MyApp(databaseService: databaseService, apiService: ApiService()));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;
  final ApiService apiService;

  const MyApp({
    super.key,
    required this.databaseService,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BookBloc(databaseService)..add(LoadBooks()),
        ),
        BlocProvider(create: (context) => SearchBloc(apiService)),
      ],
      child: MaterialApp(
        title: 'Book Finder',
        theme: ThemeData(
          primarySwatch:
              Colors.blueGrey, // You can choose a suitable theme color
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(), // Set HomePage as the initial screen
      ),
    );
  }
}
