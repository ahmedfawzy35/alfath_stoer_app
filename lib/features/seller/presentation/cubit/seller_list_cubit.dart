import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/seller/data/models/seller_model.dart';
import 'package:alfath_stoer_app/features/seller/data/repositories/seller_repository.dart';
import 'package:alfath_stoer_app/features/seller/presentation/cubit/seller_list_state.dart';
import 'package:bloc/bloc.dart';

class SellerListCubit extends Cubit<SellerListState> {
  final SellerRepository repository = SellerRepository();

  SellerListCubit() : super(SellerListInitial());

  void fetchData() async {
    try {
      emit(SellerListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      final items = await repository.fetchData();
      var item2 = items.where((x) {
        return x.brancheId == brancheId;
      }).toList();
      emit(SellerListLoaded(items: item2, filteredItems: item2));
    } catch (e) {
      emit(SellerListError('Failed to load data: $e'));
    }
  }

  Future<void> add(SellerModel seller) async {
    try {
      emit(SellerListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      seller.brancheId = brancheId;

      final SellerModel mysel = await repository.addSeller(seller);
      final currentState = state;
      if (currentState is SellerListLoaded) {
        final updatedItems = List<SellerModel>.from(currentState.items)
          ..add(mysel);
        emit(
            SellerListLoaded(items: updatedItems, filteredItems: updatedItems));
      }
      emit(SellerLoaded(seller: mysel));
    } catch (e) {
      emit(const SellerListError('Failed to add'));
    }
  }

  Future<void> update(SellerModel seller) async {
    try {
      emit(SellerListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      seller.brancheId = brancheId;

      final SellerModel updatedSeller = await repository.updateSeller(seller);
      final currentState = state;
      if (currentState is SellerListLoaded) {
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedSeller.id ? updatedSeller : item;
        }).toList();
        emit(
            SellerListLoaded(items: updatedItems, filteredItems: updatedItems));
      }
      emit(SellerLoaded(seller: updatedSeller));
    } catch (e) {
      emit(const SellerListError('Failed to update'));
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
