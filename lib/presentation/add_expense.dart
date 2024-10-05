import 'dart:ffi';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:budget_family/presentation/budgetBloc/budget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart'; // Add this for the DateFormat

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




  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    selectDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.indigo),
        ),
      ),
      body: BlocProvider(
        create: (context) => BudgetBloc(),
        child: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, state) {


            if(state is BudgetLoadingState){
              return const Center(child: CircularProgressIndicator());
            }


            if(state is AddExpenseSuccessState){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AnimatedSnackBar.material(
                  'Added Successfully',
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,  // Alt kısımda gösterilir
                  duration: const Duration(seconds: 3),  // SnackBar'ın ekranda kalma süresi
                ).show(context);
                //clear texts
                expenseController.clear();
                categoryController.clear();
                dateController.clear();
                selectedCategoryIndex = null;
              context.read<BudgetBloc>().add(ResetBudgetStateEvent());
              });
            }


            if(state is BudgetErrorState){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              });
            }




            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  const Text(
                    'Add Expense',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 15),


                  // Expense price input
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.7,
                    child: TextFormField(
                      controller: expenseController,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.indigo.shade50,
                        prefixIcon: Icon(
                          Icons.euro_rounded,
                          color: Colors.yellow[700],
                          size: 25,
                        ),
                        hintText: 'Expense Price',
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
                  const SizedBox(height: 20),


                  // categories text
                  const Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select Category ˬ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // categories text align start


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
                              categoryController.text =
                              categories[index]['name'];
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


                  // Date picker
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.70,
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
                            dateController.text =
                                DateFormat('dd-MM-yyyy').format(
                                    newDate);
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
                        hintText: 'Date',
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


                  // Add expense button
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.5,
                    height: kToolbarHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        if(expenseController.text.isEmpty||
                            categoryController.text.isEmpty||
                            dateController.text.isEmpty){
                          AnimatedSnackBar.material(
                            'Please fill all fields',
                            type: AnimatedSnackBarType.warning,
                            mobileSnackBarPosition: MobileSnackBarPosition.bottom,  // Alt kısımda gösterilir
                            duration: const Duration(seconds: 3),  // SnackBar'ın ekranda kalma süresi
                          ).show(context);
                          return;
                        }

                        try {
                          double expenseValue = double.parse(expenseController.text);
                          // Dönüştürülmüş değeri Bloc'a gönderiyoruz
                          context.read<BudgetBloc>().add(
                            AddExpenseRequest(
                              expense: expenseValue,
                              category: categoryController.text,
                              date: dateController.text,
                            ),


                          );
                        } catch (e) {
                          // Dönüştürme hatası varsa kullanıcıya mesaj göster
                          AnimatedSnackBar.material(
                            'Please enter a valid expense amount',
                            type: AnimatedSnackBarType.info,
                            mobileSnackBarPosition: MobileSnackBarPosition.bottom,  // Alt kısımda gösterilir
                            duration: const Duration(seconds: 3),  // SnackBar'ın ekranda kalma süresi
                          ).show(context);
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: const Text('Add Expense',
                        style: TextStyle(color: Colors.black,
                            fontSize: 17),),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
