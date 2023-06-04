import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/activity_list_view_model.dart';

class BackToHomeButton extends HookConsumerWidget {
  const BackToHomeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(activityListViewModelProvider.notifier);

    return FloatingActionButton(
      elevation: 4.0,
      child: const Icon(Icons.arrow_back),
      onPressed: () {
        provider.backToHome(context);
      },
    );
  }
}