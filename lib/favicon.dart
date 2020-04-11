import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Favicon {
  static Future<List<String>> getAll(String url) async {
    var favicons = <String>[];

    var uri = Uri.parse(url);
    var document = parse((await http.get(url)).body);

    // Look for icons in tags
    for (var rel in ['icon', 'shortcut icon']) {
      var iconTag = document.querySelector("link[rel='$rel']");
      var iconUrl = (iconTag != null && iconTag.attributes['href'] != null)
          ? iconTag.attributes['href']
          : null;

      // Fix scheme relative URLs
      iconUrl = iconUrl != null && iconUrl.startsWith('//')
          ? uri.scheme + ':' + iconUrl
          : iconUrl;

      // Fix relative URLs
      iconUrl = iconUrl != null && iconUrl.startsWith('/')
          ? uri.scheme + '://' + uri.host + iconUrl
          : iconUrl;

      if (iconUrl != null) {
        favicons.add(iconUrl);
      }
    }

    // Look for icon by predefined URL
    var iconUrl = uri.scheme + '://' + uri.host + '/favicon.ico';
    var response = await http.get(iconUrl);
    if (response.statusCode == 200 && response.contentLength > 0) {
      favicons.add(iconUrl);
    }

    // Dedup and sort by URL length
    favicons = favicons.toSet().toList();
    favicons.sort((String a, String b) => a.length >= b.length ? -1 : 1);

    return favicons;
  }
}
