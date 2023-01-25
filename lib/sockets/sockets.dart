import 'package:socket_io_client/socket_io_client.dart';
import 'package:waya_driver/constants/api_constants.dart';

class ConnectToServer {
  //configure socket transport
  Socket socket = io(
    //api here
      ApiConstants.baseUrl,
      OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
          .build());

  //connect to websockets
  connect(){
    //connect to websockets
    socket.connect();

    // //handle socket events
    // socket.on('connection', (_) => print('connect: ${socket.id}'));
    // socket.on('disconnect', (_) => print('disconnect'));
  }

  //disconnect from websockets
  disconnect(){
    socket.disconnect();
  }

  void sendDriverLocation(data){
    socket.emit("searchForDrivers", data);
  }
}

