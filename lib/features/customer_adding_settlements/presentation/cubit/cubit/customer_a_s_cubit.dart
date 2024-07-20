import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/data/models/customer_adding_settlement.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/data/repositories/customer_a_s_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_a_s_state.dart';

class CustomerAddingSettlementCubit
    extends Cubit<CustomerAddingSettlementState> {
  CustomerAddingSettlementCubit() : super(CustomerAddingSettlementInitial());

  final CustomerAddingSettlementRepository repository =
      CustomerAddingSettlementRepository();
// add CustomerAddingSettlement
  Future<void> addCustomerAddingSettlement(
      CustomerAddingSettlement customerAddingSettlement) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      int userId = await SharedPrefsService().getSelectedUserId();
      customerAddingSettlement.userId = userId;

      emit(CustomerAddingSettlementLoading());
      customerAddingSettlement.brancheId = brancheId;

      customerAddingSettlement = await repository
          .addcustomerAddingSettlement(customerAddingSettlement);
      emit(CustomerAddingSettlementLoaded(
          customerAddingSettlement: customerAddingSettlement));
    } catch (e) {
      emit(const CustomerAddingSettlementError(
          'Failed To Load Data From System'));
    }
  }

// edit CustomerAddingSettlement
  Future<void> editCustomerAddingSettlement(
      CustomerAddingSettlement customerAddingSettlement) async {
    try {
      int userId = await SharedPrefsService().getSelectedUserId();

      customerAddingSettlement.userId = userId;

      emit(CustomerAddingSettlementLoading());
      customerAddingSettlement = await repository
          .editcustomerAddingSettlement(customerAddingSettlement);
      emit(CustomerAddingSettlementUpdatedSuccess());
    } catch (e) {
      emit(const CustomerAddingSettlementUpdatedError('Failed To Edit'));
    }
  }

  // delete
  Future<void> deleteCustomerAddingSettlement(int id) async {
    try {
      emit(CustomerAddingSettlementLoading());
      bool message = await repository.deleteCustomerAddingSettlement(id);
      if (message) {
        emit(CustomerAddingSettlementDeleted());
      }
    } catch (e) {
      emit(const CustomerAddingSettlementError('Failed To Delete '));
    }
  }

  // get by id
  Future<void> getById(int id) async {
    try {
      emit(CustomerAddingSettlementLoading());
      var customerAddingSettlement = await repository.getById(id);
      emit(CustomerAddingSettlementLoaded(
          customerAddingSettlement: customerAddingSettlement));
    } catch (e) {
      emit(const CustomerAddingSettlementError(
          'Failed To load CustomerAddingSettlement '));
    }
  }

  // get All
  Future<void> getAll() async {
    try {
      // int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(CustomerAddingSettlementLoading());
      var customerAddingSettlements = await repository.GetAll();
      emit(CustomerAddingSettlementsListLoaded(
          items: customerAddingSettlements,
          filteredItems: customerAddingSettlements));
    } catch (e) {
      emit(const CustomerAddingSettlementError(
          'Failed To load CustomerAddingSettlements'));
    }
  }

  // get for branche
  Future<void> getAllForbranche() async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(CustomerAddingSettlementLoading());
      var customerAddingSettlements =
          await repository.GetAllForBranche(brancheId);
      emit(CustomerAddingSettlementsListLoaded(
          items: customerAddingSettlements,
          filteredItems: customerAddingSettlements));
    } catch (e) {
      emit(const CustomerAddingSettlementError(
          'Failed To load CustomerAddingSettlements'));
    }
  }

  void updateCustomerAddingSettlementField(
      CustomerAddingSettlement CustomerAddingSettlement) {
    emit(CustomerAddingSettlementUpdated(
        customerAddingSettlement: CustomerAddingSettlement));
  }

  void filterItems(String query) {
    if (state is CustomerAddingSettlementsListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as CustomerAddingSettlementsListLoaded;

        emit(CustomerAddingSettlementsListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as CustomerAddingSettlementsListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.customerName!.toLowerCase().contains(query.toLowerCase());
        }).toList();
        emit(CustomerAddingSettlementsListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const CustomerAddingSettlementError('فشل تحميل'));
    }
  }

  /* void filterItemsByName(String query) {
    if (state is CustomerAddingSettlementsListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as CustomerAddingSettlementsListLoaded;

        emit(CustomerAddingSettlementsListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as CustomerAddingSettlementsListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.customerName!.toLowerCase().contains(query);
        }).toList();
        emit(CustomerAddingSettlementsListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const CustomerAddingSettlementError('فشل تحميل'));
    }
  }*/
}
