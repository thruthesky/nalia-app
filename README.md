# nalia_app

# References

- [flutter-v3 branch](https://github.com/thruthesky/nalia_app/tree/flutter-v3) works with the [v3 `0.1` branch](https://github.com/thruthesky/v3/tree/0.1) works with. These two would be a good example.

# Coding Guideline

## File upload

```dart
try {
  final re = await app.imageUpload(
      quality: 95,
      onProgress: (int p) {
        print('Progress: $p');
      });
  print('file upload success: $re');
} catch (e) {
  if (e == ERROR_IMAGE_NOT_SELECTED) {
  } else {
    print('e: $e');
  }
}
```
