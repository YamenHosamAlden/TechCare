import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/util/input_Formatters/phone_input_formatter.dart';
import 'package:tech_care_app/core/util/input_validators/phone_number_validator.dart';
import 'package:tech_care_app/core/widgets/custom_country_code_picker.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/features/receipts_container_details/presentation/bloc/edit_receipt_bloc/edit_receipt_bloc.dart';

editPhoneBottomSheet(BuildContext context, {required EditReceiptBloc bloc}) {
  TextEditingController editPhoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.mediumPadding),
            topRight: Radius.circular(AppConstants.mediumPadding))),
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.mediumPadding,
            vertical: AppConstants.smallPadding),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                thickness: 4,
                color: AppColors.eucalyptusColor,
              ),
              Gap(
                AppConstants.mediumPadding,
              ),
              Text("edit_phone_number".tr),
              Gap(
                AppConstants.mediumPadding,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Gap(
                          AppConstants.mediumPadding,
                        ),
                        CustomTextFormField(
                          controller: editPhoneController,
                          hintTextDirection:
                              AppLocalizations.getTextDirection(context),
                          textAlign: TextAlign.end,
                          suffixIcon: CustomCountryCodePicker(
                              initialSelection: bloc.state.countryCode,
                              onChanged: (code) => bloc
                                  .add(CountryCodeChanged(countryCode: code))),
                          hintText: 'customer_phone_number'.tr,
                          // onChanged: (phone) => bloc.add(
                          //     CustomerPhoneChanged(customerPhone: phone)),
                          validator: (phoneNumber) {
                            if (phoneNumber == null || phoneNumber.isEmpty) {
                              return 'plz_customer_phone'.tr;
                            } else if (!isPhoneNumber(phoneNumber)) {
                              return 'plz_valid_phone'.tr;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                            ArabicNumberTextInputFormatter(),
                          ],
                        ),
                        Gap(
                          AppConstants.mediumPadding,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              bloc.add(CustomerPhoneChanged(
                                  customerPhone: bloc.state.countryCode +
                                      (editPhoneController.text[0] == '0'
                                          ? editPhoneController.text
                                              .substring(1)
                                          : editPhoneController.text)));
                              Navigator.of(context).pop();
                            }
                          },
                          child: Center(child: Text('done'.tr)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
