import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_supplier_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_supplier_detail_state.dart';
import 'package:bloc/bloc.dart';

class CustomerSupplierDetailCubit extends Cubit<CustomerSupplierDetailState> {
  final CustomerSupplierDetailRepository repository;

  CustomerSupplierDetailCubit(this.repository)
      : super(CustomerSupplierDetailInitial());

  void fetchCustomerSupplierDetail(String type, int id) async {
    emit(CustomerSupplierDetailLoading());
    try {
      final detail = await repository.fetchCustomerSupplierDetail(type, id);
      emit(CustomerSupplierDetailLoaded(detail));
    } catch (e) {
      emit(CustomerSupplierDetailError('Failed to load details'));
    }
  }
}
