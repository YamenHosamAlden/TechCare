import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/app/app_localization.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';
import 'package:tech_care_app/core/widgets/custom_text_form_field.dart';
import 'package:tech_care_app/features/device_details/presentation/bloc/device_details_bloc/device_details_bloc.dart';

class AddNoteDilaog extends StatefulWidget {
  const AddNoteDilaog({super.key});

  @override
  State<AddNoteDilaog> createState() => _AddNoteDilaogState();
}

class _AddNoteDilaogState extends State<AddNoteDilaog> {
  late final TextEditingController noteController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    noteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();

    super.dispose();
  }

  void _submitNote() {
    FocusScope.of(context).unfocus();
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<DeviceDetailsBloc>(context)
          .add(AddNote(note: noteController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceDetailsBloc, DeviceDetailsState>(
      // listenWhen: (previous, current) =>
      //     previous.noteAdded == false && previous.noteAdded == true,
      listener: (context, state) {
        if (state.noteAdded) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.mediumPadding + 3),
        ),
        backgroundColor: AppColors.alabasterColor,
        contentPadding: EdgeInsets.all(0),
        titlePadding: EdgeInsets.all(0),
        iconPadding: EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: BlocBuilder<DeviceDetailsBloc, DeviceDetailsState>(
            bloc: BlocProvider.of<DeviceDetailsBloc>(context),
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.martiniqueColor),
                    child: Icon(
                      Icons.note_add_rounded,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  Gap(AppConstants.mediumPadding),
                  Text(
                   'add_note'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.mediumPadding),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: autovalidateMode,
                      child: CustomTextFormField(
                        controller: noteController,
                        minLines: 3,
                        maxLines: 100,
                        hintText:
                            'note'.tr,
                        validator: (note) => note == null || note.trim().isEmpty
                            ? 'plz_note'.tr
                            : null,
                      ),
                    ),
                  ),
                  state.loadingNote
                      ? SizedBox(
                          height: 48,
                          child: Center(child: CircularProgressIndicator()))
                      : ElevatedButton(
                          onPressed: () {
                            _submitNote();
                          },
                          child: Text(
                              'create'.tr)),
                  Gap(AppConstants.mediumPadding),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
