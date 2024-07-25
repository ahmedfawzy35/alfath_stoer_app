import 'package:alfath_stoer_app/features/customer/customer_type/models/cutomer_type_model.dart';
import 'package:alfath_stoer_app/features/customer/presentation/cubit/customer_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alfath_stoer_app/features/customer/data/models/customer_model.dart';
import 'package:alfath_stoer_app/features/customer/customer_type/repositories/customer_type_repository.dart';

class CustomerAddPage extends StatefulWidget {
  final CustomerModel customer;
  final bool isEdit;

  const CustomerAddPage(
      {super.key, this.isEdit = false, required this.customer});

  @override
  _CustomerAddPageState createState() => _CustomerAddPageState();
}

class _CustomerAddPageState extends State<CustomerAddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _startAccountController = TextEditingController();
  int? _selectedCustomerTypeId;

  bool _isLoading = false;
  List<CustomerTypeModel> _customerTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomerTypes();
    if (widget.isEdit) {
      _loadCustomerData();
    }
  }

  Future<void> _fetchCustomerTypes() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _customerTypes = await CustomerTypeRepository().getAll();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  void _loadCustomerData() {
    _nameController.text = widget.customer.name!;
    _addressController.text = widget.customer.adress!;
    _startAccountController.text = widget.customer.startAccount.toString();
    _selectedCustomerTypeId = widget.customer.customertypeId;
  }

  Future<void> _saveCustomer() async {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _startAccountController.text.isEmpty ||
        _selectedCustomerTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text('برجاء تعبئة جميع البيانات')),
      );
      return;
    }

    final customer = CustomerModel(
      id: widget.isEdit ? widget.customer.id : 0, // use existing ID if editing
      name: _nameController.text,
      adress: _addressController.text,
      startAccount: double.parse(_startAccountController.text),
      brancheId: widget.isEdit
          ? widget.customer.brancheId
          : 1, // Assuming a default branch ID for now
      customertypeId: _selectedCustomerTypeId!,
      stopDealing: false,
      customerAccount: 0.0,
    );

    try {
      setState(() {
        _isLoading = true;
      });

      if (widget.isEdit) {
        await context.read<CustomerListCubit>().edit(customer);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('تم تعديل العميل بنجاح')),
        );
        Navigator.of(context).pop(customer);
      } else {
        await context.read<CustomerListCubit>().add(customer);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('تم اضافة العميل بنجاح')),
        );
      }

      setState(() {
        _isLoading = false;
      });
      _clearFields();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red, content: Text('فشل في العملية')),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _addressController.clear();
    _startAccountController.clear();
    setState(() {
      _selectedCustomerTypeId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar:
            AppBar(title: Text(widget.isEdit ? 'تعديل عميل' : 'اضافة عميل')),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'الاسم'),
                      ),
                      TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'العنوان'),
                      ),
                      TextField(
                        controller: _startAccountController,
                        decoration:
                            const InputDecoration(labelText: 'الحساب المبدئي'),
                        keyboardType: TextInputType.number,
                      ),
                      DropdownButton<int>(
                        value: _selectedCustomerTypeId,
                        hint: const Text('اختر نوع العميل'),
                        items: _customerTypes.map((CustomerTypeModel type) {
                          return DropdownMenuItem<int>(
                            value: type.id,
                            child: Text(type.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedCustomerTypeId = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveCustomer,
                        child: Text(widget.isEdit ? 'تعديل' : 'اضافة'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
