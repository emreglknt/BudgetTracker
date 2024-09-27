import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

var locator = GetIt.instance;

Future<void> getInit()async{

}

Future<void> _initComponents()async{
  locator.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());
}