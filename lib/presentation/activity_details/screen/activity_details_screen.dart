import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:run_flutter_run/presentation/activity_details/widgets/details_tab.dart';
import 'package:run_flutter_run/presentation/activity_details/widgets/graph_tab.dart';

import '../../../domain/entities/activity.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/activity_details_view_model.dart';

/// The screen that displays details of a specific activity.
class ActivityDetailsScreen extends HookConsumerWidget {
  final Activity activity;

  const ActivityDetailsScreen({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activityDetailsViewModelProvider);
    final provider = ref.read(activityDetailsViewModelProvider.notifier);

    final tabController = useTabController(initialLength: 2);

    final displayedActivity = state.activity ?? activity;

    return Scaffold(
      body: state.isLoading
          ? const Center(child: UIUtils.loader)
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 25, top: 12),
                    child: Row(children: [
                      Icon(
                        ActivityUtils.getActivityTypeIcon(
                            displayedActivity.type),
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        ActivityUtils.translateActivityTypeValue(
                          AppLocalizations.of(context)!,
                          displayedActivity.type,
                        ),
                        style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        color: Colors.black,
                        tooltip: 'Edit',
                        onPressed: () {
                          tabController.animateTo(0);
                          provider.editType();
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blueGrey,
                        ),
                      ),
                      IconButton(
                        color: Colors.black,
                        tooltip: 'Remove',
                        onPressed: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: AppLocalizations.of(context)!
                                .ask_activity_removal,
                            confirmBtnText:
                                AppLocalizations.of(context)!.delete,
                            cancelBtnText: AppLocalizations.of(context)!.cancel,
                            confirmBtnColor: Colors.red,
                            onCancelBtnTap: () => Navigator.of(context)!.pop(),
                            onConfirmBtnTap: () =>
                                provider.removeActivity(displayedActivity),
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ]),
                  ),
                  Expanded(
                      child: DefaultTabController(
                          length: 2,
                          child: Scaffold(
                              appBar: TabBar(
                                  controller: tabController,
                                  labelColor: Colors.blueGrey,
                                  dividerColor: Colors.blueGrey,
                                  indicatorColor: Colors.blueGrey,
                                  tabs: [
                                    Tab(
                                      text:
                                          AppLocalizations.of(context)!.details,
                                    ),
                                    Tab(
                                      text: AppLocalizations.of(context)!.graph,
                                    ),
                                  ]),
                              body: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Expanded(
                                        child: DetailsTab(activity: activity)),
                                    Expanded(
                                        child: GraphTab(activity: activity))
                                  ]))))
                ],
              ),
            ),
    );
  }
}
