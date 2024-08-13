import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/customer_discount_settlements/data/models/customer_discount_settlement.dart';
import 'package:alfath_stoer_app/features/customer_discount_settlements/data/repositories/customer_d_s_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_a_s_state.dart';

class CustomerDiscountSettlementCubit
    extends Cubit<CustomerDiscountSettlementState> {
  CustomerDiscountSettlementCubit()
      : super(CustomerDiscountSettlementInitial());

  final CustomerDiscountSettlementRepository repository =
      CustomerDiscountSettlementRepository();
// add CustomerDiscountSettlement
  Future<void> addCustomerDiscountSettlement(
      CustomerDiscountSettlement customerDiscountSettlement) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      int userId = await SharedPrefsService().getSelectedUserId();
      customerDiscountSettlement.userId = userId;

      emit(CustomerDiscountSettlementLoading());
      customerDiscountSettlement.brancheId = brancheId;

      customerDiscountSettlement = await repository
          .addCustomerDiscountSettlement(customerDiscountSettlement);
      emit(CustomerDiscountSettlementLoaded(
          customerDiscountSettlement: customerDiscountSettlement));
    } catch (e) {
      emit(const CustomerDiscountSettlementError(
          'Failed To Load Data From System'));
    }
  }

// edit CustomerDiscountSettlement
  Future<void> editCustomerDiscountSettlement(
      CustomerDiscountSettlement customerDiscountSettlement) async {
    try {
      int userId = await SharedPrefsService().getSelectedUserId();

      customerDiscountSettlement.userId = userId;

      emit(CustomerDiscountSettlementLoading());
      customerDiscountSettlement = await repository
          .editCustomerDiscountSettlement(customerDiscountSettlement);
      emit(CustomerDiscountSettlementUpdatedSuccess());
    } catch (e) {
      emit(const CustomerDiscountSettlementUpdatedError('Failed To Edit'));
    }
  }

  // delete
  Future<void> deleteCustomerDiscountSettlement(int id) async {
    try {
      emit(CustomerDiscountSettlementLoading());
      bool message = await repository.deleteCustomerDiscountSettlement(id);
      if (message) {
        emit(CustomerDiscountSettlementDeleted());
      }
    } catch (e) {
      emit(const CustomerDiscountSettlementError('Failed To Delete '));
    }
  }

  // get by id
  Future<void> getById(int id) async {
    try {
      emit(CustomerDiscountSettlementLoading());
      var customerDiscountSettlement = await repository.getById(id);
      emit(CustomerDiscountSettlementLoaded(
          customerDiscountSettlement: customerDiscountSettlement));
    } catch (e) {
      emit(const CustomerDiscountSettlementError(
          'Failed To load CustomerDiscountSettlement '));
    }
  }

  // get for branche
  Future<void> getAllForbranche() async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(CustomerDiscountSettlementLoading());
      var customerDiscountSettlements =
          await repository.getAllForBranche(brancheId);
      emit(CustomerDiscountSettlementsListLoaded(
          items: customerDiscountSettlements,
          filteredItems: customerDiscountSettlements));
    } catch (e) {
      emit(const CustomerDiscountSettlementError(
          'Failed To load CustomerDiscountSettlements'));
    }
  }

  void updateCustomerDiscountSettlementField(
      CustomerDiscountSettlement customerDiscountSettlement) {
    emit(CustomerDiscountSettlementUpdated(
        customerDiscountSettlement: customerDiscountSettlement));
  }

  void filterItems(String query) {
    if (state is CustomerDiscountSettlementsListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as CustomerDiscountSettlementsListLoaded;

        emit(CustomerDiscountSettlementsListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as CustomerDiscountSettlementsListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.customerName!.toLowerCase().contains(query.toLowerCase());
        }).toList();
        emit(CustomerDiscountSettlementsListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const CustomerDiscountSettlementError('فشل تحميل'));
    }
  }

  /* void filterItemsByName(String query) {
    if (state is CustomerDiscountSettlementsListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as CustomerDiscountSettlementsListLoaded;

        emit(CustomerDiscountSettlementsListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as CustomerDiscountSettlementsListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.customerName!.toLowerCase().contains(query);
        }).toList();
        emit(CustomerDiscountSettlementsListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const CustomerDiscountSettlementError('فشل تحميل'));
    }
  }*/
}
