import 'package:flutter/material.dart';

Widget buildTextFormField({
  required String labelText,
  required IconData prefixIcon,
  required Function(String) onChanged,
  bool obscureText = false,
  IconData? suffixIcon,
  var suffixPressed,
}){
  return TextFormField(
    obscureText: obscureText,
    validator: (value) {
      if(value!.isEmpty){
        return 'Please enter some text';
      }
      return null;
    },
    onChanged: onChanged,
      decoration: InputDecoration(
          label: Text(labelText),
          prefixIcon: Icon(prefixIcon,),
          suffixIcon: suffixIcon != null ?
          IconButton(icon: Icon(suffixIcon), onPressed: suffixPressed,) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
      )
  );
}

Widget buildButton({
  required VoidCallback onPressed,
  required String text
}){
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    ),
  );
}


