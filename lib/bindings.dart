
import 'package:dash_board/controllers/MenuAppController.dart';
import 'package:dash_board/controllers/api_controller.dart';
import 'package:dash_board/screens/dashboard/user/user_controller/user_chat_controller.dart';
import 'package:dash_board/widgets/theme_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {

   Get.lazyPut<MenuAppController>(() => MenuAppController());
   Get.lazyPut<ApiController>(() => ApiController());
   Get.lazyPut<UserChatController>(() => UserChatController());
   Get.lazyPut<ThemeController>(() => ThemeController());

  }
}