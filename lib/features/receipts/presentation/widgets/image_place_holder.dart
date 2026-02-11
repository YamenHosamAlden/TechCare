import 'package:flutter/material.dart';
import 'package:tech_care_app/core/util/app_constants.dart';

class ImagePlaceHolder extends StatelessWidget {
  final String imagePath;
  final String? msg;
  final Color? textColor;
  const ImagePlaceHolder(
      {super.key, required this.imagePath, this.msg, this.textColor});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Durations.medium2,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
                dimension: 250,
                child: Image.asset(
                  imagePath,
                )),
            msg != null
                ? Text(
                    msg ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: textColor),
                    textAlign: TextAlign.center,
                  )
                : SizedBox(),
            // Gap(100),
          ],
        ),
      ),
    );
  }
}
