import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';

class CodeScannerDialog extends StatefulWidget {
  const CodeScannerDialog({super.key});

  @override
  State<CodeScannerDialog> createState() => _CodeScannerDialogState();
}

class _CodeScannerDialogState extends State<CodeScannerDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Durations.extralong4,
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<AlignmentGeometry> _animation1 =
      Tween<AlignmentGeometry>(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    audioPlayer.setReleaseMode(ReleaseMode.stop).then((value) =>
        audioPlayer.setSource(AssetSource(AppStrings.scannerBeepPath)));
    ;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: Material(
          clipBehavior: Clip.antiAlias,
          color: AppColors.alabasterColor,
          borderRadius: BorderRadius.circular(AppConstants.mediumPadding + 3),
          child: SizedBox(
            width: 500,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    2 /
                    3, // Set the maximum height
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close)),
                  ),
                  CircleAvatar(
                    radius: 25,
                    child: Icon(
                      Icons.barcode_reader,
                      size: 35,
                      // color: AppColors.martiniqueColor,
                    ),
                  ),
                  Gap(AppConstants.mediumPadding),
                  Text(
                    'scn_qr_plz'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Gap(AppConstants.mediumPadding),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(AppConstants.mediumPadding),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: AppColors.blackColor,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.mediumPadding)),
                          child: Stack(
                            children: [
                              MobileScanner(
                                controller: MobileScannerController(),
                                onDetect:
                                    (BarcodeCapture barcodeCapture) async {
                                  if (barcodeCapture.barcodes.firstOrNull ==
                                      null) {
                                    return;
                                  }
                                  final String? _code =
                                      barcodeCapture.barcodes.first.rawValue;

                                  audioPlayer.resume();
                                  await Future.delayed(Durations.medium2);

                                  Navigator.canPop(context)
                                      ? Navigator.pop(context, _code)
                                      : null;
                                },
                              ),
                              scanning_animation_line(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(AppConstants.mediumPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AlignTransition scanning_animation_line() {
    return AlignTransition(
        alignment: _animation1,
        child: Container(
          height: 25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueAccent.withOpacity(0),
                Colors.blueAccent.withOpacity(.5),
                Colors.blueAccent.withOpacity(0),
              ],
            ),
          ),
        ));
  }
}
