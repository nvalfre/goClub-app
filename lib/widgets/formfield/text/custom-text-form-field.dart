import 'package:flutter/material.dart';
import 'package:flutter_go_club_app/widgets/formfield/decoration/input-decoration-builder.dart';
import 'package:flutter_go_club_app/widgets/formfield/text/validators/text-form-validators-builders.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController _controller;
  final TextFormFieldValidatorBuilder _validatorBuilder;
  final InputDecorationBuilder _decorationBuilder;
  final bool _obscure;
  final Key _key;
  final TextCapitalization _textCapitalization;
  final TextInputType _keyboardType;

  CustomTextFormField(
      {@required TextEditingController controller,
      @required TextFormFieldValidatorBuilder validatorBuilder,
      @required InputDecorationBuilder decorationBuilder,
      bool obscure = false,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextInputType keyboardType = TextInputType.text,
      Key key})
      : this._controller = controller,
        this._validatorBuilder = validatorBuilder,
        this._decorationBuilder = decorationBuilder,
        this._obscure = obscure,
        this._textCapitalization = textCapitalization,
        this._keyboardType = keyboardType,
        this._key = key;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: _keyboardType,
        textCapitalization: _textCapitalization,
        key: _key,
        controller: _controller,
        decoration: _decorationBuilder.build(context),
        validator: _validatorBuilder.build(context),
        obscureText: _obscure);
  }
}
