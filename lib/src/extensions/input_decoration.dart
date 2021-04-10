import 'package:flutter/material.dart';

extension InputDecorationExt on InputDecoration {
  InputDecoration from(final Map config) {
    if (config == null) {
      return this;
    }

    return this.copyWith(labelText: this.labelText + (config['required'] ? ' *' : ''));
  }
}