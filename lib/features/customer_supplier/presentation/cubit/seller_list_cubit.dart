import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/seller_list_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_list_state.dart';
import 'package:bloc/bloc.dart';

class SellerListCubit extends Cubit<SellerListState> {
  final SellerListRepository repository =
      SellerListRepository(MyStrings.baseurl);

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
