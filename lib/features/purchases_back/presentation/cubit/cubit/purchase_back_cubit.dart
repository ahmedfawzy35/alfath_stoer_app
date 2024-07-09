import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/purchases/datat/models/purchase.dart';
import 'package:alfath_stoer_app/features/purchases_back/datat/models/purchase_back.dart';
import 'package:alfath_stoer_app/features/purchases_back/datat/repositories/purchase_back_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'purchase_back_state.dart';

class PurchaseBackCubit extends Cubit<PurchaseBackState> {
  PurchaseBackCubit() : super(PurchaseBackInitial());

  final PurchaseBackRepository repository = PurchaseBackRepository();
// add Purchase
  Future<void> addPurchase(PurchaseBack purchaseBack) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      emit(PurchaseBackLoading());
      purchaseBack.brancheId = brancheId;
      purchaseBack = await repository.addPurchaseBack(purchaseBack);
      emit(PurchaseBackLoaded(purchaseBack: purchaseBack));
    } catch (e) {
      emit(const PurchaseBackError('Failed To Load Data From System'));
    }
  }

// edit Purchase
  Future<void> editPurchase(PurchaseBack PurchaseBack) async {
    try {
      emit(PurchaseBackLoading());
      PurchaseBack = await repository.editPurchaseBack(PurchaseBack);
      emit(PurchaseBackLoaded(purchaseBack: PurchaseBack));
    } catch (e) {
      emit(const PurchaseBackError('Failed To Edit '));
    }
  }

  // delete
  Future<void> deletePurchaseBack(int id) async {
    try {
      emit(PurchaseBackLoading());
      bool message = await repository.deletePurchaseBack(id);
      if (message) {
        emit(PurchaseBackDeleted());
      }
    } catch (e) {
      emit(const PurchaseBackError('Failed To Delete '));
    }
  }

  // get by id
  Future<void> getById(int id) async {
    try {
      emit(PurchaseBackLoading());
      var PurchaseBack = await repository.getById(id);
      emit(PurchaseBackLoaded(purchaseBack: PurchaseBack));
    } catch (e) {
      emit(const PurchaseBackError('Failed To load Purchase '));
    }
  }

  // get for date
  Future<void> getForDate(DateTime date) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(PurchaseBackLoading());
      var PurchasesBack = await repository.getForDate(date, brancheId);
      emit(PurchasesBackListLoaded(
          items: PurchasesBack, filteredItems: PurchasesBack));
    } catch (e) {
      emit(const PurchaseBackError('Failed To load Purchases'));
    }
  }

  // get for time
  Future<void> getForTime(DateTime dateFrom, DateTime dateTo) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(PurchaseBackLoading());
      var PurchasesBack =
          await repository.getForTime(dateFrom, dateTo, brancheId);
      emit(PurchasesBackListLoaded(
          items: PurchasesBack, filteredItems: PurchasesBack));
    } catch (e) {
      emit(const PurchaseBackError('Failed To load Purchases'));
    }
  }

  void updatePurchaseField(PurchaseBack PurchaseBack) {
    emit(PurchaseBackUpdated(purchaseBack: PurchaseBack));
  }

  void filterItems(String query) {
    if (state is PurchasesBackListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as PurchasesBackListLoaded;

        emit(PurchasesBackListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as PurchasesBackListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.orderNumber == int.parse(query);
        }).toList();
        emit(PurchasesBackListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const PurchaseBackError('فشل تحميل'));
    }
  }

  void filterItemsByName(String query) {
    if (state is PurchasesBackListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as PurchasesBackListLoaded;

        emit(PurchasesBackListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as PurchasesBackListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.sellerName!.toLowerCase().contains(query);
        }).toList();
        emit(PurchasesBackListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const PurchaseBackError('فشل تحميل'));
    }
  }
}
