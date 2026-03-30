import 'package:get/get.dart';
import 'package:nursing_family_app/app/modules/ai_today_summary/ai_today_summary_page.dart';
import 'package:nursing_family_app/app/modules/ai_visit_assistant/ai_visit_assistant_page.dart';
import 'package:nursing_family_app/app/modules/alert_history/alert_history_page.dart';
import 'package:nursing_family_app/app/modules/bills/bills_page.dart';
import 'package:nursing_family_app/app/modules/feedback/feedback_page.dart';
import 'package:nursing_family_app/app/modules/messages/messages_page.dart';
import 'package:nursing_family_app/app/modules/root/root_page.dart';
import 'package:nursing_family_app/app/modules/video_call/video_call_page.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.root, page: () => const RootView()),
    GetPage(name: AppRoutes.messages, page: () => const MessagesView()),
    GetPage(name: AppRoutes.bills, page: () => const BillsView()),
    GetPage(name: AppRoutes.feedback, page: () => const FeedbackView()),
    GetPage(name: AppRoutes.videoCall, page: () => const VideoCallView()),
    GetPage(name: AppRoutes.alertHistory, page: () => const AlertHistoryView()),
    GetPage(
      name: AppRoutes.aiTodaySummary,
      page: () => const AiTodaySummaryView(),
    ),
    GetPage(
      name: AppRoutes.aiVisitAssistant,
      page: () => const AiVisitAssistantView(),
    ),
  ];
}
