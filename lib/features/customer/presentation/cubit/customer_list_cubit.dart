import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/customer/data/repositories/customer_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/customer/data/models/customer_model.dart';

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
        return x.brancheId == brancheId;
      }).toList();

      emit(CustomerSupplierListLoaded(items: item2, filteredItems: item2));
    } catch (e) {
      emit(const CustomerSupplierListError('Failed to load data'));
    }
  }

  Future<void> add(CustomerModel customer) async {
    try {
      emit(CustomerSupplierListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      customer.brancheId = brancheId;
      print('id ' + customer.id.toString());
      print('name ' + customer.name!);
      print('adress  ' + customer.adress!);
      print('startAccount ' + customer.startAccount.toString());
      print('customerTypeId  ' + customer.customerTypeId.toString());

      final CustomerModel mycus = await repository.addCustomer(customer);
      final currentState = state;
      if (currentState is CustomerSupplierListLoaded) {
        final updatedItems = List<CustomerModel>.from(currentState.items)
          ..add(mycus);
        emit(CustomerSupplierListLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(CustomerSupplierLoaded(customer: mycus));
    } catch (e) {
      emit(const CustomerSupplierListError('Failed to add'));
    }
  }

  Future<void> edit(CustomerModel customer) async {
    try {
      print(customer.name);
      final CustomerModel mycus = await repository.editCustomer(customer);
      final currentState = state;
      if (currentState is CustomerSupplierListLoaded) {
        var updatedItems = List<CustomerModel>.from(currentState.items)
          ..remove(customer);
        updatedItems = List<CustomerModel>.from(currentState.items)..add(mycus);

        emit(CustomerSupplierListLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(CustomerSupplierLoaded(customer: mycus));
    } catch (e) {
      emit(const CustomerSupplierListError('Failed to add'));
    }
  }

  void updateCustomer(CustomerModel updatedCustomer) {
    if (state is CustomerSupplierListLoaded) {
      final currentState = state as CustomerSupplierListLoaded;
      final updatedItems = currentState.items.map((item) {
        return item.id == updatedCustomer.id ? updatedCustomer : item;
      }).toList();
      final filteredItems = updatedItems.where((item) {
        return item.name!
            .toLowerCase()
            .contains(updatedCustomer.name!.toLowerCase());
      }).toList();

      emit(CustomerSupplierListLoaded(
          items: updatedItems, filteredItems: filteredItems));
    }
  }

  void filterItems(String query) {
    if (state is CustomerSupplierListLoaded) {
      final loadedState = state as CustomerSupplierListLoaded;
      final filteredItems = loadedState.items.where((item) {
        return item.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(CustomerSupplierListLoaded(
          items: loadedState.items, filteredItems: filteredItems));
    }
  }
}
