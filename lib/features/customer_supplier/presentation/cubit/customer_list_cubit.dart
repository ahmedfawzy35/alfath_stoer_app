import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/models/customer_model.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_repository.dart';

part 'customer_list_state.dart';

class CustomerListCubit extends Cubit<CustomerSupplierListState> {
  final CustomerListRepository repository =
      CustomerListRepository(MyStrings.baseurl);

  CustomerListCubit() : super(CustomerSupplierListInitial());

  Future<void> fetchData() async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      emit(CustomerSupplierListLoading());
      final items = await repository.fetchData();
      var item2 = items.where((x) {
        return x.brancheId == brancheId && x.name != 'عميل نقدي';
      }).toList();

      emit(CustomerSupplierListLoaded(items: item2, filteredItems: item2));
    } catch (e) {
      emit(const CustomerSupplierListError('Failed to load data'));
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
