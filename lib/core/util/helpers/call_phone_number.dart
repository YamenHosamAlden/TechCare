import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String number) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: number,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    print('Could not launch $launchUri');
  }
}
