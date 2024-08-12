import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/cashout_to_seller/data/models/cashout_to_seller_model.dart';
import 'package:alfath_stoer_app/features/cashout_to_seller/data/repositories/cashout_to_seller_repository.dart';
import 'package:alfath_stoer_app/features/cashout_to_seller/presentation/cubit/cashout_to_seller_state.dart';
import 'package:bloc/bloc.dart';

class CashOutToSellerCubit extends Cubit<CashOutToSellerState> {
  final CashOutToSellerRepository repository = CashOutToSellerRepository();

  CashOutToSellerCubit() : super(CashOutToSellerInitial());

  void getAllForBranche() async {
    try {
      emit(CashOutToSellerLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      final items = await repository.getAllForBranche(brancheId);

      emit(CashOutToSellerLoaded(items: items, filteredItems: items));
    } catch (e) {
      emit(CashOutToSellerError('Failed to load data: $e'));
    }
  }

  void getByIdCashOutToSeller(int id) async {
    try {
      emit(CashOutToSellerLoading());

      final item = await repository.getByIdCashOutToSeller(id);

      emit(CashOutToSellerGet(item: item));
    } catch (e) {
      emit(CashOutToSellerError('Failed to load data: $e'));
    }
  }

  Future<void> addCashOutToSeller(CashOutToSeller entity) async {
    try {
      emit(CashOutToSellerLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      int userId = await SharedPrefsService().getSelectedUserId();

      entity.brancheId = brancheId;
      entity.userId = userId;

      // print('id ' + entity.id.toString());
      // print('value ' + entity.value!.toString());
      // print('userid  ' + entity.userId!.toString());
      // print('branched ' + entity.brancheId.toString());

      final CashOutToSeller mysel = await repository.addCashOutToSeller(entity);
      final currentState = state;
      if (currentState is CashOutToSellerLoaded) {
        final updatedItems = List<CashOutToSeller>.from(currentState.items)
          ..add(mysel);
        emit(CashOutToSellerLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(CashOutToSellerGet(item: mysel));
    } catch (e) {
      emit(const CashOutToSellerError('Failed to add'));
    }
  }

  Future<void> update(CashOutToSeller entity) async {
    try {
      emit(CashOutToSellerLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      int userId = await SharedPrefsService().getSelectedUserId();

      entity.brancheId = brancheId;
      entity.userId = userId;

      final CashOutToSeller updatedCash =
          await repository.updateCashOutToSeller(entity);
      final currentState = state;
      if (currentState is CashOutToSellerLoaded) {
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedCash.id ? updatedCash : item;
        }).toList();
        emit(CashOutToSellerLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(CashOutToSellerGet(item: updatedCash));
    } catch (e) {
      emit(const CashOutToSellerError('Failed to update'));
    }
  }

  Future<void> deleteCashOutToSeller(int id) async {
    try {
      emit(CashOutToSellerLoading());

      await repository.deleteCashOutToSeller(id);
      final currentState = state;
      if (currentState is CashOutToSellerLoaded) {
        final updatedItems =
            currentState.items.where((element) => element.id != id).toList();
        emit(CashOutToSellerLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
    } catch (e) {
      emit(const CashOutToSellerError('Failed to update'));
    }
  }

  void updateCashField(CashOutToSeller cash) {
    emit(CashOutToSellerGet(item: cash));
  }

  void filterItems(String query) {
    if (state is CashOutToSellerLoaded) {
      final loadedState = state as CashOutToSellerLoaded;
      final filteredItems = loadedState.items.where((item) {
        return item.sellerName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(CashOutToSellerLoaded(
          items: loadedState.items, filteredItems: filteredItems));
    }
  }
}
