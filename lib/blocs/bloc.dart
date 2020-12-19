import 'package:rxdart/rxdart.dart';
import 'validators.dart';
import 'dart:async';


class Bloc with Validators{

  final _countryController = BehaviorSubject<String>();

  Function(String) get addCountryStream => _countryController.sink.add;

  Stream<String> get getCountryStream => _countryController.stream.transform(validateCountry);

  submit(){
    final validCountry = _countryController.value;
    print('$validCountry is valid');
  }
  dispose(){
    _countryController.close();
  }

}


