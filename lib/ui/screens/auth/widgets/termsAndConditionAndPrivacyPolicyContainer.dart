import 'package:parent/app/routes.dart';
import 'package:parent/utils/labelKeys.dart';
import 'package:parent/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditionAndPrivacyPolicyContainer extends StatelessWidget {
  const TermsAndConditionAndPrivacyPolicyContainer({Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            // InkWell(
            //   onTap: () {
            //     onTapCheckButton();
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: Theme.of(context).colorScheme.primary,
            //         border: Border.all(color: Colors.transparent)),
            //     alignment: Alignment.center,
            //     child: termsAndConditionAccepted
            //         ? Icon(
            //             Icons.check,
            //             size: 15,
            //             color: Theme.of(context).scaffoldBackgroundColor,
            //           )
            //         : SizedBox(),
            //     width: 20,
            //     height: 20,
            //   ),
            // ),
            // SizedBox(
            //   width: 8,
            // ),
            Text(
              Utils.getTranslatedLabel(
                termsAndConditionAgreementKey,
              ),
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(Routes.termsAndCondition);
              },
              child: Text(
                Utils.getTranslatedLabel(termsAndConditionKey),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              "&",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.privacyPolicy);
              },
              child: Text(
                Utils.getTranslatedLabel(privacyPolicyKey),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
