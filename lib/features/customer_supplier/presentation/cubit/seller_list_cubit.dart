import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/seller_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_list_state.dart';
import 'package:bloc/bloc.dart';

class SellerListCubit extends Cubit<SellerListState> {
  final SellerListRepository repository;

  SellerListCubit(this.repository) : super(SellerListInitial());

  void fetchData(String type) async {
    try {
      emit(SellerListLoading());
      final items = await repository.fetchData(type);
      emit(SellerListLoaded(items: items, filteredItems: items));
    } catch (e) {
      emit(SellerListError('Failed to load data: $e'));
    }
  }

  void filterItems(String query) {
    if (state is SellerListLoaded) {
      final loadedState = state as SellerListLoaded;
      final filteredItems = loadedState.items.where((item) {
        return item.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(SellerListLoaded(
          items: loadedState.items, filteredItems: filteredItems));
    }
  }
}
