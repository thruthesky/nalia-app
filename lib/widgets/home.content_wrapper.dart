import 'package:flutter/material.dart';
import 'package:nalia_app/services/defines.dart';

class HomeContentWrapper extends StatefulWidget {
  HomeContentWrapper({this.child, this.header});
  final Widget child;
  final Widget header;
  @override
  _HomeContentWrapperState createState() => _HomeContentWrapperState();
}

class _HomeContentWrapperState extends State<HomeContentWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.header != null) widget.header,
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: sm, right: sm),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(sm),
                        topRight: Radius.circular(sm),
                      ),
                    ),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
