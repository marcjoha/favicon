import 'dart:typed_data';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';

// Signatures from https://en.wikipedia.org/wiki/List_of_file_signatures
const ICO_SIG = [0, 0, 1, 0];
const PNG_SIG = [137, 80, 78, 71, 13, 10, 26, 10];

class Favicon implements Comparable<Favicon> {
  String url;
  int width;
  int height;

  Favicon(this.url, {this.width = 0, this.height = 0});

  @override
  int compareTo(Favicon other) {
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

class FaviconFinder {
  static Future<List<Favicon>> getAll(
    String url, {
    List<String>? suffixes,
  }) async {
    if (!_verifyDomain(url)) {
      throw ArgumentError('Invalid URL');
    }

    var favicons = <Favicon>[];
    var iconUrls = <String>[];

    var uri = Uri.parse(url);
    var document = parse((await http.get(uri)).body);

    // Look for icons in tags
    for (var rel in ['icon', 'shortcut icon']) {
      for (var iconTag in document.querySelectorAll("link[rel='$rel']")) {
        if (iconTag.attributes['href'] != null) {
          var iconUrl = iconTag.attributes['href']!.trim();

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

          // Remove query strings
          iconUrl = iconUrl.split('?').first;

          // Verify so the icon actually exists
          if (await _verifyImage(iconUrl)) {
            iconUrls.add(iconUrl);
          }
        }
      }
    }

    // Look for icon by predefined URL
    var iconUrl = uri.scheme + '://' + uri.host + '/favicon.ico';
    if (await _verifyImage(iconUrl)) {
      iconUrls.add(iconUrl);
    }

    // Deduplicate
    iconUrls = iconUrls.toSet().toList();

    // Filter on suffixes
    if (suffixes != null) {
      iconUrls.removeWhere((url) => !suffixes.contains(url.split('.').last));
    }

    // Fetch dimensions
    for (var iconUrl in iconUrls) {
      // No need for size calculation on vector images
      if (iconUrl.endsWith('.svg')) {
        favicons.add(Favicon(iconUrl));
        continue;
      }

      // Image library lacks read support for Ico, assume standard size
      // https://github.com/brendan-duncan/image/issues/212
      if (iconUrl.endsWith('.ico')) {
        favicons.add(Favicon(iconUrl, width: 16, height: 16));
        continue;
      }

      var image = decodeImage((await http.get(Uri.parse(iconUrl))).bodyBytes);
      if (image != null) {
        favicons.add(Favicon(iconUrl, width: image.width, height: image.height));
      }
    }

    return favicons..sort();
  }

  static Future<Favicon?> getBest(String url, {List<String>? suffixes}) async {
    List<Favicon> favicons = await getAll(url, suffixes: suffixes);
    return favicons.isNotEmpty ? favicons.first : null;
  }

  /// Verifies if the given URL has a valid domain.
  ///
  /// This method checks if the URL has a valid scheme (either 'http' or 'https')
  /// and if the domain follows a specific pattern. The domain pattern is checked
  /// using a regular expression.
  ///
  /// If the URL parsing or domain pattern matching throws an exception, this
  /// method will return [false].
  ///
  /// Returns [true] if the URL has a valid domain, otherwise returns [false].
  static bool _verifyDomain(String url) {
    try {
      var uri = Uri.parse(url);

      // Verify the scheme (must be either 'http' or 'https')
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return false;
      }

      // Check the domain pattern using a regular expression
      var domainPattern = RegExp(
          r'^(([a-zA-Z]{1})|([a-zA-Z]{1}[a-zA-Z]{1})|([a-zA-Z]{1}[0-9]{1})|([0-9]{1}[a-zA-Z]{1})|([a-zA-Z0-9]+[a-zA-Z0-9-]+[a-zA-Z0-9]))(\.([a-zA-Z]{2,})+)+$');
      return domainPattern.hasMatch(uri.host);
    } catch (e) {
      // Return false if an exception occurs during URL parsing or domain pattern matching
      return false;
    }
  }

  static Future<bool> _verifyImage(String url) async {
    var response = await http.get(Uri.parse(url));

    var contentType = response.headers['content-type'];
    if (contentType == null || !contentType.contains('image')) return false;

    // Take extra care with ico's since they might be constructed manually
    if (url.endsWith('.ico')) {
      if (response.bodyBytes.length < 4) return false;

      // Check if ico file contains a valid image signature
      if (!_verifySignature(response.bodyBytes, ICO_SIG) &&
          !_verifySignature(response.bodyBytes, PNG_SIG)) {
        return false;
      }
    }

    return response.statusCode == 200 &&
        (response.contentLength ?? 0) > 0 &&
        contentType.contains('image');
  }

  static bool _verifySignature(Uint8List bodyBytes, List<int> signature) {
    var fileSignature = bodyBytes.sublist(0, signature.length);
    for (var i = 0; i < fileSignature.length; i++) {
      if (fileSignature[i] != signature[i]) return false;
    }
    return true;
  }
}
