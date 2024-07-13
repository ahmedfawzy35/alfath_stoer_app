import 'package:alfath_stoer_app/features/purchases_back/datat/models/purchase_back.dart';
import 'package:alfath_stoer_app/features/purchases_back/presentation/cubit/cubit/purchase_back_cubit.dart';
import 'package:alfath_stoer_app/features/purchases_back/presentation/pages/edit_purchase_back_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as date;

class PurchaseBackListPage extends StatelessWidget {
  final String? branche;
  final DateTime fromDate;
  final DateTime toDate;
  final bool singleDay;
  const PurchaseBackListPage({
    super.key,
    this.branche,
    required this.fromDate,
    required this.toDate,
    required this.singleDay,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          ' مرتجعات الشراء - ${singleDay ? 'لليوم  ${date.DateFormat('yyyy-mm-dd').format(fromDate)}' : 'للفترة من ${date.DateFormat('yyyy-mm-dd').format(fromDate)} الى ${date.DateFormat('yyyy-mm-dd').format(toDate)}'} ',
          style: const TextStyle(fontSize: 12),
        )),
        body: singleDay
            ? BlocProvider(
                create: (_) => PurchaseBackCubit()..getForDate(fromDate),
                child: const PurchaseBackList(),
              )
            : BlocProvider(
                create: (_) =>
                    PurchaseBackCubit()..getForTime(fromDate, toDate),
                child: const PurchaseBackList(),
              ),
      ),
    );
  }
}

class PurchaseBackList extends StatelessWidget {
  const PurchaseBackList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'بحث باسم المورد',
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              context.read<PurchaseBackCubit>().filterItemsByName(query);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'بحث برقم الفاتورة',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (query) {
              context.read<PurchaseBackCubit>().filterItems(query);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<PurchaseBackCubit, PurchaseBackState>(
            builder: (context, state) {
              if (state is PurchaseBackLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PurchasesBackListLoaded) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];

                    return PurchaseBackListItem(
                      item: item,
                    );
                  },
                );
              } else if (state is PurchaseBackError) {
                return const Center(child: Text('فشل تحميل البيانات'));
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

class PurchaseBackListItem extends StatelessWidget {
  const PurchaseBackListItem({
    super.key,
    required this.item,
  });
  final PurchaseBack item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 80, 43),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        date.DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(item.date!)),
                        style: _textStyle()),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text('رقم الفاتورة ', style: _textStyle()),
                            Text(item.orderNumber.toString(),
                                style: _textStyle())
                          ],
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Column(
                          children: [
                            Text(
                              'المعرف ',
                              style: _textStyle(),
                            ),
                            Text(item.id.toString(), style: _textStyle())
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
                    child: Text(
                      item.sellerName!,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text(':اسم العميل '),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                          child: const Text('تعديل'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<PurchaseBackCubit>(
                                  create: (context) => PurchaseBackCubit(),
                                  child:
                                      EditPurchaseBackPage(purchaseBack: item),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          final purchaseBackCubit =
                              context.read<PurchaseBackCubit>();
                          purchaseBackCubit.deletePurchaseBack(item.id!);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('حذف'),
                      )
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: _boxDecoration(),
                    child: Column(
                      children: [
                        Text('المتبقي ', style: _textStyle()),
                        Text(
                          item.remainingAmount.toString(),
                          style: TextStyle(
                              color: item.remainingAmount! > 0
                                  ? Colors.red
                                  : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  _details('المدفوع', item.paid.toString()),
                  const SizedBox(
                    width: 5,
                  ),
                  _details('الخصم', item.discount.toString()),
                  const SizedBox(
                    width: 5,
                  ),
                  _details('الاجمالي', item.total.toString()),
                ],
              ),
              Text(
                item.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
        color: const Color.fromARGB(255, 201, 70, 70),
        borderRadius: BorderRadius.circular(5));
  }

  Widget _details(String lable, String value) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Text(lable, style: _textStyle()),
          Text(value, style: _textStyle())
        ],
      ),
    );
  }
}
