import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/cashout_to_OutGoing/data/models/cashout_to_OutGoing_model.dart';
import 'package:alfath_stoer_app/features/cashout_to_OutGoing/data/repositories/cashout_to_OutGoing_repository.dart';
import 'package:alfath_stoer_app/features/cashout_to_OutGoing/presentation/cubit/cashout_to_OutGoing_state.dart';
import 'package:bloc/bloc.dart';

class CashOutToOutGoingCubit extends Cubit<CashOutToOutGoingState> {
  final CashOutToOutGoingRepository repository = CashOutToOutGoingRepository();

  CashOutToOutGoingCubit() : super(CashOutToOutGoingInitial());

  void getAllForBranche() async {
    try {
      emit(CashOutToOutGoingLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      final items = await repository.getAllForBranche(brancheId);

      emit(CashOutToOutGoingLoaded(items: items, filteredItems: items));
    } catch (e) {
      emit(CashOutToOutGoingError('Failed to load data: $e'));
    }
  }

  void getByIdCashOutToOutGoing(int id) async {
    try {
      emit(CashOutToOutGoingLoading());

      final item = await repository.getByIdCashOutToOutGoing(id);

      emit(CashOutToOutGoingGet(item: item));
    } catch (e) {
      emit(CashOutToOutGoingError('Failed to load data: $e'));
    }
  }

  Future<void> addCashOutToOutGoing(CashOutToOutGoing entity) async {
    try {
      emit(CashOutToOutGoingLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      int userId = await SharedPrefsService().getSelectedUserId();

      entity.brancheId = brancheId;
      entity.userId = userId;

      // print('id ' + entity.id.toString());
      // print('value ' + entity.value!.toString());
      // print('userid  ' + entity.userId!.toString());
      // print('branched ' + entity.brancheId.toString());

      final CashOutToOutGoing mysel =
          await repository.addCashOutToOutGoing(entity);
      final currentState = state;
      if (currentState is CashOutToOutGoingLoaded) {
        final updatedItems = List<CashOutToOutGoing>.from(currentState.items)
          ..add(mysel);
        emit(CashOutToOutGoingLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(CashOutToOutGoingGet(item: mysel));
    } catch (e) {
      emit(const CashOutToOutGoingError('Failed to add'));
    }
  }

  Future<void> update(CashOutToOutGoing entity) async {
    try {
      emit(CashOutToOutGoingLoading());
      int userId = await SharedPrefsService().getSelectedUserId();

      entity.userId = userId;

      final CashOutToOutGoing updatedCash =
          await repository.updateCashOutToOutGoing(entity);
      final currentState = state;
      if (currentState is CashOutToOutGoingLoaded) {
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedCash.id ? updatedCash : item;
        }).toList();
        emit(CashOutToOutGoingLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(CashOutToOutGoingGet(item: updatedCash));
    } catch (e) {
      emit(const CashOutToOutGoingError('Failed to update'));
    }
  }

  Future<void> deleteCashOutToOutGoing(int id) async {
    try {
      emit(CashOutToOutGoingLoading());

      await repository.deleteCashOutToOutGoing(id);
      final currentState = state;
      if (currentState is CashOutToOutGoingLoaded) {
        final updatedItems =
            currentState.items.where((element) => element.id != id).toList();
        emit(CashOutToOutGoingLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
    } catch (e) {
      emit(const CashOutToOutGoingError('Failed to update'));
    }
  }

  void updateCashField(CashOutToOutGoing cash) {
    emit(CashOutToOutGoingGet(item: cash));
  }

  void filterItems(String query) {
    if (state is CashOutToOutGoingLoaded) {
      final loadedState = state as CashOutToOutGoingLoaded;
      final filteredItems = loadedState.items.where((item) {
        return item.outGoingName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(CashOutToOutGoingLoaded(
          items: loadedState.items, filteredItems: filteredItems));
    }
  }
}
