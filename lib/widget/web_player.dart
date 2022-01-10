import "package:universal_html/html.dart";
import 'package:behandam/utils/fake_ui.dart' if (dart.library.html) 'package:behandam/utils/real_ui.dart' as ui;
import 'package:flutter/material.dart';

///Working well in Windows, Linux, MacOS, iOS and Android Mobile Web / PWA
class WebVideoElement extends StatefulWidget {

final String src;
final double startAt = 0;
final bool autoplay = false;
final bool controls = true;

const WebVideoElement(this.src);

@override
_WebVideoElementState createState() => _WebVideoElementState();
}

class _WebVideoElementState extends State<WebVideoElement> {
@override
void initState() {
super.initState();

String? URL = widget.src + '#t=${widget.startAt}';
// Do not remove the below comment - Fix for missing ui.platformViewRegistry in dart.ui
// ignore: undefined_prefixed_name
ui.platformViewRegistry.registerViewFactory(widget.src, (int viewId) {
//https: //api.flutter.dev/flutter/dart-html/VideoElement-class.html
final video = VideoElement()
..src = URL
..autoplay = widget.autoplay
..controls = widget.controls
..style.border = 'none'
..style.borderColor = 'red'
..style.height = '100%'
..style.width = '100%';

// Allows Safari iOS to play the video inline
video.setAttribute('playsinline', 'true');

return video;
});
}

@override
Widget build(BuildContext context) {
return HtmlElementView(viewType: widget.src);
}
}