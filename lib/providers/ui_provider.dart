import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {
  //Variable compartida
  int _selectedMenuOpt = 0;
  int get selectedMenuOpt {
    return this._selectedMenuOpt;
  }

  set selectedMenuOpt(int i) {
    this._selectedMenuOpt = i;
    notifyListeners();
  }
}
