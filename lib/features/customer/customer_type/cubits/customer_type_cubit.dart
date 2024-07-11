import 'package:alfath_stoer_app/features/customer/customer_type/models/cutomer_type_model.dart';
import 'package:alfath_stoer_app/features/customer/customer_type/repositories/customer_type_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customer_type_state.dart';

class OrderCubit extends Cubit<CustomerTypeState> {
  OrderCubit() : super(CustomerTypeInitial());

  final CustomerTypeRepository repository = CustomerTypeRepository();
// add customerTyp
  Future<void> add(CustomerTypeModel customerType) async {
    try {
      //  int brancheId = await SharedPrefsService().getSelectedBrancheId();
      emit(CustomerTypeLoading());
      customerType = await repository.add(customerType);
      emit(CustomerTypeLoaded(customerType: customerType));
    } catch (e) {
      emit(const CustomerTypeError('Failed To Load Data From System'));
    }
  }

// edit order
  Future<void> edit(CustomerTypeModel customerType) async {
    try {
      emit(CustomerTypeLoading());
      customerType = await repository.edit(customerType);
      emit(CustomerTypeUpdatedSuccess());
    } catch (e) {
      emit(const CustomerTypeUpdatedError('Failed To Edit'));
    }
  }

  // delete
  Future<void> delete(int id) async {
    try {
      emit(CustomerTypeLoading());
      bool message = await repository.delete(id);
      if (message) {
        emit(CustomerTypeDeleted());
      }
    } catch (e) {
      emit(const CustomerTypeError('Failed To Delete '));
    }
  }

  // get by id
  Future<void> getById(int id) async {
    try {
      emit(CustomerTypeLoading());
      var customerType = await repository.getById(id);
      emit(CustomerTypeLoaded(customerType: customerType));
    } catch (e) {
      emit(const CustomerTypeError('Failed To load order '));
    }
  }

  // get for date
  Future<void> getAll() async {
    try {
      //  int brancheId = await SharedPrefsService().getSelectedBrancheId();

      emit(CustomerTypeLoading());
      var customerTypes = await repository.getAll();
      emit(CustomerTypesListLoaded(
          items: customerTypes, filteredItems: customerTypes));
    } catch (e) {
      emit(const CustomerTypeError('Failed To load orders'));
    }
  }

  void updateOrderField(CustomerTypeModel customerType) {
    emit(CustomerTypeUpdated(customerType: customerType));
  }

  void filterItems(String query) {
    if (state is CustomerTypesListLoaded) {
      if (query.isEmpty) {
        final loadedState = state as CustomerTypesListLoaded;

        emit(CustomerTypesListLoaded(
            items: loadedState.items, filteredItems: loadedState.items));
      } else {
        final loadedState = state as CustomerTypesListLoaded;

        final filteredItems = loadedState.items.where((item) {
          return item.name!.toLowerCase().contains(query);
        }).toList();
        emit(CustomerTypesListLoaded(
            items: loadedState.items, filteredItems: filteredItems));
      }
    } else {
      emit(const CustomerTypeError('فشل تحميل'));
    }
  }
}
