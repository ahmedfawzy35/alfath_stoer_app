import 'package:alfath_stoer_app/features/employee/data/models/employee_model.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeListState extends Equatable {
  const EmployeeListState();

  @override
  List<Object> get props => [];
}

class EmployeeListInitial extends EmployeeListState {}

class EmployeeListLoading extends EmployeeListState {}

class EmployeeListLoaded extends EmployeeListState {
  final List<Employee> items;
  final List<Employee> filteredItems;
  const EmployeeListLoaded({required this.items, required this.filteredItems});

  @override
  List<Object> get props => [items, filteredItems];
}

class EmployeeLoaded extends EmployeeListState {
  final Employee employee;

  const EmployeeLoaded({required this.employee});

  @override
  List<Object> get props => [employee];
}

class EmployeeListError extends EmployeeListState {
  final String message;

  const EmployeeListError(this.message);

  @override
  List<Object> get props => [message];
}
