import 'package:alfath_stoer_app/features/purchases_back/presentation/pages/purchase_back_list_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as date;

class PurchaseBackManage extends StatefulWidget {
  const PurchaseBackManage({super.key});

  @override
  _PurchaseManageState createState() => _PurchaseManageState();
}

class _PurchaseManageState extends State<PurchaseBackManage> {
  bool showSingleDayInvoices = true;
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة مرتجعات الشراء'),
        ),
        body: SingleChildScrollView(
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
                  const Text('عرض مرتجعات يوم واحد فقط'),
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
                      builder: (context) => PurchaseBackListPage(
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
