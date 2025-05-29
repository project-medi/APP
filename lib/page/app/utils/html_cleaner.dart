import 'package:xml/xml.dart';

String parseEEDoc(String raw) {
  try {
    final document = XmlDocument.parse(raw);
    // ignore: non_constant_identifier_names
    final Paragraphs = document.findAllElements('PARAGRAPH');
    return Paragraphs.map((p) => p.innerText.trim()).join('\n');
  } catch (_) {
    return '';
  }
}
