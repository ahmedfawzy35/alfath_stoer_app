import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/data/models/cashin_from_customer_model.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/data/repositories/cashin_from_customer_repository.dart';
import 'package:alfath_stoer_app/features/cashin_from_customer/presentation/cubit/cashin_from_customer_state.dart';
import 'package:bloc/bloc.dart';

class CashInFromCustomerCubit extends Cubit<CashInFromCustomerState> {
  final CashInFromCustomerRepository repository =
      CashInFromCustomerRepository();

  CashInFromCustomerCubit() : super(CashInFromCustomerInitial());

  void getAllForBranche() async {
    try {
      emit(CashInFromCustomerLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      final items = await repository.getAllForBranche(brancheId);

      emit(CashInFromCustomerLoaded(items: items, filteredItems: items));
    } catch (e) {
      emit(CashInFromCustomerError('Failed to load data: $e'));
    }
  }

  void getByIdCashInFromCustomer(int id) async {
    try {
      emit(CashInFromCustomerLoading());

      final item = await repository.getByIdCashInFromCustomer(id);

      emit(CashInFromCustomerGet(item: item));
    } catch (e) {
      emit(CashInFromCustomerError('Failed to load data: $e'));
    }
  }

  Future<void> addCashInFromCustomer(CashInFromCustomer entity) async {
    try {
      emit(CashInFromCustomerLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      int userId = await SharedPrefsService().getSelectedUserId();

      entity.brancheId = brancheId;
      entity.userId = userId;

      // print('id ' + entity.id.toString());
      // print('value ' + entity.value!.toString());
      // print('userid  ' + entity.userId!.toString());
      // print('branched ' + entity.brancheId.toString());

      final CashInFromCustomer mysel =
          await repository.addCashInFromCustomer(entity);
      final currentState = state;
      if (currentState is CashInFromCustomerLoaded) {
        final updatedItems = List<CashInFromCustomer>.from(currentState.items)
          ..add(mysel);
        emit(CashInFromCustomerLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(CashInFromCustomerGet(item: mysel));
    } catch (e) {
      emit(const CashInFromCustomerError('Failed to add'));
    }
  }

  Future<void> update(CashInFromCustomer entity) async {
    try {
      emit(CashInFromCustomerLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      int userId = await SharedPrefsService().getSelectedUserId();

      entity.brancheId = brancheId;
      entity.userId = userId;

      final CashInFromCustomer updatedCash =
          await repository.updateCashInFromCustomer(entity);
      final currentState = state;
      if (currentState is CashInFromCustomerLoaded) {
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedCash.id ? updatedCash : item;
        }).toList();
        emit(CashInFromCustomerLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(CashInFromCustomerGet(item: updatedCash));
    } catch (e) {
      emit(const CashInFromCustomerError('Failed to update'));
    }
  }

  Future<void> deleteCashInFromCustomer(int id) async {
    try {
      emit(CashInFromCustomerLoading());

      await repository.deleteCashInFromCustomer(id);
      final currentState = state;
      if (currentState is CashInFromCustomerLoaded) {
        final updatedItems =
            currentState.items.where((element) => element.id != id).toList();
        emit(CashInFromCustomerLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
    } catch (e) {
      emit(const CashInFromCustomerError('Failed to update'));
    }
  }

  void updateCashField(CashInFromCustomer cash) {
    emit(CashInFromCustomerGet(item: cash));
  }

  void filterItems(String query) {
    if (state is CashInFromCustomerLoaded) {
      final loadedState = state as CashInFromCustomerLoaded;
      final filteredItems = loadedState.items.where((item) {
        return item.customerName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(CashInFromCustomerLoaded(
          items: loadedState.items, filteredItems: filteredItems));
    }
  }
}
