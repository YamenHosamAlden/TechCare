import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/app_strings.dart';
import 'package:tech_care_app/core/widgets/dialogs/confirm_dialog.dart';

class CodesValidationScannerDialog extends StatefulWidget {
  final List<String> codes;
  const CodesValidationScannerDialog({super.key, required this.codes});

  @override
  State<CodesValidationScannerDialog> createState() =>
      _SacnnReceivableDialogState();
}

class _SacnnReceivableDialogState extends State<CodesValidationScannerDialog>
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

  final List<String> scannedCodes = [];
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    audioPlayer
      ..setReleaseMode(ReleaseMode.stop).then((value) =>
          audioPlayer.setSource(AssetSource(AppStrings.scannerBeepPath)));
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  String? _msg;

  set msg(String? msg) {
    setState(() {
      _msg = msg;
    });
  }

  Timer? timer;

  resSetMsg() {
    timer?.cancel();
    timer = Timer(Durations.extralong4 * 1, () {
      msg = null;
    });
  }

  checkScannedCode(String code) async {
    if (!widget.codes.contains(code)) {
      msg = "unkown_bar".tr;
      ;
      resSetMsg();
    }
    if (scannedCodes.contains(code)) {
      msg = 'bar_has_been_scnd'.tr;
      resSetMsg();
    }
    if (widget.codes.contains(code) && !scannedCodes.contains(code)) {
      msg = 'bar_scnd_sucfuly'.tr;
      resSetMsg();
      await audioPlayer.resume();
      setState(() {
        scannedCodes.add(code);
      });
      if (widget.codes.length == scannedCodes.length) {
        _returnScannedCodes();
      }
    }
  }

  _returnScannedCodes() {
    Navigator.of(context).pop<List<String>>(scannedCodes);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: Material(
          clipBehavior: Clip.antiAlias,
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppConstants.mediumPadding + 3),
          child: SizedBox(
            width: 500,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    4 /
                    5, // Set the maximum height
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
                  // Gap(AppConstants.mediumPadding),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.mediumPadding),
                      child: _buildScanner(),
                      // child: Center(child: Text('asdasd')),
                    ),
                  ),
                  Gap(AppConstants.mediumPadding),
                  Text(
                    _msg ??
                        'plz_scn_bars'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Expanded(
                    child:
                        // Text('data')
                        ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.mediumPadding),
                      itemCount: widget.codes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                // contentPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.mediumPadding)),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.codes.elementAt(index),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                    if (!scannedCodes.contains(
                                        widget.codes.elementAt(index)))
                                      TextButton(
                                          onPressed: () {
                                            ConfirmDialog.show(
                                              context,
                                              title: "note".tr,
                                              message:
                                                  "skip_device_code_scan".tr,
                                              onConfirm: () {
                                                checkScannedCode(widget.codes
                                                    .elementAt(index));
                                              },
                                            );
                                          },
                                          child: Text('skip'.tr))
                                  ],
                                ),
                                dense: true,
                                leading: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                onTap: () {},
                                trailing: SizedBox.square(
                                    dimension: 15,
                                    child: scannedCodes.contains(
                                            widget.codes.elementAt(index))
                                        ? Icon(
                                            Icons.check_rounded,
                                            color: AppColors.eucalyptusColor,
                                          )
                                        : CupertinoActivityIndicator()),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AspectRatio _buildScanner() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: AppColors.blackColor,
            borderRadius: BorderRadius.circular(AppConstants.mediumPadding)),
        child: Stack(
          children: [
            MobileScanner(
              onDetect: (BarcodeCapture barcodeCapture) async {
                if (barcodeCapture.barcodes.firstOrNull == null) {
                  return;
                }
                final String? _code = barcodeCapture.barcodes.first.rawValue;
                if (_code != null) {
                  await checkScannedCode(_code);
                }
              },
            ),
            scanning_animation_line(),
          ],
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
