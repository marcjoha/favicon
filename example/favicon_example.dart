import 'package:favicon/favicon.dart';

main() async {
  var favicons = await Favicon.getAll('https://thedividendstory.com/');
  print(favicons);
}
