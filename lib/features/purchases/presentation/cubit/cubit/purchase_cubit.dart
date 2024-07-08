import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/purchases/datat/models/purchase.dart';
import 'package:alfath_stoer_app/features/purchases/datat/repositories/purchase_repository.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  PurchaseCubit() : super(PurchaseInitial());

  final PurchaseRepository repository = PurchaseRepository();
// add Purchase
  Future<void> addPurchase(Purchase Purchase) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      emit(PurchaseLoading());
      Purchase.brancheId = brancheId;
      Purchase = await repository.addPurchase(Purchase);
      emit(PurchaseLoaded(purchase: Purchase));
    } catch (e) {
      emit(const PurchaseError('Failed To Load Data From System'));
    }
  }

// edit Purchase
  Future<void> editPurchase(Purchase Purchase) async {
    try {
      emit(PurchaseLoading());
      Purchase = await repository.editPurchase(Purchase);
      emit(PurchaseLoaded(purchase: Purchase));
    } catch (e) {
      emit(const PurchaseError('Failed To Edit '));
    }
  }

  // delete
  Future<void> deletePurchase(int id) async {
    try {
      emit(PurchaseLoading());
      bool message = await repository.deletePurchase(id);
      if (message) {
        emit(PurchaseDeleted());
      }
    } catch (e) {
      emit(const PurchaseError('Failed To Delete '));
    }
  }

  // get by id
  Future<void> getById(int id) async {
    try {
      emit(PurchaseLoading());
      var Purchase = await repository.getById(id);
      emit(PurchaseLoaded(purchase: Purchase));
    } catch (e) {
      emit(const PurchaseError('Failed To load Purchase '));
    }
  }

  // get for date
  Future<void> getForDate(DateTime date) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(PurchaseLoading());
      var Purchases = await repository.getForDate(date, brancheId);
      emit(PurchasesListLoaded(items: Purchases, filteredItems: Purchases));
    } catch (e) {
      emit(const PurchaseError('Failed To load Purchases'));
    }
  }

  // get for time
  Future<void> getForTime(DateTime dateFrom, DateTime dateTo) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(PurchaseLoading());
      var Purchases = await repository.getForTime(dateFrom, dateTo, brancheId);
      emit(PurchasesListLoaded(items: Purchases, filteredItems: Purchases));
    } catch (e) {
      emit(const PurchaseError('Failed To load Purchases'));
    }
  }

  void updatePurchaseField(Purchase Purchase) {
    emit(PurchaseUpdated(purchase: Purchase));
  }

  void filterItems(String query) {
    if (state is PurchasesListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as PurchasesListLoaded;

        emit(PurchasesListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as PurchasesListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.orderNumber == int.parse(query);
        }).toList();
        emit(PurchasesListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const PurchaseError('فشل تحميل'));
    }
  }

  void filterItemsByName(String query) {
    if (state is PurchasesListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as PurchasesListLoaded;

        emit(PurchasesListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as PurchasesListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.sellerName!.toLowerCase().contains(query);
        }).toList();
        emit(PurchasesListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const PurchaseError('فشل تحميل'));
    }
  }
}
