import 'package:flutter/material.dart';
import 'selections_orientation_define.dart';
import '../model/label_value.dart';

class LabeledCheckbox extends StatelessWidget {
  final String label;
  final bool checked;
  final String value;
  final bool disabled;
  final TextStyle labelStyle;
  final EdgeInsets padding;
  final Function onChanged;
  final Map optional;

  const LabeledCheckbox({
    Key key,
    this.label,
    this.checked,
    this.value,
    this.disabled,
    this.labelStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.onChanged,
    this.optional,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textLabelStyle = disabled
        ? labelStyle.apply(color: Theme.of(context).disabledColor)
        : labelStyle;

    return InkWell(
      onTap: disabled
          ? null
          : () {
              onChanged(value, !checked);
            },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              value: checked,
              onChanged: disabled
                  ? null
                  : (bool checked) {
                      var checkedElement = LabelValue(
                        label: label,
                        value: value,
                        optional: optional,
                      );
                      onChanged(checked, value, checkedElement);
                    },
            ),
            Text(label, style: textLabelStyle),
          ],
        ),
      ),
    );
  }
}

class CheckboxFormField extends StatefulWidget {
  final List<LabelValue> selections;
  final List<String> defaultValues;
  final List<String> disabled;
  final void Function(List<LabelValue> choices) onChange;
  final TextStyle labelStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final SelectionsOrientationDefine orientation;

  CheckboxFormField({
    Key key,
    this.selections,
    this.defaultValues = const [],
    this.disabled = const [],
    this.onChange,
    this.labelStyle = const TextStyle(),
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
    this.orientation = SelectionsOrientationDefine.HORIZONTAL,
  }) : super(key: key);

  @override
  _CheckboxFormFieldState createState() => _CheckboxFormFieldState();
}

class _CheckboxFormFieldState extends State<CheckboxFormField> {
  final Map<String, Map<String, Object>> _checkedValues = {};

  @override
  void initState() {
    super.initState();
    widget.selections.forEach((element) {
      _checkedValues[element.value] = {};
      _checkedValues[element.value]['checked'] =
          widget.defaultValues.contains(element.value);
      _checkedValues[element.value]['element'] = element;
    });

    if (widget.onChange != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((timeStamp) => {widget.onChange(_choices())});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<LabeledCheckbox> checkboxes = [];
    widget.selections.asMap().forEach(
      (index, LabelValue element) {
        bool disabled = widget.disabled.contains(element.value);

        var checkbox = LabeledCheckbox(
          label: element.label,
          checked: _checkedValues[element.value]['checked'],
          value: element.value,
          disabled: disabled,
          labelStyle: widget.labelStyle,
          onChanged: onChanged,
          optional: element.optional,
        );

        checkboxes.add(checkbox);
      },
    );

    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: widget.orientation == SelectionsOrientationDefine.HORIZONTAL
          ? Row(
              children: checkboxes,
            )
          : Column(
              children: checkboxes,
            ),
    );
  }

  void onChanged(bool checked, String value, LabelValue checkedElement) {
    setState(() {
      _checkedValues[value]['checked'] = checked;
      if (widget.onChange != null) {
        widget.onChange(_choices());
      }
    });
  }

  List<LabelValue> _choices() {
    List<LabelValue> choices = [];
    _checkedValues.forEach((key, value) {
      if (value['checked']) {
        choices.add(value['element']);
      }
    });

    return choices;
  }
}
