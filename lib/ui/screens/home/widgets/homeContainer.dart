import 'package:parent/app/routes.dart';
import 'package:parent/cubits/authCubit.dart';
import 'package:parent/cubits/noticeBoardCubit.dart';
import 'package:parent/cubits/schoolConfigurationCubit.dart';
import 'package:parent/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:parent/ui/screens/home/widgets/homeContainerTopProfileContainer.dart';
import 'package:parent/ui/screens/home/widgets/homeScreenDataLoadingContainer.dart';
import 'package:parent/ui/widgets/errorContainer.dart';
import 'package:parent/ui/widgets/latestNoticesContainer.dart';
import 'package:parent/ui/widgets/schoolGalleryContainer.dart';
import 'package:parent/ui/widgets/slidersContainer.dart';
import 'package:parent/ui/widgets/studentSubjectsContainer.dart';
import 'package:parent/utils/labelKeys.dart';
import 'package:parent/utils/systemModules.dart';
import 'package:parent/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomeContainer extends StatefulWidget {
  //Need this flag in order to show the homeContainer
  //in background when bottom menu is open

  //If it is just for background showing purpose then it will not reactive or not making any api call
  final bool isForBottomMenuBackground;
  const HomeContainer({Key? key, required this.isForBottomMenuBackground})
      : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  void initState() {
    super.initState();
    if (!widget.isForBottomMenuBackground) {
      Future.delayed(Duration.zero, () {
        fetchSubjectSlidersAndNoticeBoardDetails();
      });
    }
  }

  void fetchSubjectSlidersAndNoticeBoardDetails() {
    context.read<StudentSubjectsAndSlidersCubit>().fetchSubjectsAndSliders(
        useParentApi: false,
        isSliderModuleEnable: Utils.isModuleEnabled(
            context: context, moduleId: sliderManagementModuleId.toString()));

    if (Utils.isModuleEnabled(
        context: context,
        moduleId: announcementManagementModuleId.toString())) {
      context
          .read<NoticeBoardCubit>()
          .fetchNoticeBoardDetails(useParentApi: false);
    }
  }

  Widget _buildAdvertisemntSliders() {
    //
    final sliders = context.read<StudentSubjectsAndSlidersCubit>().getSliders();
    return SlidersContainer(sliders: sliders);
  }

  Widget _buildSlidersSubjectsAndLatestNotcies() {
    return BlocConsumer<StudentSubjectsAndSlidersCubit,
        StudentSubjectsAndSlidersState>(
      listener: (context, state) {
        if (state is StudentSubjectsAndSlidersFetchSuccess) {
          if (state.doesClassHaveElectiveSubjects &&
              state.electiveSubjects.isEmpty) {
            if (Get.currentRoute == Routes.selectSubjects) {
              return;
            }
            Get.toNamed(Routes.selectSubjects);
          }
        }
      },
      builder: (context, state) {
        if (state is StudentSubjectsAndSlidersFetchSuccess) {
          return RefreshIndicator(
            displacement: Utils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
            ),
            color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              context
                  .read<SchoolConfigurationCubit>()
                  .fetchSchoolConfiguration(useParentApi: false);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: Utils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
                ),
                bottom: Utils.getScrollViewBottomPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAdvertisemntSliders(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.025),
                  ),
                  StudentSubjectsContainer(
                    subjects: context
                        .read<StudentSubjectsAndSlidersCubit>()
                        .getSubjects(),
                    subjectsTitleKey: mySubjectsKey,
                    animate: !widget.isForBottomMenuBackground,
                  ),
                  Utils.isModuleEnabled(
                          context: context,
                          moduleId: announcementManagementModuleId.toString())
                      ? Column(
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * (0.025),
                            ),
                            LatestNoticiesContainer(
                              animate: !widget.isForBottomMenuBackground,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Utils.isModuleEnabled(
                          context: context,
                          moduleId: galleryManagementModuleId.toString())
                      ? SchoolGalleryContainer(
                          student:
                              context.read<AuthCubit>().getStudentDetails(),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
        }

        if (state is StudentSubjectsAndSlidersFetchFailure) {
          return Center(
            child: ErrorContainer(
              onTapRetry: () {
                context
                    .read<StudentSubjectsAndSlidersCubit>()
                    .fetchSubjectsAndSliders(
                        useParentApi: false,
                        isSliderModuleEnable: Utils.isModuleEnabled(
                            context: context,
                            moduleId: sliderManagementModuleId.toString()));
              },
              errorMessageCode: state.errorMessage,
            ),
          );
        }

        return HomeScreenDataLoadingContainer(
          addTopPadding: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: _buildSlidersSubjectsAndLatestNotcies(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: HomeContainerTopProfileContainer(),
        ),
      ],
    );
  }
}
