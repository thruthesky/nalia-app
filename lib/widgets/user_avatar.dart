import './cache_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  UserAvatar(this.url, {this.size = 48, this.onTap});
  final String url;
  final double size;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    // print('url: $url');
    return GestureDetector(
      child: Container(
        width: size,
        height: size,
        child: url == null || url == ''
            ? Icon(Icons.person)
            : ClipOval(
                child: CacheImage(url),
              ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
          boxShadow: [
            BoxShadow(color: Colors.grey[300], blurRadius: 2.0, spreadRadius: 1.0),
          ],
        ),
      ),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
    );
  }
}
