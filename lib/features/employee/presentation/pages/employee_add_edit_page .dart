import 'package:alfath_stoer_app/features/employee/data/models/employee_model.dart';
import 'package:alfath_stoer_app/features/employee/presentation/cubit/Employee_list_state.dart';
import 'package:alfath_stoer_app/features/employee/presentation/cubit/employee_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as date;

class EmployeeAddEditPage extends StatefulWidget {
  final Employee? model;

  const EmployeeAddEditPage({Key? key, this.model}) : super(key: key);

  @override
  EmployeeAddEditPageState createState() => EmployeeAddEditPageState();
}

class EmployeeAddEditPageState extends State<EmployeeAddEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _adressController;
  late TextEditingController _salaryController;
  late TextEditingController _phoneController;
  late TextEditingController _dateStartController;
  late TextEditingController _dateEndController;
  late DateTime selectedDateStart;
  late DateTime selectedDateEnd;
  late bool _isEnabled;

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode adressFocusNode = FocusNode();
  final FocusNode salaryFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode dateStartFocusNode = FocusNode();
  final FocusNode dateEndFocusNode = FocusNode();
  final FocusNode saverFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    selectedDateStart = widget.model == null
        ? DateTime.now()
        : DateTime.parse(widget.model!.dateStart!);
    selectedDateEnd = widget.model == null
        ? DateTime.now()
        : widget.model!.dateEnd == null
            ? DateTime.now()
            : DateTime.parse(widget.model!.dateStart!);
    _nameController = TextEditingController(text: widget.model?.name ?? '');
    _adressController = TextEditingController(text: widget.model?.adress ?? '');
    _salaryController =
        TextEditingController(text: widget.model?.salary.toString() ?? '');
    _phoneController = TextEditingController(text: widget.model?.phone ?? '');
    _dateStartController =
        TextEditingController(text: widget.model?.dateStart.toString() ?? '');
    _dateEndController =
        TextEditingController(text: widget.model?.adress ?? '');
    _isEnabled = widget.model?.enabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _adressController.dispose();
    _salaryController.dispose();
    _phoneController.dispose();
    _dateStartController.dispose();
    _dateEndController.dispose();

    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_isEnabled) {
        _dateEndController.text = date.DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 36500)));
      }
      final mymodel = Employee(
        id: widget.model?.id ?? 0,
        name: _nameController.text,
        adress: _adressController.text,
        salary: double.parse(_salaryController.text),
        phone: _phoneController.text,
        enabled: _isEnabled,
        dateStart: _dateStartController.text,
        dateEnd: _dateEndController.text,
        brancheId: 0, // Will be set in the cubit
      );

      if (widget.model == null) {
        context.read<EmployeeListCubit>().add(mymodel);
      } else {
        context.read<EmployeeListCubit>().update(mymodel);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.model == null
              ? 'اضافة موظف'
              : 'تعديل موظف  ${widget.model!.name}'),
        ),
        body: BlocListener<EmployeeListCubit, EmployeeListState>(
          listener: (context, state) {
            if (state is EmployeeListError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }
            if (state is EmployeeLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                    'تم ${widget.model == null ? ' اضافة ' : ' تعديل'} الموظف بنجاح'),
              ));
            } else if (state is EmployeeListError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                    'فشل ${widget.model == null ? ' اضافة ' : ' تعديل'} الموظف'),
              ));
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'الاسم'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك ادخل الاسم';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _adressController,
                      decoration: const InputDecoration(labelText: 'العنوان'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'من فضلك ادخل العنوان';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _salaryController,
                      focusNode: salaryFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(phoneFocusNode);
                      },
                      decoration: const InputDecoration(labelText: 'المرتب'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال المرتب';
                        }
                        if (double.tryParse(value) == null) {
                          return 'يرجى إدخال رقم صالح';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      focusNode: phoneFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(dateStartFocusNode);
                      },
                      decoration:
                          const InputDecoration(labelText: 'رقم الهاتف'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رقم الهاتف';
                        }
                        if (double.tryParse(value) == null) {
                          return 'يرجى إدخال رقم صالح';
                        }
                        if (value.length > 11) {
                          return 'يرجى إدخال 11 رقم فقط ';
                        }
                        if (value.length < 11) {
                          return 'يرجى اكمال 11 رقم  ';
                        }
                        return null;
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDateStart,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != selectedDateStart) {
                          selectedDateStart = picked;
                          _dateStartController.text =
                              date.DateFormat('yyyy-MM-dd').format(picked);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dateStartController,
                          decoration:
                              const InputDecoration(labelText: 'تاريخ التعيين'),
                          readOnly: true,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(
                          _isEnabled ? 'حلة الموظف يعمل' : 'حلة الموظف مفصول'),
                      value: _isEnabled,
                      onChanged: (bool? value) {
                        setState(() {
                          _isEnabled = value ?? false;
                        });
                      },
                    ),
                    if (!_isEnabled)
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDateEnd,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && picked != selectedDateEnd) {
                            selectedDateEnd = picked;
                            _dateEndController.text =
                                date.DateFormat('yyyy-MM-dd').format(picked);
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _dateEndController,
                            decoration:
                                const InputDecoration(labelText: 'تاريخ الفصل'),
                            readOnly: true,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                          widget.model == null ? 'اضافة موظف' : 'تعديل موظف'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
