import 'dart:async';

import 'package:oppo/functions/fetchcountry.dart';
import 'package:oppo/model/country.dart';
import 'package:oppo/model/countrycodes.dart';

class Validators {
  //receivers String sends String
  final validateEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      if (email.contains('@'))
        {
          sink.add(email);
        }else{
        sink.addError('Enter a valid email');
      }
    }
  );

  final validatePassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink)
    {
      if(password.length > 4)
        {
          sink.add(password);
        }else{
          sink.addError('Password must be atleast 5 characters');
      }
    }
  );


  final validateCountry = StreamTransformer<String,String>.fromHandlers(
      handleData: (String country,sink)
      {

        if(country.length >= 4 || country.toLowerCase()=='usa' || country.toLowerCase()=='uk' )
        {


          String x =CountryCodes.map[country];
          print('$x');
          if(x!=null) {
            final future = FetchCountry.fetchCountry(country);
            future.then((Country value) => sink.add(value)).catchError((err) {
              sink.addError("$country is not a country from future");
            });
          }
          else{
            sink.addError("Not found in our database");
          }

        }else{
          if(country.length==0){
            sink.addError("Field is empty");
          }else{
            sink.addError("$country is not a country");
          }
        }
      }
  );
}