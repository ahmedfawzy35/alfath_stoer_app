import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:alfath_stoer_app/features/orders/data/repositories/order_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  final OrderRepository repository = OrderRepository();
// add order
  Future<void> addOrder(Order order) async {
    try {
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      emit(OrderLoading());
      order.brancheId = brancheId;
      order = await repository.addOrder(order);
      emit(OrderLoaded(order: order));
    } catch (e) {
      emit(const OrderError('Failed To Load Data From System'));
    }
  }

// edit order
  Future<void> editOrder(Order order) async {
    try {
      emit(OrderLoading());
      order = await repository.editOrder(order);
      emit(OrderLoaded(order: order));
    } catch (e) {
      emit(const OrderError('Failed To Edit '));
    }
  }

  // delete
  Future<void> deleteOrder(int id) async {
    try {
      emit(OrderLoading());
      bool message = await repository.deleteOrder(id);
      print('تمام ينجم');
      if (message) {
        emit(OrderDeleted());
      }
    } catch (e) {
      print(e.toString());
      emit(const OrderError('Failed To Delete '));
    }
  }

  // get by id
  Future<void> getById(int id) async {
    try {
      emit(OrderLoading());
      var order = await repository.getById(id);
      emit(OrderLoaded(order: order));
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
      print(orders);
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

  void updateOrderField(Order order) {
    emit(OrderUpdated(order: order));
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
      emit(OrderError('فشل تحميل'));
    }
  }
}
