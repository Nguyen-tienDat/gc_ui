// lib/services/sfu_websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class SfuWebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  bool _isConnected = false;

  // Callbacks
  Function(RTCSessionDescription)? onOfferReceived;
  Function(RTCSessionDescription)? onAnswerReceived;
  Function(RTCIceCandidate)? onIceCandidateReceived;
  Function(Map<String, dynamic>)? onParticipantJoined;
  Function(String)? onParticipantLeft;
  Function(String)? onError;
  Function()? onConnected;
  Function()? onDisconnected;

  bool get isConnected => _isConnected;

  Future<void> connect({
    required String sfuUrl,
    required String roomId,
    required String accessToken,
    required String participantId,
  }) async {
    try {
      print('🔌 Connecting to SFU WebSocket...');

      final wsUrl = '$sfuUrl?roomId=$roomId&token=$accessToken&participantId=$participantId';
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );

      _isConnected = true;
      onConnected?.call();

      print('✅ Connected to SFU WebSocket');
    } catch (e) {
      print('❌ Failed to connect to SFU: $e');
      onError?.call('Connection failed: $e');
      rethrow;
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final type = data['type'];

      print('📨 Received SFU message: $type');

      switch (type) {
        case 'offer':
          _handleOffer(data['data']);
          break;
        case 'answer':
          _handleAnswer(data['data']);
          break;
        case 'ice-candidate':
          _handleIceCandidate(data['data']);
          break;
        case 'participant-joined':
          onParticipantJoined?.call(data['data']);
          break;
        case 'participant-left':
          onParticipantLeft?.call(data['data']['participantId']);
          break;
        case 'error':
          onError?.call(data['data']['message']);
          break;
        default:
          print('⚠️ Unknown SFU message type: $type');
      }
    } catch (e) {
      print('❌ Error handling SFU message: $e');
      onError?.call('Message handling error: $e');
    }
  }

  void _handleOffer(Map<String, dynamic> offerData) {
    try {
      final offer = RTCSessionDescription(
        offerData['sdp'],
        offerData['type'],
      );
      onOfferReceived?.call(offer);
    } catch (e) {
      print('❌ Error handling offer: $e');
    }
  }

  void _handleAnswer(Map<String, dynamic> answerData) {
    try {
      final answer = RTCSessionDescription(
        answerData['sdp'],
        answerData['type'],
      );
      onAnswerReceived?.call(answer);
    } catch (e) {
      print('❌ Error handling answer: $e');
    }
  }

  void _handleIceCandidate(Map<String, dynamic> candidateData) {
    try {
      final candidate = RTCIceCandidate(
        candidateData['candidate'],
        candidateData['sdpMid'],
        candidateData['sdpMLineIndex'],
      );
      onIceCandidateReceived?.call(candidate);
    } catch (e) {
      print('❌ Error handling ICE candidate: $e');
    }
  }

  void _handleError(dynamic error) {
    print('❌ SFU WebSocket error: $error');
    _isConnected = false;
    onError?.call('WebSocket error: $error');
  }

  void _handleDisconnect() {
    print('🔌 SFU WebSocket disconnected');
    _isConnected = false;
    onDisconnected?.call();
  }

  // Send messages to SFU
  void sendOffer(RTCSessionDescription offer) {
    _sendMessage('publish', {
      'sdp': offer.toMap(),
    });
  }

  void sendAnswer(RTCSessionDescription answer) {
    _sendMessage('answer', {
      'sdp': answer.toMap(),
    });
  }

  void sendIceCandidate(RTCIceCandidate candidate, String type) {
    _sendMessage('ice-candidate', {
      'candidate': candidate.toMap(),
      'type': type, // 'publisher' or 'subscriber'
    });
  }

  void requestSubscription() {
    _sendMessage('subscribe', {});
  }

  void _sendMessage(String type, Map<String, dynamic> data) {
    if (!_isConnected || _channel == null) {
      print('⚠️ Cannot send message: WebSocket not connected');
      return;
    }

    try {
      final message = jsonEncode({
        'type': type,
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      _channel!.sink.add(message);
      print('📤 Sent SFU message: $type');
    } catch (e) {
      print('❌ Error sending message: $e');
      onError?.call('Send error: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      await _subscription?.cancel();
      await _channel?.sink.close();

      _subscription = null;
      _channel = null;
      _isConnected = false;

      print('🔌 SFU WebSocket disconnected');
    } catch (e) {
      print('❌ Error disconnecting SFU WebSocket: $e');
    }
  }

  void dispose() {
    disconnect();
  }
}