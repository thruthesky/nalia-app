# nalia_app

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
