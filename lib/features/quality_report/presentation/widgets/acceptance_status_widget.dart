import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';

class AcceptanceStatusWidget extends StatefulWidget {
  final void Function(bool acceptance) onChanged;
  const AcceptanceStatusWidget({super.key, required this.onChanged});

  @override
  State<AcceptanceStatusWidget> createState() => _AcceptanceStatusWidgetState();
}

class _AcceptanceStatusWidgetState extends State<AcceptanceStatusWidget> {
  bool _acceptanceStatus = true;

  void _accept() {
    if (_acceptanceStatus != true) {
      setState(() {
        _acceptanceStatus = true;
      });
      widget.onChanged(true);
    }
  }

  void _reject() {
    if (_acceptanceStatus != false) {
      setState(() {
        _acceptanceStatus = false;
      });
      widget.onChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAcceptButton(),
          Gap(AppConstants.mediumPadding),
          _buildRejectButton(),
        ],
      ),
    );
  }

  Widget _buildAcceptButton() {
    return _buildOptionButton(
      onPressed: () {
        _accept();
      },
      buttonColor: AppColors.eucalyptusColor,
      isActive: _acceptanceStatus,
      child: Column(
        children: [
          Expanded(
              child: Center(
            child: Container(
              padding: EdgeInsets.all(AppConstants.mediumPadding),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                  border: Border.all()),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.eucalyptusColor,
                size: 50,
              ),
            ),
          )),
          Center(
              child: Text('accepted'.tr)),
        ],
      ),
    );
  }

  Widget _buildRejectButton() {
    return _buildOptionButton(
      onPressed: () {
        _reject();
      },
      buttonColor: AppColors.mojoColor,
      isActive: !_acceptanceStatus,
      child: Column(
        children: [
          Expanded(
              child: Center(
            child: Container(
              padding: EdgeInsets.all(AppConstants.mediumPadding),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                  border: Border.all()),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.mojoColor,
                size: 50,
              ),
            ),
          )),
          Center(
              child: Text('rejected'.tr)),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
      {required void Function()? onPressed,
      required bool isActive,
      required buttonColor,
      required Widget child}) {
    return AnimatedContainer(
        clipBehavior: Clip.antiAlias,
        duration: Durations.medium2,
        decoration: BoxDecoration(
            color: isActive
                ? buttonColor.withOpacity(.6)
                : Colors.grey.withOpacity(.5),
            borderRadius: BorderRadius.circular(AppConstants.smallPadding),
            border: isActive ? Border.all(color: Colors.yellow) : null),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Padding(
              padding: EdgeInsets.all(AppConstants.smallPadding),
              child: child,
            ),
            AspectRatio(
              aspectRatio: .8,
              child: MaterialButton(
                onPressed: onPressed,
              ),
            ),
          ],
        ));
  }
}
