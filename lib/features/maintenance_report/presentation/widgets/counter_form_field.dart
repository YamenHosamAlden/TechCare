import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';

class CounterFormFeild extends FormField<int> {
  CounterFormFeild({
    Key? key,
    int? initialValue,
    CounterController? controller,
    ValueChanged<int>? onChanged,
    FormFieldValidator<int>? validator,
    AutovalidateMode? autovalidateMode,
    FormFieldSetter<int>? onSaved,
  }) : super(
          key: key,
          initialValue: controller?.value ?? (initialValue ?? 0),
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          onSaved: onSaved,
          builder: (FormFieldState<int> state) {
            void onChangedHandler(int value) {
              state.didChange(value);
              if (onChanged != null) {
                // onChanged(value);
              }
            }

            return CounterFeild(
              initialValue: initialValue,
              controller: controller,
              errorState: state.hasError,
              onChanged: onChangedHandler,
            );
          },
        );
}

class CounterFeild extends StatefulWidget {
  const CounterFeild({
    Key? key,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.errorState = false,
  }) : super(key: key);

  final int? initialValue;
  final CounterController? controller;
  final ValueChanged<int>? onChanged;
  final bool errorState;

  @override
  State<CounterFeild> createState() => _CounterFeildState();
}

class _CounterFeildState extends State<CounterFeild> {
  late CounterController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        CounterController(initialValue: widget.initialValue ?? 0);
    controller.addListener(_onValueChanged);
  }

  void _onValueChanged() {
    widget.onChanged?.call(controller.value);
  }

  @override
  void didUpdateWidget(covariant CounterFeild oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      controller.removeListener(_onValueChanged);
      controller = widget.controller ?? CounterController(initialValue: 0);
      controller.addListener(_onValueChanged);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onValueChanged);
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: controller,
        builder: (_, int counter, child) => Row(
              children: [
                SizedBox.square(
                  dimension: 40,
                  child: FloatingActionButton.small(
                    heroTag: 'increment',
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: AppColors.martiniqueColor,
                    splashColor: AppColors.eucalyptusColor.withOpacity(.5),
                    onPressed: controller.increment,
                    elevation: 0,
                    child: Icon(Icons.add_rounded, color: AppColors.whiteColor),
                  ),
                ),
                Gap(AppConstants.smallPadding),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border: widget.errorState
                        ? Border.all(color: AppColors.mojoColor)
                        : null,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(counter.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700)),
                ),
                Gap(AppConstants.smallPadding),
                SizedBox.square(
                  dimension: 40,
                  child: FloatingActionButton.small(
                    heroTag: 'decrement',
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: AppColors.martiniqueColor,
                    splashColor: AppColors.eucalyptusColor.withOpacity(.5),
                    onPressed: controller.decrement,
                    elevation: 0,
                    child:
                        Icon(Icons.remove_rounded, color: AppColors.whiteColor),
                  ),
                ),
              ],
            ));
  }
}

class CounterController extends ValueNotifier<int> {
  CounterController({int initialValue = 0}) : super(initialValue);

  void increment() {
    value = value + 1;
    notifyListeners();
  }

  void decrement() {
    value <= 0 ? null : value = value - 1;
    notifyListeners();
  }

  int get counter => value;

  set counter(int number) {
    value = number;
    notifyListeners();
  }

  @override
  void dispose() {
    ChangeNotifier.debugAssertNotDisposed(this);
    super.dispose();
  }
}
