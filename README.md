Finds a website's favicon.

Inspired by https://github.com/scottwernervt/favicon.

## Usage

A simple usage example:

```dart
import 'package:favicon/favicon.dart';

main() async {
  var favicons = await Favicon.fetch('http://www.braziltravelblog.com/');
  print(favicons);
}
```
