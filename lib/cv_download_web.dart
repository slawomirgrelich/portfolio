import 'dart:html' as html;

void openCv() {
  try {
    html.window.open('cv.pdf', '_blank');
  } catch (_) {
    return;
  }
}