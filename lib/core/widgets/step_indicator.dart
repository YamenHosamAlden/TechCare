// import 'package:flutter/material.dart';
// import 'package:tech_care_app/core/util/app_colors.dart';

// class StepIndicatore extends StatelessWidget {
//   final int stepCount;
//   final int currentStep;
//   final Color completeStepColor;
//   final Color currentStepColor;
//   final Color incompleteStepColor;

//   const StepIndicatore({
//     super.key,
//     required this.stepCount,
//     required this.currentStep,
//     this.completeStepColor = AppColors.eucalyptusColor,
//     this.currentStepColor = AppColors.martiniqueColor,
//     this.incompleteStepColor = AppColors.silverColor,
//   }) : assert(
//           currentStep <= stepCount && 0 < currentStep,
//           'The current step number must be greater than zero and less than or equal to $stepCount',
//         );

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(stepCount, (index) {
//           final int realIndex = index + 1;
//           final Color backgroundColor;
//           final Color fontColor;
//           if (realIndex < currentStep) {
//             backgroundColor = completeStepColor;
//             fontColor = AppColors.whiteColor;
//           } else if (realIndex == currentStep) {
//             backgroundColor = currentStepColor;
//             fontColor = AppColors.whiteColor;
//           } else {
//             backgroundColor = incompleteStepColor;
//             fontColor = AppColors.silverChaliceColor;
//           }
//           return Container(
//             padding: const EdgeInsets.all(17),
//             margin: const EdgeInsets.all(5),
//             decoration: BoxDecoration(
//                 color: backgroundColor,
//                 shape: BoxShape.circle,
//                 boxShadow: realIndex == currentStep
//                     ? [
//                         const BoxShadow(
//                           blurRadius: 3,
//                           color: AppColors.blackColor,
//                         )
//                       ]
//                     : null),
//             child: Text(
//               realIndex.toString(),
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium
//                   ?.copyWith(color: fontColor),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
