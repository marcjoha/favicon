import 'package:favicon/favicon.dart';

main() async {
  var favicon = await Favicon.getBest('https://www.github.com');
  print(favicon);
}
