import 'package:favicon/favicon.dart';
import 'package:test/test.dart';

const FAVICONS = {
  'https://www.aftonbladet.se':
      'https://www.aftonbladet.se/cnp-assets/favicon-8447eb68/coast-228x228.png',
  'https://www.braziltravelblog.com':
      'https://www.braziltravelblog.com/wp-content/uploads/2021/04/cropped-brazil_small_flag-192x192.jpg',
  'https://www.mashable.com':
      'https://www.mashable.com/favicons/android-chrome-512x512.png',
  'https://tradevenue.se/miljonarinnan30':
      'https://cdn.32b23e.net/tradevenue/favicon.6567f653.png',
  'https://github.com/': 'https://github.githubassets.com/favicons/favicon.svg',
  'https://www.businessinsider.com/':
      'https://www.businessinsider.com/public/assets/BI/US/favicons/favicon-32x32.png',
  'https://www.mrmoneymustache.com/':
      'https://www.mrmoneymustache.com/favicon.ico',
  'https://thedividendstory.blogspot.com/':
      'https://thedividendstory.blogspot.com/favicon.ico',
  'http://dailybeast.com':
      'http://dailybeast.com/static/media/favicon.b30a79ed.ico',
  'https://www.tenable.com/blog-rss':
      'https://www.tenable.com/themes/custom/tenable/img/favicons/favicon.svg',
  'https://hbr.org/':
      'https://hbr.org/resources/images/android-chrome-512x512.png',
  'http://benfrain.com/': 'http://benfrain.com/favicon2.svg',
  'http://www.alistapart.com':
      'https://i0.wp.com/alistapart.com/wp-content/uploads/2019/03/cropped-icon_navigation-laurel-512.jpg',
  'https://fortune.com/': 'https://fortune.com/icons/favicons/favicon.ico',
  'https://tidochpengar.se/':
      'https://tidochpengar.b-cdn.net/wp-content/uploads/2020/11/cropped-165DF740-708F-41B2-AFA0-C17794A0480E-192x192.jpeg',
  'http://blog.tenablesecurity.com/atom.xml': null
};

void main() {
  for (var url in FAVICONS.keys) {
    test('Testing URL [$url]', () async {
      var icon = await FaviconFinder.getBest(url);
      expect(icon?.url, equals(FAVICONS[url]));
    });
  }
}
