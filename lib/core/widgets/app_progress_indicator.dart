import 'package:flutter/material.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';

class AppProgressIndicator extends StatefulWidget {
  final double height;
  final double? progress;
  const AppProgressIndicator({
    this.height = 40,
    this.progress,
    super.key,
  });

  @override
  State<AppProgressIndicator> createState() => _AppProgressIndicatorState();
}

class _AppProgressIndicatorState extends State<AppProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.extraSmallPadding)),
      child: Stack(
        children: [
          LinearProgressIndicator(
            minHeight: widget.height,
            color: AppColors.silverChaliceColor,
            value: 1,
          ),
          LinearProgressIndicator(
            minHeight: widget.height,
            value: widget.progress,
            color: AppColors.martiniqueColor,
          ),
          SizedBox(
            height: widget.height,
            child: Center(
              child: widget.progress == null
                  ? null
                  : Text(
                      "${(widget.progress! * 100).toStringAsFixed(0)} %",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color.lerp(AppColors.blackColor,
                              AppColors.whiteColor, widget.progress!)),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
