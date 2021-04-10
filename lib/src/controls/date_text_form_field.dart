import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'config.dart';
import 'validation/validator_builder.dart';
import '../extensions/datetime.dart';
import '../extensions/input_decoration.dart';

class DateTextFormField extends StatefulWidget {
  DateTextFormField({
    this.key,
    this.initialValue,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.toolbarOptions,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    // this.maxLength,
    // this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.required = false,
    this.validationBuilder,
    TextEditingController controller,
  }) : _controller = controller ??
            (controller == null ? TextEditingController() : controller);

  final Key key;
  final String initialValue;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final ToolbarOptions toolbarOptions;
  final bool showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int maxLines;
  final int minLines;
  final bool expands;

  // final int maxLength;

  // final ValueChanged<String> onChanged;
  final GestureTapCallback onTap;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldSetter<String> onSaved;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final double cursorHeight;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls selectionControls;
  final InputCounterWidgetBuilder buildCounter;
  final ScrollPhysics scrollPhysics;
  final Iterable<String> autofillHints;
  final AutovalidateMode autovalidateMode;
  final bool required;
  final ValidationBuilder validationBuilder;
  final TextEditingController _controller;

  @override
  _DateTextFormFieldState createState() =>
      _DateTextFormFieldState(controller: _controller);
}

class _DateTextFormFieldState extends State<DateTextFormField> {
  _DateTextFormFieldState({this.controller}) : super();

  final iconFocusNode = FocusNode(skipTraversal: true);
  final TextEditingController controller;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        currentDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      controller.text = picked.format(DateFormatDefine.yMd);
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = widget.decoration.copyWith(
      suffixIcon: IconButton(
        focusNode: iconFocusNode,
        icon: Icon(FontAwesomeIcons.calendar),
        onPressed: () => _selectDate(context),
      ),
    );

    return TextFormField(
      key: widget.key,
      controller: controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      decoration: decoration.from({'required': widget.required}),
      keyboardType: TextInputType.visiblePassword,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction ?? config['textInputAction'],
      style: widget.style,
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      toolbarOptions: widget.toolbarOptions,
      showCursor: widget.showCursor,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: 10,
      //widget.maxLength,
      // onChanged: widget.onChanged,
      onChanged: (text) {
        String value = text.replaceAll(RegExp(r'[/]'), '');
        DateTime dt = DateTime.tryParse(value);
        if (dt == null) {
          var values = text.split("/");
          if (values.length != 3) {
            return;
          }
          dt = DateTime.tryParse(
              "${values[0]}${values[1].padLeft(2, "0")}${values[2].padLeft(2, "0")}");
          if (dt == null) {
            return;
          }
        }

        controller.text = dt.format(DateFormatDefine.yMd);
        setState(() {
          selectedDate = dt;
        });
      },
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      buildCounter: widget.buildCounter,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      autovalidateMode: widget.autovalidateMode,
      validator: ValidationBuilder(required: widget.required)
          .from(widget.validationBuilder)
          .date()
          .build(),
    );
  }
}
