import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';

class Icon implements Comparable<Icon> {
  String url;
  int width;
  int height;

  Icon(this.url, {this.width = 0, this.height = 0});

  @override
  int compareTo(Icon other) {
    // If both are vector graphics, use URL length as tie-breaker
    if (url.endsWith('.svg') && other.url.endsWith('.svg')) {
      return url.length < other.url.length ? -1 : 1;
    }

    // Sort vector graphics before bitmaps
    if (url.endsWith('.svg')) return -1;
    if (other.url.endsWith('.svg')) return 1;

    // If bitmap size is the same, use URL length as tie-breaker
    if (width * height == other.width * other.height) {
      return url.length < other.url.length ? -1 : 1;
    }

    // Sort on bitmap size
    return (width * height > other.width * other.height) ? -1 : 1;
  }

  @override
  String toString() {
    return '{Url: $url, width: $width, height: $height}';
  }
}

class Favicon {
  static Future<List<Icon>> getAll(String url) async {
    var favicons = <Icon>[];
    var iconUrls = <String>[];

    var uri = Uri.parse(url);
    var document = parse((await http.get(url)).body);

    // Look for icons in tags
    for (var rel in ['icon', 'shortcut icon']) {
      for (var iconTag in document.querySelectorAll("link[rel='$rel']")) {
        if (iconTag != null && iconTag.attributes['href'] != null) {
          var iconUrl = iconTag.attributes['href'];

          // Fix scheme relative URLs
          if (iconUrl.startsWith('//')) {
            iconUrl = uri.scheme + ':' + iconUrl;
          }

          // Fix relative URLs
          if (iconUrl.startsWith('/')) {
            iconUrl = uri.scheme + '://' + uri.host + iconUrl;
          }

          // Fix naked URLs
          if (!iconUrl.startsWith('http')) {
            iconUrl = uri.scheme + '://' + uri.host + '/' + iconUrl;
          }

          iconUrls.add(iconUrl);
        }
      }
    }

    // Look for icon by predefined URL
    var iconUrl = uri.scheme + '://' + uri.host + '/favicon.ico';
    var response = await http.get(iconUrl);
    if (response.statusCode == 200 &&
        response.contentLength > 0 &&
        response.headers['content-type'].contains('image')) {
      iconUrls.add(iconUrl);
    }

    // Dedup
    iconUrls = iconUrls.toSet().toList();

    // Fetch dimensions
    for (var iconUrl in iconUrls) {
      // No need for size calculation on vector images
      if (iconUrl.endsWith('.svg')) {
        favicons.add(Icon(iconUrl));
        continue;
      }

      // Image library lacks read support for Ico, assume standard size
      // https://github.com/brendan-duncan/image/issues/212
      if (iconUrl.endsWith('.ico')) {
        favicons.add(Icon(iconUrl, width: 16, height: 16));
        continue;
      }

      var image = decodeImage((await http.get(iconUrl)).bodyBytes);
      if (image != null) {
        favicons.add(Icon(iconUrl, width: image.width, height: image.height));
      }
    }

    return favicons..sort();
  }

  static Future<Icon> getBest(String url) async {
    List<Icon> favicons = await getAll(url);
    return favicons.isNotEmpty ? favicons.first : null;
  }
}
