import 'package:alfath_stoer_app/features/customer_supplier/data/models/customer_supplier_model.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_list_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_supplier_list_state.dart';

class CustomerSupplierListCubit extends Cubit<CustomerSupplierListState> {
  final CustomerSupplierListRepository repository;

  CustomerSupplierListCubit(this.repository)
      : super(CustomerSupplierListInitial());

  Future<void> fetchData(String type) async {
    try {
      emit(CustomerSupplierListLoading());
      final items = await repository.fetchData(type);
      emit(CustomerSupplierListLoaded(items: items, filteredItems: items));
    } catch (e) {
      emit(CustomerSupplierListError('Failed to load data'));
    }
  }

  void filterItems(String query) {
    if (state is CustomerSupplierListLoaded) {
      final loadedState = state as CustomerSupplierListLoaded;
      final filteredItems = loadedState.items.where((item) {
        return item.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(CustomerSupplierListLoaded(
          items: loadedState.items, filteredItems: filteredItems));
    }
  }
}
