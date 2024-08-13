import 'package:alfath_stoer_app/features/employee/data/models/employee_model.dart';
import 'package:alfath_stoer_app/features/employee/presentation/cubit/Employee_list_state.dart';
import 'package:alfath_stoer_app/features/employee/presentation/cubit/employee_list_cubit.dart';
import 'package:alfath_stoer_app/features/employee/presentation/pages/employee_add_edit_page%20.dart';
import 'package:alfath_stoer_app/features/outgoing/data/models/outgoing_model.dart';
import 'package:alfath_stoer_app/features/outgoing/presentation/cubit/outgoing_list_cubit.dart';
import 'package:alfath_stoer_app/features/outgoing/presentation/cubit/outgoing_list_state.dart';
import 'package:alfath_stoer_app/features/outgoing/presentation/pages/outgoing_add_edit_page%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeList extends StatelessWidget {
  final bool edit;

  const EmployeeList({super.key, required this.edit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'بحث',
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              context.read<EmployeeListCubit>().filterItems(query);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<EmployeeListCubit, EmployeeListState>(
            builder: (context, state) {
              if (state is EmployeeListLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EmployeeListLoaded) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];
                    return EmployeeListItem(
                      edit: edit,
                      item: item,
                    );
                  },
                );
              } else if (state is EmployeeListError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
      ],
    );
  }
}

class EmployeeListItem extends StatelessWidget {
  const EmployeeListItem({super.key, required this.item, required this.edit});
  final Employee item;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: edit
            ? GestureDetector(
                onTap: () {
                  Navigator.pop(context, item);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
                              child: Text(
                                item.name!,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(item.enabled!
                                  ? 'حلة الموظف يعمل'
                                  : 'حلة الموظف مفصول'),
                              value: item.enabled,
                              onChanged: (value) {},
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
                            child: Text(
                              item.name!,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                final editedCustomer =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EmployeeAddEditPage(
                                      model: item,
                                    ),
                                  ),
                                );

                                if (editedCustomer != null) {
                                  context
                                      .read<OutGoigListCubit>()
                                      .update(editedCustomer);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green, // لون النص
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8), // التباعد الداخلي
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(5), // شكل الحواف
                                ),
                              ),
                              child: const Text('تعديل'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
