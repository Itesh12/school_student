import 'package:parent/app/routes.dart';
import 'package:parent/cubits/appConfigurationCubit.dart';
import 'package:parent/cubits/authCubit.dart';
import 'package:parent/ui/widgets/errorContainer.dart';
import 'package:parent/utils/animationConfiguration.dart';
import 'package:parent/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static Widget routeInstance() {
    return SplashScreen();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<AppConfigurationCubit>().fetchAppConfiguration();
    });
  }

  void navigateToNextScreen() {
    if (context.read<AuthCubit>().state is Unauthenticated) {
      Get.offNamed(Routes.auth);
    } else {
      Get.offNamed(
        (context.read<AuthCubit>().state as Authenticated).isStudent
            ? Routes.home
            : Routes.parentHome,
      );
    }
  }

  // void fetchAndSetUserProfile() {
  //   Future.delayed(Duration.zero, () {
  //     context.read<UserProfileCubit>().fetchAndSetUserProfile();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppConfigurationCubit, AppConfigurationState>(
        listener: (context, appConfigState) {
          if (appConfigState is AppConfigurationFetchSuccess) {
            navigateToNextScreen();
          }
        },
        builder: (context, appConfigState) {
          if (appConfigState is AppConfigurationFetchFailure) {
            return Center(
              child: ErrorContainer(
                onTapRetry: () {
                  context.read<AppConfigurationCubit>().fetchAppConfiguration();
                },
                errorMessageCode: appConfigState.errorMessage,
              ),
            );
          }

          return Center(
            child: Animate(
              effects: customItemZoomAppearanceEffects(
                delay: const Duration(
                  milliseconds: 10,
                ),
                duration: const Duration(
                  seconds: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: SvgPicture.asset(
                  Utils.getImagePath("appLogo.svg"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
