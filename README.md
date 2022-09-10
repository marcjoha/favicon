Scrapes a website for favicons and orders them by image dimensions, or just return the best one. Example:

```dart
import 'package:favicon/favicon.dart';
var iconUrl = await FaviconFinder.getBest('https://www.mashable.com');
print(iconUrl);
```

Inspired by https://github.com/scottwernervt/favicon.

