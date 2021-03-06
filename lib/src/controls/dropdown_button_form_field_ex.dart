import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'validation/validator_builder.dart';

class DropdownButtonFormFieldEx<String> extends DropdownButtonFormField {
  DropdownButtonFormFieldEx({
    Key key,
    List<DropdownMenuItem<String>> items = const [],
    DropdownButtonBuilder selectedItemBuilder,
    String labelText,
    Widget disabledHint,
    String value,
    ValueChanged<String> onChanged,
    VoidCallback onTap,
    int elevation: 8,
    TextStyle style,
    Widget icon,
    Color iconDisabledColor,
    Color iconEnabledColor,
    double iconSize: 24.0,
    bool isDense: false,
    bool isExpanded: false,
    double itemHeight: kMinInteractiveDimension,
    Color focusColor,
    FocusNode focusNode,
    bool autofocus: false,
    Color dropdownColor,
    InputDecoration decoration = const InputDecoration(),
    FormFieldSetter<String> onSaved,
    bool disabled = false,
    bool required = false,
    ValidationBuilder validationBuilder,
  }) : super(
          key: key,
          items: items,
          selectedItemBuilder: selectedItemBuilder,
          value: value,
          hint: Text(sprintf("%s%s", [labelText, (required ? " *" : "")])),
          disabledHint: disabledHint,
          onChanged: onChanged,
          onTap: onTap,
          elevation: elevation,
          style: style,
          icon: icon,
          iconDisabledColor: iconDisabledColor,
          iconEnabledColor: iconEnabledColor,
          iconSize: iconSize,
          isDense: isDense,
          isExpanded: isExpanded,
          itemHeight: itemHeight,
          focusColor: focusColor,
          focusNode: focusNode,
          autofocus: autofocus,
          dropdownColor: dropdownColor,
          decoration: decoration,
          onSaved: onSaved,
          validator: required ? ValidationBuilder().requiredValidator() : null,
        );
}
