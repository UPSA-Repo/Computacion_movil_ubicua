import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/multiple_analysis.dart';
import '../pages/edit_comment.page.dart';
import '../pages/home.page.dart';
import '../pages/list_dataset.page.dart';
import '../pages/microphone.page.dart';
import '../pages/multiple_results.page.dart';
import '../pages/new_dataset.page.dart';
import '../pages/single_text_input.page.dart';
import '../pages/dataset_selection.page.dart';
import '../pages/single_result.page.dart';

class Routes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const HomePage(),
    '/single-text-input': (context) => SingleTextInputPage(),
    '/dataset-selection': (context) => DatasetSelectionPage(),
    '/list-dataset': (context) => ListDatasetPage(
          messages: ModalRoute.of(context)?.settings.arguments as List<Message>,
        ),
    '/new-dataset': (context) => NewDatasetPage(),
    '/edit-comment': (context) => EditCommentPage(comment: ''),
    '/results': (context) => SingleResultPage(
        messageContent: ModalRoute.of(context)?.settings.arguments as String),
    '/multiple-results': (context) => MultipleResultsPage(
        messages:
            ModalRoute.of(context)?.settings.arguments as MultipleAnalysis),
    '/microphone': (context) => MicrophonePage(),
  };
}
