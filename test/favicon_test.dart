import 'package:favicon/favicon.dart';
import 'package:test/test.dart';

const FAVICONS = {
  'https://www.aftonbladet.se': 'https://www.aftonbladet.se/favicon-32x32.png',
  'https://www.braziltravelblog.com':
      'https://www.braziltravelblog.com/favicon.ico',
  'https://www.mashable.com': 'https://mashable.com/android-chrome-192x192.png',
  'https://tradevenue.se/miljonarinnan30':
      'https://tradevenue.se/sites/all/themes/tradevenue_theme/image/tradevenue_icon.png',
  'https://github.com/': 'https://github.githubassets.com/favicons/favicon.svg',
  'https://www.businessinsider.com/':
      'https://www.insider.com/public/assets/INSIDER/US/favicons/favicon-32x32.png',
  'https://www.mrmoneymustache.com/':
      'https://www.mrmoneymustache.com/favicon.ico',
  'https://thedividendstory.com/':
      'https://thedividendstory.com/wp-content/uploads/2019/02/cropped-icon_DS_transparentp-192x192.png',
  'http://dailybeast.com':
      'http://dailybeast.com/static/media/favicon.b30a79ed.ico',
  'https://www.traveldailynews.com/':
      'https://www.traveldailynews.com/uploads/images/setting/favicon.ico',
  'https://www.tenable.com/blog-rss':
      'https://www.tenable.com/sites/all/themes/tenablefourteen/img/favicons/favicon.svg',
  'https://hbr.org/': 'https://hbr.org/favicon.ico',
  'http://benfrain.com/': 'http://benfrain.com/favicon2.svg',
  'http://www.alistapart.com':
      'https://alistapart.com/wp-content/uploads/2019/03/cropped-icon_navigation-laurel-512.jpg',
  'https://fortune.com/':
      'https://content.fortune.com/wp-content/uploads/2020/02/favicon_144.ico',
  'https://tidochpengar.se/':
      'https://tidochpengar.se/wp-content/uploads/2020/11/cropped-165DF740-708F-41B2-AFA0-C17794A0480E-192x192.jpeg',
  'http://blog.tenablesecurity.com/atom.xml': null
};

void main() {
  for (var url in FAVICONS.keys) {
    test('Testing URL [$url]', () async {
      var icon = await Favicon.getBest(url);
      expect(icon?.url, equals(FAVICONS[url]));
    });
  }
}
