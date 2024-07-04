import 'package:alfath_stoer_app/features/customer_supplier/data/repositories/seller_detail_repository.dart';
import 'package:alfath_stoer_app/features/customer_supplier/presentation/cubit/seller_detail_state.dart';

import 'package:bloc/bloc.dart';

class SellerDetailCubit extends Cubit<SellerDetailState> {
  final SellerDetailRepository repository = SellerDetailRepository();

  SellerDetailCubit() : super(SellerDetailInitial());

  void fetchSellerDetail(int id) async {
    emit(SellerDetailLoading());
    try {
      final detail = await repository.fetchSellerDetail(id);
      emit(SellerDetailLoaded(detail));
    } catch (e) {
      emit(const SellerDetailError('Failed to load details'));
    }
  }
}
