import 'package:flutter/widgets.dart';
import 'package:get_localization/get_localization.dart';

abstract class BaseLocalization extends Localization {
  BaseLocalization({
    @required String code,
    @required String name,
    String country,
  }) : super(
          code: code,
          name: name,
          country: country,
        );

  
}
