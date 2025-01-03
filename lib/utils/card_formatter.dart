import 'package:flutter/src/services/text_input.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:flutter/src/services/text_editing.dart';

class CardNumberInputFormatter extends TextInputFormatter {

  static String getFormatString(String text){
    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('   '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return string;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

   /* if (newValue.selection.baseOffset == 0) {
      return newValue;
    }*/

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' - '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}