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
      emit(OrderLoading());
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
      var order = await repository.getById(id);
      emit(OrderLoaded(order: order));
    } catch (e) {
      emit(const OrderError('Failed To load order '));
    }
  }

  // get for date
  Future<void> getForDate(DateTime date, int brancheId) async {
    try {
      emit(OrderLoading());
      var orders = await repository.getForDate(date, brancheId);
      emit(OrdersListLoaded(orders: orders));
    } catch (e) {
      emit(const OrderError('Failed To load orders'));
    }
  }

  // get for time
  Future<void> getForTime(
      DateTime dateFrom, DateTime dateTo, int brancheId) async {
    try {
      emit(OrderLoading());
      var orders = await repository.getForTime(dateFrom, dateTo, brancheId);
      emit(OrdersListLoaded(orders: orders));
    } catch (e) {
      emit(const OrderError('Failed To load orders'));
    }
  }
}
