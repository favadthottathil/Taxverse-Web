import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

void registerGoogleMapFactory(String viewType, String embedUrl) {
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    return html.IFrameElement()
      ..src = embedUrl
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.borderRadius = '12px'
      ..setAttribute('loading', 'lazy')
      ..setAttribute('referrerpolicy', 'no-referrer-when-downgrade')
      ..allowFullscreen = true;
  });
}
