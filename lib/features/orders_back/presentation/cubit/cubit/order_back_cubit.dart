import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/orders_back/data/models/order_back.dart';
import 'package:alfath_stoer_app/features/orders_back/data/repositories/order_back_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_back_state.dart';

class OrderBackCubit extends Cubit<OrderBackState> {
  OrderBackCubit() : super(OrderInitial());

  final OrderBackRepository repository = OrderBackRepository();
// add order
  Future<void> addOrderBack(OrderBack orderBack) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      emit(OrderLoading());
      orderBack.brancheId = brancheId;
      orderBack = await repository.addOrderBack(orderBack);
      emit(OrderLoaded(orderBack: orderBack));
    } catch (e) {
      emit(const OrderError('Failed To Load Data From System'));
    }
  }

// edit order
  Future<void> editOrderBack(OrderBack orderBack) async {
    try {
      emit(OrderLoading());
      orderBack = await repository.editOrderBack(orderBack);
      emit(OrderLoaded(orderBack: orderBack));
    } catch (e) {
      emit(const OrderError('Failed To Edit '));
    }
  }

  // delete
  Future<void> deleteOrderBack(int id) async {
    try {
      emit(OrderLoading());
      bool message = await repository.deleteOrderBack(id);
      if (message) {
        emit(OrderDeleted());
      }
    } catch (e) {
      emit(const OrderError('Failed To Delete '));
    }
  }

  // get by id
  Future<void> getById(int id) async {
    try {
      emit(OrderLoading());
      var orderBack = await repository.getById(id);
      emit(OrderLoaded(orderBack: orderBack));
    } catch (e) {
      emit(const OrderError('Failed To load order '));
    }
  }

  // get for date
  Future<void> getForDate(DateTime date) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(OrderLoading());
      var orders = await repository.getForDate(date, brancheId);
      emit(OrdersListLoaded(items: orders, filteredItems: orders));
    } catch (e) {
      emit(const OrderError('Failed To load orders'));
    }
  }

  // get for time
  Future<void> getForTime(DateTime dateFrom, DateTime dateTo) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(OrderLoading());
      var orders = await repository.getForTime(dateFrom, dateTo, brancheId);
      emit(OrdersListLoaded(items: orders, filteredItems: orders));
    } catch (e) {
      emit(const OrderError('Failed To load orders'));
    }
  }

  void updateOrderField(OrderBack orderBack) {
    emit(OrderUpdated(order: orderBack));
  }

  void filterItems(String query) {
    if (state is OrdersListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as OrdersListLoaded;

        emit(OrdersListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as OrdersListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.orderNumber == int.parse(query);
        }).toList();
        emit(OrdersListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const OrderError('فشل تحميل'));
    }
  }

  void filterItemsByName(String query) {
    if (state is OrdersListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as OrdersListLoaded;

        emit(OrdersListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as OrdersListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.customerName!.toLowerCase().contains(query);
        }).toList();
        emit(OrdersListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const OrderError('فشل تحميل'));
    }
  }
}
