import 'package:cached_network_image/cached_network_image.dart';
import './spinner.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatelessWidget {
  CacheImage(this.url);
  final String url;
  @override
  Widget build(BuildContext context) {
    // if (url.indexOf('http') != 0) return Icon(Icons.error);

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Spinner(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
