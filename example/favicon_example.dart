import 'package:favicon/favicon.dart';

main() async {
  var urls = [
    'https://www.aftonbladet.se',
    'https://www.braziltravelblog.com',
    'https://www.mashable.com',
    'https://tradevenue.se/miljonarinnan30',
    'https://github.com/',
    'https://www.businessinsider.com/',
    'https://www.mrmoneymustache.com/',
    'https://thedividendstory.com/',
    'http://dailybeast.com'
  ];

  for (var url in urls) {
    print(await Favicon.getBest(url));
  }
}
