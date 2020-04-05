import 'package:favicon/favicon.dart';

main() async {
  var favicons = await Favicon.getAll('http://www.braziltravelblog.com/');
  print(favicons);
}
