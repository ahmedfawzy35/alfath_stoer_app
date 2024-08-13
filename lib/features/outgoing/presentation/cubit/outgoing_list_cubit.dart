import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/outgoing/data/models/outgoing_model.dart';
import 'package:alfath_stoer_app/features/outgoing/data/repositories/outgoing_repository.dart';
import 'package:alfath_stoer_app/features/outgoing/presentation/cubit/outgoing_list_state.dart';

import 'package:bloc/bloc.dart';

class OutGoigListCubit extends Cubit<OutGoigListState> {
  final OutGoigRepository repository = OutGoigRepository();

  OutGoigListCubit() : super(OutGoigListInitial());

  void fetchData() async {
    try {
      emit(OutGoigListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      final items = await repository.getAllForBranche(brancheId);

      emit(OutGoigListLoaded(items: items, filteredItems: items));
    } catch (e) {
      emit(OutGoigListError('Failed to load data: $e'));
    }
  }

  Future<void> add(OutGoig outGoig) async {
    try {
      emit(OutGoigListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      outGoig.brancheId = brancheId;

      final OutGoig mysel = await repository.addOutGoig(outGoig);
      final currentState = state;
      if (currentState is OutGoigListLoaded) {
        final updatedItems = List<OutGoig>.from(currentState.items)..add(mysel);
        emit(OutGoigListLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(OutGoigLoaded(outGoig: mysel));
    } catch (e) {
      emit(const OutGoigListError('Failed to add'));
    }
  }

  Future<void> update(OutGoig outGoig) async {
    try {
      emit(OutGoigListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      outGoig.brancheId = brancheId;

      final OutGoig updatedOutGoig = await repository.updateOutGoig(outGoig);
      final currentState = state;
      if (currentState is OutGoigListLoaded) {
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedOutGoig.id ? updatedOutGoig : item;
        }).toList();
        emit(OutGoigListLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(OutGoigLoaded(outGoig: updatedOutGoig));
    } catch (e) {
      emit(const OutGoigListError('Failed to update'));
    }
  }

  void filterItems(String query) {
    if (state is OutGoigListLoaded) {
      final loadedState = state as OutGoigListLoaded;
      final filteredItems = loadedState.items.where((item) {
        return item.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(OutGoigListLoaded(
          items: loadedState.items, filteredItems: filteredItems));
    }
  }
}
