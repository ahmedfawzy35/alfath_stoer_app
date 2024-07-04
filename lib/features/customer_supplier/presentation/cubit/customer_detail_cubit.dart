import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/customer_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/customer_detail_state.dart';
import 'package:bloc/bloc.dart';

class CustomerDetailCubit extends Cubit<CustomerSupplierDetailState> {
  final CustomerDetailRepository repository = CustomerDetailRepository();

  CustomerDetailCubit() : super(CustomerSupplierDetailInitial());

  void fetchCustomerSupplierDetail(int id) async {
    emit(CustomerSupplierDetailLoading());
    try {
      final detail = await repository.fetchCustomerSupplierDetail(id);
      emit(CustomerSupplierDetailLoaded(detail));
    } catch (e) {
      emit(const CustomerSupplierDetailError('Failed to load details'));
    }
  }
}
