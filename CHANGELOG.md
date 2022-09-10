# 1.1

- Breaking change: Renaming classes to avoid conflicts with common Flutter libs
  - Favicon is now FaviconFinder
  - Icon is now Favicon

# 1.0.15

- Null-safety

# 1.0.14

- Updated dependencies
- Added unit tests

# 1.0.13

- Better validation of ICO file signature, an ico can also contain a PNG.
- Cleaned up code a bit.

# 1.0.12

- Validation of ICO file signaturee

# 1.0.11

- Support for filtering acceptable file extensions
- Trims query string from URL

# 1.0.10

- Fix for NPE at content type check

# 1.0.9

- Always look for a valid HTTP status code, non-zero content and an image response header.

# 1.0.8

- Trims whitespace before and after URLs

# 1.0.7

- Double-check content type for predefined URLs

# 1.0.6

- Fix for URLs with just path

# 1.0.5

- Fix for failure on multiple link tags
- Fix for NPE

# 1.0.4

- Will sort output based on image dimensions
- Added a getBest method

# 1.0.3

- Don't rely on HTTP 200 OK for predefined URLs, but check file size too

# 1.0.2

- Fix for relative URLs

# 1.0.1

- Fixed broken example

# 1.0.0

- Initial version, created by Stagehand
