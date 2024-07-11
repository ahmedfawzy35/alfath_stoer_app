import 'package:alfath_stoer_app/features/purchases/presentation/pages/purchase_list_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as date;

class PurchaseManage extends StatefulWidget {
  const PurchaseManage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseManageState createState() => _PurchaseManageState();
}

class _PurchaseManageState extends State<PurchaseManage> {
  bool showSingleDayInvoices = true;
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة فواتير الشراء'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: showSingleDayInvoices,
                    onChanged: (value) {
                      setState(() {
                        showSingleDayInvoices = value ?? false;
                      });
                    },
                  ),
                  const Text('عرض فواتير يوم واحد فقط'),
                ],
              ),
              if (!showSingleDayInvoices) ...[
                Row(
                  children: [
                    const Text('من: '),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                          });
                        }
                      },
                      child: Text(startDate != null
                          ? date.DateFormat('yyyy-MM-dd').format(startDate!)
                          : 'اختر تاريخ البداية'),
                    ),
                    const SizedBox(width: 20),
                    const Text('إلى: '),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      },
                      child: Text(endDate != null
                          ? date.DateFormat('yyyy-MM-dd').format(endDate!)
                          : 'اختر تاريخ النهاية'),
                    ),
                  ],
                ),
              ] else ...[
                const Text('اليوم: '),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        startDate = pickedDate;
                      });
                    }
                  },
                  child: Text(startDate != null
                      ? date.DateFormat('yyyy-MM-dd').format(startDate!)
                      : 'اختر تاريخ '),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PurchaseListPage(
                        fromDate: startDate!,
                        toDate: endDate!,
                        singleDay: showSingleDayInvoices,
                      ),
                    ),
                  );
                },
                child: const Text('عرض الفواتير'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
