// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
// import 'package:tech_care_app/app/app_localization.dart';
// import 'package:tech_care_app/core/util/app_colors.dart';
// import 'package:tech_care_app/core/util/app_constants.dart';
// import 'package:tech_care_app/core/util/input_Formatters/price_input_formatter.dart';
// import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
// import 'package:tech_care_app/features/finished_receipts/presentation/finishing_report_bloc/finishing_report_bloc.dart';

// class CheckoutDialog extends StatefulWidget {
//   const CheckoutDialog({super.key});

//   @override
//   State<CheckoutDialog> createState() => _CheckoutDialogState();
// }

// class _CheckoutDialogState extends State<CheckoutDialog> {
//   late final TextEditingController paymentController;
//   late final TextEditingController noteController;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

//   @override
//   void initState() {
//     paymentController = TextEditingController();
//     noteController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     paymentController.dispose();
//     noteController.dispose();
//     super.dispose();
//   }

//   void _checkout() {
//     FocusScope.of(context).unfocus();
//     setState(() {
//       autovalidateMode = AutovalidateMode.always;
//     });
//     if (_formKey.currentState?.validate() ?? false) {
//       BlocProvider.of<FinishingReportBloc>(context).add(Checkout(
//           amount: num.parse(paymentController.text.replaceAll(',', '').trim()),
//           note: noteController.text));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<FinishingReportBloc, FinishingReportState>(
//       bloc: BlocProvider.of<FinishingReportBloc>(context),
//       listenWhen: (previous, current) => current.finished,
//       listener: (context, state) {
//         if (state.finished) {
//           if (Navigator.canPop(context)) {
//             Navigator.pop(context);
//           }
//         }
//       },
//       child: AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppConstants.mediumPadding + 3),
//         ),
//         backgroundColor: AppColors.alabasterColor,
//         contentPadding: EdgeInsets.all(0),
//         titlePadding: EdgeInsets.all(AppConstants.mediumPadding),
//         iconPadding: EdgeInsets.all(0),
//         content: SingleChildScrollView(
//           child: BlocBuilder<FinishingReportBloc, FinishingReportState>(
//             bloc: BlocProvider.of<FinishingReportBloc>(context),
//             builder: (context, state) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: IconButton(
//                         padding: EdgeInsets.zero,
//                         onPressed: () => Navigator.of(context).pop(),
//                         icon: const Icon(Icons.close)),
//                   ),
//                   TweenAnimationBuilder<double>(
//                       duration: Durations.extralong4 * 1,
//                       tween: Tween(begin: 0, end: 1),
//                       curve: Curves.easeInOutExpo,
//                       builder: (context, value, child) {
//                         return RichText(
//                           text: TextSpan(
//                             text: 'total_payment'.tr + '. ',
//                             children: [
//                               TextSpan(
//                                   text: state.finishingReport!.finalCost,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleMedium!
//                                       .copyWith(
//                                         fontWeight: FontWeight.w900,
//                                         color: AppColors.eucalyptusColor,
//                                       )),
//                             ],
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleSmall!
//                                 .copyWith(fontWeight: FontWeight.w700),
//                           ),
//                         );
//                       }),
//                   Padding(
//                     padding: const EdgeInsets.all(AppConstants.mediumPadding),
//                     child: Form(
//                       key: _formKey,
//                       autovalidateMode: autovalidateMode,
//                       child: Column(
//                         children: [
//                           CustomTextFormField(
//                               controller: paymentController,
//                               keyboardType: TextInputType.numberWithOptions(
//                                   decimal: true),
//                               inputFormatters: [
//                                 // FilteringTextInputFormatter.allow(
//                                 //   RegExp(r'^\d*\.?\d*$'),

//                                 // ),
//                                 PriceInputFormatter(),
//                               ],
//                               hintText: 'amount_received'.tr,
//                               validator: (payment) {
//                                 if (payment == null || payment.isEmpty) {
//                                   return 'required'.tr;
//                                 }
//                                 // try {
//                                 //   num.parse(payment);
//                                 // } catch (e) {
//                                 //   return
//                                 //     'invalid'.tr;
//                                 // }
//                                 return null;
//                               }),
//                           Gap(AppConstants.mediumPadding),
//                           CustomTextFormField(
//                             controller: noteController,
//                             minLines: 3,
//                             maxLines: 100,
//                             hintText: 'note'.tr,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   state.checkoutLoading
//                       ? SizedBox(
//                           height: 48,
//                           child: Center(child: CircularProgressIndicator()))
//                       : ElevatedButton(
//                           onPressed: () {
//                             _checkout();
//                           },
//                           child: Text(
//                             'submit'.tr,
//                           )),
//                   Gap(AppConstants.mediumPadding),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
