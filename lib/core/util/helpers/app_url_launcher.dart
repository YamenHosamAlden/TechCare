import 'package:url_launcher/url_launcher.dart';

Future<void> appUrlLauncher(String link) async {
  print(link);
  final Uri url = Uri.parse(link);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch');
  }
}
