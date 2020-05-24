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
    'http://dailybeast.com',
    'https://www.traveldailynews.com/',
    'https://www.tenable.com/blog-rss',
    'http://blog.tenablesecurity.com/atom.xml', // Should fail and yield null
    'https://hbr.org/',
  ];

  for (var url in urls) {
    print(await Favicon.getBest(url));
  }
}
