import 'package:flutter/material.dart';
import 'selections_orientation_define.dart';
import '../model/label_value.dart';

class LabeledRadio extends StatelessWidget {
  final String label;
  final String groupValue;
  final String value;
  final bool disabled;
  final TextStyle labelStyle;
  final EdgeInsets padding;
  final Function onChanged;
  final Map optional;

  const LabeledRadio({
    Key key,
    this.label,
    this.groupValue,
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
              if (value != groupValue) {
                onChanged(value);
              }
            },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio(
              groupValue: groupValue,
              value: value,
              onChanged: disabled
                  ? null
                  : (String newValue) {
                      var selectedElement = LabelValue(
                        label: label,
                        value: value,
                        optional: optional,
                      );
                      onChanged(newValue, selectedElement);
                    },
            ),
            Text(label, style: textLabelStyle),
          ],
        ),
      ),
    );
  }
}

class RadioFormField extends StatefulWidget {
  final List<LabelValue> selections;
  final List<String> disabled;
  final String defaultValue;
  final void Function(LabelValue value) onChange;
  final TextStyle labelStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final SelectionsOrientationDefine orientation;

  RadioFormField({
    Key key,
    this.selections,
    this.disabled = const [],
    this.defaultValue,
    this.onChange,
    this.labelStyle = const TextStyle(),
    this.orientation = SelectionsOrientationDefine.HORIZONTAL,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  _RadioFormFieldState createState() => _RadioFormFieldState();
}

class _RadioFormFieldState extends State<RadioFormField> {
  String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.defaultValue == null
        ? widget.selections[0].value
        : widget.defaultValue;

    if (widget.onChange != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        for (int i = 0; i < widget.selections.length; i++) {
          if (widget.selections[i].value == widget.defaultValue) {
            _selected = widget.selections[i].value;
            widget.onChange(widget.selections[i]);
            break;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<LabeledRadio> radios = [];
    widget.selections.asMap().forEach(
      (index, LabelValue element) {
        radios.add(
          LabeledRadio(
            label: element.label,
            value: element.value,
            groupValue: _selected,
            disabled: (widget.disabled != null &&
                widget.disabled.contains(element.value)),
            labelStyle: widget.labelStyle,
            onChanged: onChanged,
            optional: element.optional,
          ),
        );
      },
    );

    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: widget.orientation == SelectionsOrientationDefine.HORIZONTAL
          ? Row(
              children: radios,
            )
          : Column(
              children: radios,
            ),
    );
  }

  void onChanged(String newValue, LabelValue selectedElement) {
    setState(() {
      _selected = newValue;
      if (widget.onChange != null) {
        widget.onChange(selectedElement);
      }
    });
  }
}
