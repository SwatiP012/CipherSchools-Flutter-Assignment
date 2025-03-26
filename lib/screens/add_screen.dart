import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cipherx/dataModels/model/add_data.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final box = Hive.box<Add_data>('data');
  DateTime date = DateTime.now();
  String? selctedItem;
  String? selctedItemi;
  final TextEditingController explainC = TextEditingController();
  final FocusNode explainFocus = FocusNode();
  final TextEditingController amountC = TextEditingController();
  final FocusNode amountFocus = FocusNode();

  final List<String> _item = [
    'food',
    "Transfer",
    "Transportation",
    "Education"
  ];
  final List<String> _itemei = ['Income', "Expand"];

  @override
  void initState() {
    super.initState();
    explainFocus.addListener(() {
      setState(() {});
    });
    amountFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            backgroundContainer(context),
            Positioned(
              top: 120,
              child: mainContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: 550,
      width: 340,
      child: Column(
        children: [
          const SizedBox(height: 50),
          nameDropdown(),
          const SizedBox(height: 30),
          explainInput(),
          const SizedBox(height: 30),
          amountInput(),
          const SizedBox(height: 30),
          typeDropdown(),
          const SizedBox(height: 30),
          datePicker(),
          const Spacer(),
          saveButton(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  GestureDetector saveButton() {
    return GestureDetector(
      onTap: () async {
        if (selctedItemi != null &&
            selctedItem != null &&
            amountC.text.isNotEmpty &&
            explainC.text.isNotEmpty) {
          try {
            debugPrint('Creating new entry with:');
            debugPrint('Category: $selctedItem');
            debugPrint('Explanation: ${explainC.text}');
            debugPrint('Amount: ${amountC.text}');
            debugPrint('Type: $selctedItemi');
            debugPrint('Date: $date');

            var newEntry = Add_data(
              selctedItem!,
              explainC.text,
              amountC.text,
              selctedItemi!,
              date,
            );

            debugPrint('Adding entry to Hive box...');
            await box.add(newEntry);
            debugPrint('Entry added successfully');

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Transaction added successfully!"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            // Clear the form
            setState(() {
              selctedItem = null;
              selctedItemi = null;
              amountC.clear();
              explainC.clear();
              date = DateTime.now();
            });

            // Navigate back after a short delay
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          } catch (e) {
            debugPrint('Error saving transaction: $e');
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error adding transaction: ${e.toString()}"),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please fill in all fields."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFF7E3DFF),
        ),
        width: MediaQuery.of(context).size.width - 60,
        height: 56,
        child: const Text(
          'Save',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget datePicker() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
      ),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (newDate != null) {
            setState(() {
              date = newDate;
            });
          }
        },
        child: Text(
          'Date : ${date.day} / ${date.month} / ${date.year}',
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }

  Widget typeDropdown() {
    return dropdownTemplate(
      value: selctedItemi,
      items: _itemei,
      hint: 'Type',
      onChanged: (val) => setState(() => selctedItemi = val),
    );
  }

  Widget nameDropdown() {
    return dropdownTemplate(
      value: selctedItem,
      items: _item,
      hint: 'Category',
      imagePrefix: true,
      onChanged: (val) => setState(() => selctedItem = val),
    );
  }

  Widget dropdownTemplate({
    required String? value,
    required List<String> items,
    required String hint,
    bool imagePrefix = false,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
        ),
        child: DropdownButton<String>(
          value: value,
          onChanged: (val) => onChanged(val!),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Row(
                      children: [
                        if (imagePrefix)
                          SizedBox(
                              width: 40, child: Image.asset('assets/$e.png')),
                        if (imagePrefix) const SizedBox(width: 10),
                        Text(e, style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ))
              .toList(),
          selectedItemBuilder: (_) => items
              .map((e) => Row(
                    children: [
                      if (imagePrefix)
                        SizedBox(
                            width: 40, child: Image.asset('assets/$e.png')),
                      if (imagePrefix) const SizedBox(width: 5),
                      Text(e),
                    ],
                  ))
              .toList(),
          hint: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              hint,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  Widget amountInput() {
    return textInputField(
      controller: amountC,
      focusNode: amountFocus,
      labelText: 'Amount',
      keyboardType: TextInputType.number,
    );
  }

  Widget explainInput() {
    return textInputField(
      controller: explainC,
      focusNode: explainFocus,
      labelText: 'Explanation',
    );
  }

  Widget textInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Color(0xffC5C5C5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: Color(0xff368983)),
          ),
        ),
      ),
    );
  }

  Widget backgroundContainer(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: const BoxDecoration(
            color: Color(0xFF7B61FF),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    Text(
                      'Add Transaction',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.attach_file_outlined, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
