import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/modules/ai_today_summary/ai_today_summary_page.dart';
import 'package:nursing_family_app/app/modules/ai_visit_assistant/ai_visit_assistant_page.dart';
import 'package:nursing_family_app/app/modules/alert_history/alert_history_page.dart';
import 'package:nursing_family_app/app/modules/bills/bills_page.dart';
import 'package:nursing_family_app/app/modules/feedback/feedback_page.dart';
import 'package:nursing_family_app/app/modules/health/health_page.dart';
import 'package:nursing_family_app/app/modules/home/home_page.dart';
import 'package:nursing_family_app/app/modules/messages/messages_page.dart';
import 'package:nursing_family_app/app/modules/nursing/nursing_page.dart';
import 'package:nursing_family_app/app/modules/profile/profile_page.dart';
import 'package:nursing_family_app/app/modules/root/root_page.dart';
import 'package:nursing_family_app/app/modules/video_call/video_call_page.dart';
import 'package:nursing_family_app/app/modules/visit/visit_page.dart';

class FamilyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MockFamilyService(), permanent: true);

    Get.lazyPut(() => RootController(), fenix: true);
    Get.lazyPut(() => HomeController(Get.find()), fenix: true);
    Get.lazyPut(() => HealthController(Get.find()), fenix: true);
    Get.lazyPut(() => NursingController(Get.find()), fenix: true);
    Get.lazyPut(() => VisitController(Get.find()), fenix: true);
    Get.lazyPut(() => ProfileController(Get.find()), fenix: true);
    Get.lazyPut(() => MessagesController(Get.find()), fenix: true);
    Get.lazyPut(() => BillsController(Get.find()), fenix: true);
    Get.lazyPut(FeedbackController.new, fenix: true);
    Get.lazyPut(() => VideoCallController(Get.find()), fenix: true);
    Get.lazyPut(() => AlertHistoryController(Get.find()), fenix: true);
    Get.lazyPut(() => AiTodaySummaryController(Get.find()), fenix: true);
    Get.lazyPut(() => AiVisitAssistantController(Get.find()), fenix: true);
  }
}
