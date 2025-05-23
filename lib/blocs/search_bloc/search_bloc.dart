import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_manager/blocs/search_bloc/search_event.dart';
import 'package:books_manager/blocs/search_bloc/search_state.dart';
import 'package:books_manager/services/api_service.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService _apiService;

  SearchBloc(this._apiService) : super(SearchInitial()) {
    on<SearchBooks>(_onSearchBooks);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchBooks(
    SearchBooks event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final books = await _apiService.searchBooks(event.query);
      emit(SearchLoaded(books));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
