import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String raw) async {
  final uri = Uri.tryParse(raw);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}
