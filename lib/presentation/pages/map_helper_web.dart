import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;

void registerGoogleMapFactory(String viewType, String embedUrl) {
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = web.HTMLIFrameElement()
      ..src = embedUrl
      ..allowFullscreen = true
      ..setAttribute('loading', 'lazy')
      ..setAttribute('referrerpolicy', 'strict-origin-when-cross-origin')
      // Google's embed needs scripts and its own origin; popups cover the
      // "View larger map" links. Everything else (top navigation, forms,
      // modals, downloads) stays blocked.
      ..setAttribute(
        'sandbox',
        'allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox',
      );
    iframe.style
      ..border = 'none'
      ..width = '100%'
      ..height = '100%'
      ..borderRadius = '12px';
    return iframe;
  });
}
