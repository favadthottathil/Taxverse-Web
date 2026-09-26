// Removes the splash screen once Flutter has rendered its first frame.
// External (not inline) so the Content-Security-Policy can forbid inline scripts.
window.addEventListener('flutter-first-frame', function () {
  var splash = document.getElementById('app-splash');
  if (!splash) return;
  splash.classList.add('app-splash-hidden');
  setTimeout(function () { splash.remove(); }, 400);
});
