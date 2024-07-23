// import 'package:flutter/material.dart';
//
// class ReusableTextField extends StatelessWidget {
//   final String title;
//   final String hint;
//   final bool isNumber;
//   final TextEditingController controller;
//
//   const ReusableTextField({
//     Key? key,
//     required this.title,
//     required this.hint,
//     this.isNumber = false,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//       decoration: InputDecoration(
//         labelText: title,
//         hintText: hint,
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Cannot be empty';
//         }
//         return null;
//       },
//       controller: controller,
//     );
//   }
// }


import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  const ReusableTextField({super.key, required this.title, required this.hint, this.isNumber, required this.controller, required this.formkey});
  final String title, hint;
  final bool? isNumber;
  final TextEditingController controller;
  final Key formkey;
  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: TextFormField(keyboardType: widget.isNumber == null
          ? TextInputType.text
          : TextInputType.number,
        decoration: InputDecoration(label: Text(widget.title),hintText: widget.hint),
        validator: (value) => value!.isEmpty ? "Cannot be empty" : null,
        controller: widget.controller,
      ),
    );
  }
}