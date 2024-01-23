import 'package:dash_board/utils/urls.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketController extends GetxController {
  late Socket socket;
  String? socketId;

  @override
  void onInit() {
    // Initialize and configure your Socket.io connection here
    socket = io('${WebApi.basesUrl}', <String, dynamic>{
      'transports': ['websocket'],
    });

    // Event to get the socket ID
    socket.on('connect', (_) {
      socketId = socket.id;
      update(); // Notify listeners about the socket ID
    });

    super.onInit();
  }
  void closeSocket() {
    if (socket != null && !socket.disconnected) {
      socket.disconnect();
    }
  }
}
