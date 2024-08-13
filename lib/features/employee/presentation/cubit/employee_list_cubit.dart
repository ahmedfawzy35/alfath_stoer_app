import 'package:alfath_stoer_app/core/utils/shared_prefs_service.dart';
import 'package:alfath_stoer_app/features/employee/data/models/employee_model.dart';
import 'package:alfath_stoer_app/features/employee/data/repositories/employee_repository.dart';
import 'package:alfath_stoer_app/features/employee/presentation/cubit/Employee_list_state.dart';

import 'package:bloc/bloc.dart';

class EmployeeListCubit extends Cubit<EmployeeListState> {
  final EmployeeRepository repository = EmployeeRepository();

  EmployeeListCubit() : super(EmployeeListInitial());

  void fetchData() async {
    try {
      emit(EmployeeListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();

      final items = await repository.getAllForBranche(brancheId);

      emit(EmployeeListLoaded(items: items, filteredItems: items));
    } catch (e) {
      emit(EmployeeListError('Failed to load data: $e'));
    }
  }

  Future<void> add(Employee employee) async {
    try {
      emit(EmployeeListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      employee.brancheId = brancheId;

      final Employee mysel = await repository.addEmployee(employee);
      final currentState = state;
      if (currentState is EmployeeListLoaded) {
        final updatedItems = List<Employee>.from(currentState.items)
          ..add(mysel);
        emit(EmployeeListLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(EmployeeLoaded(employee: mysel));
    } catch (e) {
      emit(const EmployeeListError('Failed to add'));
    }
  }

  Future<void> update(Employee employee) async {
    try {
      emit(EmployeeListLoading());
      int brancheId = await SharedPrefsService().getSelectedBrancheId();
      employee.brancheId = brancheId;

      final Employee updatedEmployee =
          await repository.updateEmployee(employee);
      final currentState = state;
      if (currentState is EmployeeListLoaded) {
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedEmployee.id ? updatedEmployee : item;
        }).toList();
        emit(EmployeeListLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
      emit(EmployeeLoaded(employee: updatedEmployee));
    } catch (e) {
      emit(const EmployeeListError('Failed to update'));
    }
  }

  Future<void> delete(Employee employee) async {
    try {
      emit(EmployeeListLoading());

      await repository.deleteEmployee(employee.id!);
      final currentState = state;
      if (currentState is EmployeeListLoaded) {
        final updatedItems = currentState.items
            .where((element) => element.id != employee.id!)
            .toList();
        emit(EmployeeListLoaded(
            items: updatedItems, filteredItems: updatedItems));
      }
    } catch (e) {
      emit(const EmployeeListError('Failed to update'));
    }
  }

  void filterItems(String query) {
    if (state is EmployeeListLoaded) {
      final loadedState = state as EmployeeListLoaded;
      final filteredItems = loadedState.items.where((item) {
        return item.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(EmployeeListLoaded(
          items: loadedState.items, filteredItems: filteredItems));
    }
  }
}
