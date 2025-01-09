import 'package:parent/cubits/authCubit.dart';
import 'package:parent/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:parent/data/models/subject.dart';
import 'package:parent/ui/widgets/customBackButton.dart';
import 'package:parent/ui/widgets/errorContainer.dart';
import 'package:parent/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:parent/ui/widgets/shimmerLoaders/subjectsShimmerLoadingContainer.dart';
import 'package:parent/ui/widgets/studentSubjectsContainer.dart';
import 'package:parent/utils/labelKeys.dart';
import 'package:parent/utils/systemModules.dart';
import 'package:parent/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ReportSubjectsContainer extends StatefulWidget {
  final int? childId;
  final List<Subject>? subjects;
  const ReportSubjectsContainer({Key? key, this.childId, this.subjects})
      : super(key: key);

  @override
  ReportSubjectsContainerState createState() => ReportSubjectsContainerState();

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return ReportSubjectsContainer(
      childId: arguments['childId'],
      subjects: arguments['subjects'],
    );
  }
}

class ReportSubjectsContainerState extends State<ReportSubjectsContainer> {
  List<Subject>? subjects;

  @override
  void initState() {
    super.initState();
    if (widget.subjects != null) subjects = List.from(widget.subjects!);
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      heightPercentage: Utils.appBarSmallerHeightPercentage,
      child: Stack(
        children: [
          context.read<AuthCubit>().isParent()
              ? CustomBackButton(
                  topPadding: MediaQuery.of(context).padding.top +
                      Utils.appBarContentTopPadding,
                )
              : const SizedBox.shrink(),
          Align(
            child: Text(
              Utils.getTranslatedLabel(subjectsKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: Utils.screenTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMySubjects() {
    //remove blank subject entry [added for all assignment filter from previous screen]
    if (context.read<AuthCubit>().isParent() && subjects != null)
      subjects!.removeWhere((element) => element.id == 0);
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
        ),
      ),
      child: (context.read<AuthCubit>().isParent())
          ? StudentSubjectsContainer(
              subjects: subjects!,
              subjectsTitleKey: '', //already shown in title
              childId: widget.childId,
              showReport: true,
            )
          : BlocBuilder<StudentSubjectsAndSlidersCubit,
              StudentSubjectsAndSlidersState>(
              builder: (context, state) {
                if (state is StudentSubjectsAndSlidersFetchSuccess) {
                  return StudentSubjectsContainer(
                    subjects: context
                        .read<StudentSubjectsAndSlidersCubit>()
                        .getSubjects(),
                    subjectsTitleKey: '', //already shown in title
                    childId: context.read<AuthCubit>().getStudentDetails().id,
                    showReport: true,
                  );
                }
                if (state is StudentSubjectsAndSlidersFetchFailure) {
                  return Center(
                    child: ErrorContainer(
                      errorMessageCode: state.errorMessage,
                      onTapRetry: () {
                        context
                            .read<StudentSubjectsAndSlidersCubit>()
                            .fetchSubjectsAndSliders(
                                useParentApi:
                                    (context.read<AuthCubit>().isParent()),
                                isSliderModuleEnable: Utils.isModuleEnabled(
                                    context: context,
                                    moduleId:
                                        sliderManagementModuleId.toString()));
                      },
                    ),
                  );
                }
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (0.025),
                    ),
                    const SubjectsShimmerLoadingContainer(),
                  ],
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (context.read<AuthCubit>().isParent())
        ? Scaffold(
            body: Stack(
              children: [
                _buildMySubjects(),
                Align(
                  alignment: Alignment.topCenter,
                  child: _buildAppBar(),
                ),
              ],
            ),
          )
        : Stack(
            children: [
              _buildMySubjects(),
              Align(
                alignment: Alignment.topCenter,
                child: _buildAppBar(),
              ),
            ],
          );
  }
}
