import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:budget_family/presentation/currencyBloc/currency_bloc.dart'; // Import CurrencyBloc
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/utils.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime selectDate = DateTime.now();
  int? selectedCategoryIndex;
  String selectedCurrency = 'TRY';

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    selectDate = DateTime.now();
    // Fetch initial currency
    context.read<CurrencyBloc>().add(GetCurrency(target: selectedCurrency));
  }

  @override
  Widget build(BuildContext context) {
    double currencyExchange = 1.0;
    var d = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.indigo),
        ),
      ),
      body: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, currencyState) {
          if (currencyState is CurrencyLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (currencyState is CurrencySuccessState) {
            currencyExchange = currencyState.currency;
            print("Currency exchange updated with state : $currencyExchange");
          }
          if (currencyState is CurrencyErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AnimatedSnackBar.material(
                currencyState.message,
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                duration: const Duration(seconds: 4),
              ).show(context);
            });
          }


          if (currencyState is AddExpenseSuccessState) {
            AnimatedSnackBar.material(
              d.expense_added_successfully,
              type: AnimatedSnackBarType.success,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              duration: const Duration(seconds: 4),
            ).show(context);

            context.read<CurrencyBloc>().add(GetCurrency(target: selectedCurrency));

          }
          if (currencyState is CurrencyErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AnimatedSnackBar.material(
                currencyState.message,
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                duration: const Duration(seconds: 4),
              ).show(context);
            });
          }



          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text(
                 d.add_expense ,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: expenseController,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.indigo.shade50,
                                  hintText: d.expense_price,
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Text(
                                      selectedCurrency,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.indigo.shade900,
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.currency_lira),
                                                title: const Text('TRY'),
                                                onTap: () {
                                                  setState(() {
                                                    selectedCurrency = 'TRY';
                                                  });

                                                  context
                                                      .read<CurrencyBloc>()
                                                      .add(GetCurrency(target: selectedCurrency));
                                                   Navigator.pop(context);
                                                   print(currencyExchange);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.attach_money),
                                                title: const Text('USD'),
                                                onTap: () {
                                                  setState(() {
                                                    selectedCurrency = 'USD';
                                                  });
                                                  context
                                                      .read<CurrencyBloc>()
                                                      .add(GetCurrency(target: selectedCurrency));
                                                  print(currencyExchange);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.euro),
                                                title: const Text('EUR'),
                                                onTap: () {
                                                  setState(() {
                                                    selectedCurrency = 'EUR';
                                                  });
                                                  context
                                                      .read<CurrencyBloc>()
                                                      .add(GetCurrency(target: selectedCurrency));
                                                  print(currencyExchange);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                title: const Text('£ Sterlin'),
                                                onTap: () {
                                                  setState(() {
                                                    selectedCurrency = 'GBP';
                                                  });
                                                  context
                                                      .read<CurrencyBloc>()
                                                      .add(GetCurrency(target: selectedCurrency));
                                                  print(currencyExchange);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadiusDirectional.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                 Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      d.select_category,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Expense category GridView
                SizedBox(
                  height: 300,
                  child: GridView.builder(
                    shrinkWrap: true,
                    // Important to make it scrollable inside Column
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1.55,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryIndex = index;
                            categoryController.text = categories[index]['name'];
                          });
                        },
                        child: Card(
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                categories[index]['icon'],
                                size: 27,
                                color: selectedCategoryIndex == index
                                    ? Colors.green
                                    : Colors.indigo.shade300,
                              ),
                              SizedBox(height: 10),
                              Text(
                                categories[index]['name'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: selectedCategoryIndex == index
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: selectedCategoryIndex == index
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: TextFormField(
                    controller: dateController,
                    textAlignVertical: TextAlignVertical.center,
                    readOnly: true,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: selectDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (newDate != null) {
                        setState(() {
                          dateController.text = DateFormat('dd-MM-yyyy').format(newDate);
                          selectDate = newDate;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.indigo.shade50,
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.yellow[700],
                        size: 20,
                      ),
                      hintText: d.date,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: kToolbarHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (expenseController.text.isEmpty ||
                          categoryController.text.isEmpty ||
                          dateController.text.isEmpty) {
                        AnimatedSnackBar.material(
                          d.please_fill_all_fields,
                          type: AnimatedSnackBarType.warning,
                          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                          duration: const Duration(seconds: 4),
                        ).show(context);
                      } else {




                         try {
                           final amountInSelectedCurrency = double.parse(
                               (double.parse(expenseController.text) * currencyExchange).toStringAsFixed(2)
                           );
                           print("ConverTedEXPENSE:$amountInSelectedCurrency");
                           context.read<CurrencyBloc>().add(
                             AddExpenseRequest(
                               expense: amountInSelectedCurrency,
                               category: categoryController.text,
                               date: selectDate,
                             ),
                           );
                         } catch (e) {
                           AnimatedSnackBar.material(
                             d.please_enter_valid_expense_amount,
                             type: AnimatedSnackBarType.info,
                             mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                             duration: const Duration(seconds: 3),
                           ).show(context);
                         }

                        expenseController.clear();
                        categoryController.clear();
                        dateController.clear();
                        setState(() {
                          selectedCategoryIndex = null;
                          selectDate = DateTime.now();
                        });

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      d.add_expense,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}