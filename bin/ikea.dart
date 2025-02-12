import 'dart:io';

import 'package:dart_ping/dart_ping.dart';

// 44-91-60-30-e2-2f, 0IElI8aZHhUPWrLy

// {"9091":"Dlt3MbAm9jaG15ww","9029":"1.21.0031"}

// Get from:
// coap-client -m post -u "Client_identity" -k "0IElI8aZHhUPWrLy" -e "{\"9090\":\"julemand101\"}" "coaps://192.168.0.107:5684/15011/9063"
const username = 'julemand101';
const password = 'Dlt3MbAm9jaG15ww';
const ikeaIp = '192.168.0.107';

void main() async {
  print(':: IKEA TRÅDFRI Speaker Watcher Service Started...');
  HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print(':: HttpServer started...');

  await for (HttpRequest request in server) {
    final remoteIp = request.connectionInfo!.remoteAddress.address;
    HttpResponse response = request.response;

    print(
      ':: Incoming HTTP request to: ${request.requestedUri.path} '
      'from: $remoteIp',
    );

    if (request.requestedUri.path.endsWith('on')) {
      print(':: Power on speakers');
      callIkea(true);
      startPingWatchdog(remoteIp);
      response.write('Turned on for: $remoteIp');
    } else if (request.requestedUri.path.endsWith('off')) {
      print(':: Power off speakers');
      callIkea(false);
      stopPingWatchdog();
      response.write('Speakers turned off.');
    } else {
      response.write('Please call service with /on or /off');
    }

    await response.flush();
    await response.close();
  }
}

Ping? pingProcess;

void startPingWatchdog(String ip) async {
  stopPingWatchdog();

  pingProcess = Ping(ip, interval: 10, timeout: 5);
  int failedPingCount = 0;

  await for (PingData ping in pingProcess!.stream) {
    if (ping.error != null) {
      print(':: Ping failed: ${ping.error} . Count: ${++failedPingCount}');

      if (failedPingCount >= 3 && pingProcess != null) {
        callIkea(false);
        stopPingWatchdog();
      }
    } else if (failedPingCount != 0) {
      failedPingCount = 0;
      print(':: Ping count reset after successful ping');
    }
  }
  print(':: Ping process stopped for: $ip');
}

void stopPingWatchdog() {
  pingProcess?.stop();
  pingProcess = null;
}

void callIkea(bool toggle) {
  Process.run('/usr/bin/coap-client', [
    '-m',
    'put',
    '-u',
    username,
    '-k',
    password,
    '-e',
    '{ "3312": [{ "5850": ${toggle ? 1 : 0} }] }',
    'coaps://$ikeaIp:5684/15001/65545',
  ]);
}
