
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/components/feedback_text_field.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as clipper;

class SubmitFeedback {
  final BuildContext context;

  SubmitFeedback(
      {required this.context,});

  Future<void> show() async {
    await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => const _SubmitFeedbackDialog());
  }

}

class _SubmitFeedbackDialog extends StatefulWidget {
  const _SubmitFeedbackDialog({Key? key}) : super(key: key);

  @override
  State<_SubmitFeedbackDialog> createState() => _SubmitFeedbackDialogState();
}

class _SubmitFeedbackDialogState extends State<_SubmitFeedbackDialog> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController subjectController = TextEditingController();
  TextEditingController descController = TextEditingController();

  final ValueNotifier<String> _subjectFieldError = ValueNotifier("");
  final ValueNotifier<String> _descriptionFieldError = ValueNotifier("");

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 65.w : 21.w),
        child: Container(
          color:kDarkDividerColor,
          height: isTablet ? 520.h : 480.h,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: ClipPath(
                    clipper: RightTriangleClipper(
                      orientation: clipper.Orientation.Orientation_NW,
                    ),
                    child: Container(
                      color: kTransactionRed,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: ClipPath(
                    clipper: RightTriangleClipper(
                        orientation:  clipper.Orientation.Orientation_SE),
                    child: Container(
                      color: kTransactionRed,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "submit_feedback".tr(),
                        style: TextStyle(
                          color: kBlack,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FeedBackTextField(
                              label: "subject".tr(),
                              noOfLines: 1,
                              controller: subjectController,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  _subjectFieldError.value = "enter_subject_text";
                                  return;
                                }
                                _subjectFieldError.value = '';
                                return null;
                              },
                            ),
                            ValueListenableBuilder<String>(
                                valueListenable: _subjectFieldError,
                                builder: (_, String subjectFieldError, __) {
                                  if (subjectFieldError.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.w, right: 10.w, top: 2.h),
                                    child: Text(
                                      subjectFieldError.tr(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: 10.h,
                            ),
                            FeedBackTextField(
                              label: "description".tr(),
                              noOfLines: 5,
                              controller: descController,
                              textCapitalization: TextCapitalization.sentences,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(kMaxDescription)
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  _descriptionFieldError.value =
                                      "enter_description_text";
                                  return;
                                }
                                _descriptionFieldError.value = '';
                                return null;
                              },
                            ),
                            ValueListenableBuilder<String>(
                                valueListenable: _descriptionFieldError,
                                builder: (_, String descriptionFieldError, __) {
                                  if (descriptionFieldError.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.w, right: 10.w, top: 2.h),
                                    child: Text(
                                      descriptionFieldError.tr(),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }),
                            ValueListenableBuilder(
                                valueListenable: descController,
                                builder: (_, TextEditingValue controller, __) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "character_limit".tr(args: [(kMaxDescription - controller.text.length).toString() ]),
                                          style: TextStyle(
                                              color: kCopyColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: 20.h,
                            ),

                          ],
                        ),
                      ),

                      CustomPaintButton(
                          title: "submit".tr(),
                          bgColor:kBlue,
                          width: 200.w,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (_subjectFieldError.value.isNotEmpty ||
                                _descriptionFieldError.value.isNotEmpty) {
                              return;
                            }
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
