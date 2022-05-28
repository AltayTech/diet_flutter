import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/themes/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image/image.dart' as Img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

enum TypeTicket { MESSAGE, RECORD, IMAGE }

class TicketBloc {
  TicketBloc() {
    changeType(TypeTicket.MESSAGE);
    sendTicketMessage = new SendTicket();
    _indexSelectedStatus.safeValue = 6;
  }

  ImagePicker? _picker;
  final _repository = Repository.getInstance();
  final _showServerError = LiveEvent();
  final _showMessage = LiveEvent();
  final _progressNetwork = BehaviorSubject<bool>();
  final _supportItemSelected = BehaviorSubject<bool>();
  late SendTicket sendTicketMessage;
  final _isRecording = BehaviorSubject<bool>();
  final _isShowFileAudio = BehaviorSubject<bool>();
  final _isShowSendButton = BehaviorSubject<bool>();
  final _isShowImage = BehaviorSubject<bool>();
  final _showTime = BehaviorSubject<String>();
  final _isShowRecorder = BehaviorSubject<bool>();
  final _typeTicket = BehaviorSubject<TypeTicket>();
  final _SupportItems = BehaviorSubject<List<SupportItem>>();
  final _showProgressItem = BehaviorSubject<bool>();
  final _indexSelectedStatus = BehaviorSubject<int>();
  final _tickets = BehaviorSubject<List<TicketItem>>();

  List<TicketItem> _tempListTickets = [];
  TicketModel? _ticketDetails;

  Stream get showServerError => _showServerError.stream;

  Stream get showMessage => _showMessage.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<bool> get supportItemSelected => _supportItemSelected.stream;

  Stream<bool> get isRecording => _isRecording.stream;

  Stream<bool> get isShowFileAudio => _isShowFileAudio.stream;

  Stream<bool> get isShowImage => _isShowImage.stream;

  Stream<bool> get isShowRecorder => _isShowRecorder.stream;

  Stream<bool> get isShowSendButton => _isShowSendButton.stream;

  Stream<String> get showTime => _showTime.stream;

  Stream<TypeTicket> get typeTicket => _typeTicket.stream;

  List<SupportItem> get SupportItems => _SupportItems.stream.value;

  Stream<bool> get isShowProgressItem => _showProgressItem.stream;

  Stream<int> get indexSelectedStatus => _indexSelectedStatus.stream;

  Stream<List<TicketItem>> get tickets => _tickets.stream;

  bool? get isProgressNetwork => _progressNetwork.value;

  String? get showTimeRecord => _showTime.valueOrNull ?? '';

  List<TicketItem> get tempListTickets => _tempListTickets;

  TicketModel? get ticketDetails => _ticketDetails;

  bool get isFileAudio => _isShowFileAudio.stream.valueOrNull ?? false;

  TypeTicket get typeTicketValue => _typeTicket.value;

  int minute = 0;
  int start = 0;
  bool? _mRecorderIsInited;

  StreamSubscription? _recorderSubscription;
  Directory? tempDir;
  File? outputFile;
  Duration? timeRecord;

  FlutterSoundRecorder? _myRecorder;
  Timer? _timer;

  void setSupportItemSelected() {
    _supportItemSelected.safeValue = true;
  }

  void getTickets() {
    _progressNetwork.safeValue = true;
    _repository.getTickets().then((value) {
      print('value ==> ${value.data?.items?.reversed.toList()[0].toJson()}');
      _tempListTickets.addAll(value.data!.items!);
      _tickets.safeValue = value.data!.items!;
    }).catchError((onError) {
      print('onError ==> ${onError.toString()}');
    }).whenComplete(() {
      _progressNetwork.safeValue = false;
    });
  }

  Color statusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.Resolved:
        return AppColors.statusTicketResolved;
      case TicketStatus.Closed:
        return AppColors.statusTicketClose;
      case TicketStatus.PendingAdminResponse:
        return AppColors.statusTicketPendingAdminResponse;
      case TicketStatus.PendingUserResponse:
        return AppColors.statusTicketPendingUserResponse;
      case TicketStatus.OnHold:
        return AppColors.statusTicketOnHold;
      case TicketStatus.GlobalIssue:
        return AppColors.statusTicketGlobalIssue;
      case TicketStatus.ALL:
        return AppColors.statusTicketGlobalIssue;
        break;
    }
  }

  void changeType(TypeTicket typeTicket) {
    _typeTicket.safeValue = typeTicket;
    _isShowRecorder.safeValue = false;

    if (_isRecording.valueOrNull != null && _isRecording.value == true) {
      _isRecording.value = false;
      if (_myRecorder!.isRecording) stopRecorder(false);
      stopAndStart();
    }
  }

  void showShowSendButton(bool show) {
    _isShowSendButton.safeValue = show;
  }

  void recording() {
    _isShowRecorder.safeValue = !(_isShowRecorder.valueOrNull ?? true);
  }

  void getSupportList() {
    _progressNetwork.safeValue = true;
    _repository.getDepartmentItems().then((value) {
      _SupportItems.safeValue = value.data!.items;
    }).catchError((onError) {
      print('onError ==> ${onError.toString()}');
    }).whenComplete(() {
      _progressNetwork.safeValue = false;
    });
  }

  void createRecord() {
    minute = 0;
    start = 0;
    if (_myRecorder == null) {
      _myRecorder = FlutterSoundRecorder();
      _myRecorder!.openRecorder().then((value) {
        _mRecorderIsInited = true;
      });
    }
    _showTime.value = "${NumberFormat('00').format(minute)}:${NumberFormat('00').format(start)}";
    recording();
  }

  void record() async {
    if (_isRecording.valueOrNull != null && _isRecording.value) {
      print('recording = > stop');
      _isRecording.safeValue = false;
      if (_timer != null) _timer!.cancel();
      stopRecorder(true);
    } else {
      print('recording = > PermissionStatus');
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print('recording = > status != PermissionStatus.granted');
        if (status == PermissionStatus.permanentlyDenied) {
          print('recording = > permanentlyDenied');
          await AppSettings.openAppSettings();
        } else {
          status = await Permission.microphone.request();
          if (status.isGranted) {
            record();
          }
        }
      } else {
        print('recording = > start');
        tempDir = await getTemporaryDirectory();
        outputFile =
            await File('${tempDir!.path}/sound-${new DateTime.now().millisecondsSinceEpoch}.mp4');
        await _myRecorder!
            .startRecorder(
          toFile: outputFile!.path,
          codec: Codec.aacMP4,
        )
            .then((value) async {
          _isRecording.value = true;
          if (_timer != null) _timer!.cancel();
          _setTimer();
        });
      }
    }
  }

  void stopRecorder(bool refresh) async {
    _isRecording.value = false;
    await _myRecorder!.stopRecorder();
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }

    if (refresh) _isShowFileAudio.value = true;
  }

  void _setTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (start + 1 >= 60) {
        start = 0;
        minute += 1;
      } else
        start += 1;

      _showTime.safeValue = "${NumberFormat('00').format(minute)}:${NumberFormat('00').format(start)}";
      print('time');
    });
  }

  void stopAndStart() async {
    _timer?.cancel();
    if (outputFile != null && await outputFile!.exists()) await outputFile!.delete();
    deleteImage();
    _isShowFileAudio.safeValue = false;
    _isShowImage.safeValue = false;
    _isRecording.safeValue = false;
    minute = 0;
    start = 0;
    _showTime.safeValue = "${NumberFormat('00').format(minute)}:${NumberFormat('00').format(start)}";
  }

  void sendTicketText() {
    _showProgressItem.safeValue = true;
    if (_isShowImage.valueOrNull != null && _isShowImage.value == true) {
      sendTicketMessage.isVoice = false;
      _repository.sendTicketFile(sendTicketMessage, imageFile!).then((value) {
        getTickets();
        _showServerError.fireMessage(value.message!);
      }).catchError((onError) {
        // _showServerError.fireMessage(onError);
      }).whenComplete(() {
        _showProgressItem.value = false;
      });
    } else {
      _repository.sendTicketMessage(sendTicketMessage).then((value) {
        getTickets();
        _showServerError.fireMessage(value.message!);
      }).catchError((onError) {
        // _showServerError.fireMessage(onError);
      }).whenComplete(() {
        _showProgressItem.value = false;
      });
    }
  }

  void sendTicketFile() {
    _showProgressItem.value = true;
    sendTicketMessage.isVoice = true;
    _repository.sendTicketFile(sendTicketMessage, File(outputFile!.path)).then((value) {
      getTickets();
      _showServerError.fireMessage(value.message!);
    }).whenComplete(() {
      _showProgressItem.value = false;
    });
  }

  void sendTicketTextDetail() async {
    if (_isShowImage.valueOrNull == null || _isShowImage.value == false) {
      _showProgressItem.value = true;
      _repository.sendTicketMessageDetail(sendTicketMessage).then((value) {
        getDetailTicket(sendTicketMessage.ticketId!);
        _showServerError.fireMessage(value.message!);
      }).catchError((onError) {
        // _showServerError.fireMessage(onError);
      }).whenComplete(() {
        _showProgressItem.value = false;
      });
    } else {
      sendTicketMessage.hasAttachment = true;
      sendTicketMessage.isVoice = false;
      // print('sendTicketMessage = > ${sendTicketMessage.toJson()}');
      if (sendTicketMessage.body != null && sendTicketMessage.body!.isNotEmpty) {
        _showProgressItem.value = true;
        try {
          _repository.sendTicketFileDetail(sendTicketMessage, File(imageFile!.path)).then((value) {
            getDetailTicket(sendTicketMessage.ticketId!);
            _showServerError.fireMessage(value.message!);
          }).catchError((onError) {
            // _showServerError.fireMessage(onError);
          }).whenComplete(() {
            _showProgressItem.value = false;
          });
        } catch (e) {
          print('eeee => $e');
          _showProgressItem.value = false;
        }
      } else {
        _showServerError.fireMessage("error");
      }
    }
  }

  void sendTicketFileDetail() {
    _showProgressItem.value = true;
    sendTicketMessage.hasAttachment = true;
    sendTicketMessage.isVoice = true;
    _repository.sendTicketFileDetail(sendTicketMessage, outputFile!).then((value) {
      getDetailTicket(sendTicketMessage.ticketId!);
      _showServerError.fireMessage(value.message!);
    }).whenComplete(() {
      _showProgressItem.value = false;
    });
  }

  void downloadFile(String? name, String? url, TempMedia item) async {
    Dio dio = Dio();

    try {
      var data = await dio.download('$url', '${tempDir!.path}/$name');
      if (data.statusCode == 200) item.mediumUrls!.url = "${tempDir!.path}/$name}";
    } catch (e) {}
    // String tempPath = tempDir.path;
    // File file = new File('$tempPath/$name');
    // await file.writeAsBytes(url.bodyBytes);
  }

  void getDetailTicket(int id) {
    sendTicketMessage = new SendTicket();
    sendTicketMessage.body = "";
    _isShowSendButton.value = false;
    _isShowImage.value = false;
    _isShowFileAudio.value = false;
    _isShowRecorder.value = false;
    _isRecording.value = false;
    _progressNetwork.value = true;
    _repository.getTicketDetails(id).then((value) {
      _ticketDetails = value.data;
      sendTicketMessage.ticketId = _ticketDetails!.ticket!.id;
      List<TicketItem> list = [];
      _ticketDetails!.ticket!.messages!.forEach((ticket) {
        TicketItem? exists;
        if (ticket.file == null && ticket.temp == null) {
          ticket.type = TypeTicketMessage.TEXT;
        } else if (ticket.temp != null) {
          ticket.type = TypeTicketMessage.TEMP;
        } else if (ticket.isVoice == 1) {
          ticket.type = TypeTicketMessage.VOICE;
        } else {
          ticket.type = TypeTicketMessage.TEXT_AND_ATTACHMENT;
        }
        if (list
            .where((element) => element.createdAt!.contains(ticket.createdAt!.substring(0, 10)))
            .isNotEmpty)
          exists = list.singleWhere(
              (element) => element.createdAt!.contains(ticket.createdAt!.substring(0, 10)));
        if (exists == null) {
          TicketItem ticketListDate = new TicketItem();
          ticketListDate.createdAt = ticket.createdAt!.substring(0, 10);
          ticketListDate.messages = [];
          ticketListDate.messages!.add(ticket);
          list.add(ticketListDate);
        } else {
          exists.messages!.add(ticket);
        }
      });
      _ticketDetails!.items = list;
    }).catchError((onError) {
      print('error = > $onError');
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }

  XFile? image;
  File? imageFile;

  void selectGallery() async {
    if (_picker == null) _picker = ImagePicker();
    // Pick an image
    image = await _picker!.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imageFile = await File(image!.path);
      if (tempDir == null) tempDir = await getTemporaryDirectory();
      var imageDecode = Img.decodeImage(imageFile!.readAsBytesSync())!;
      imageFile = await FlutterImageCompress.compressAndGetFile(imageFile!.absolute.path,
          '${tempDir!.path}/img${DateTime.now().millisecondsSinceEpoch}.jpg',
          format: CompressFormat.jpeg,
          quality: 70,
          minWidth: (imageDecode.width * 0.5).toInt(),
          minHeight: (imageDecode.height * 0.5).toInt(),
          inSampleSize: 2);
      _isShowImage.value = true;
      changeType(TypeTicket.IMAGE);
      showShowSendButton(true);
    }
  }

  void selectCamera() async {
    if (_picker == null) _picker = ImagePicker();
    // Pick an image
    image = await _picker!.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageFile = await File(image!.path);
      if (tempDir == null) tempDir = await getTemporaryDirectory();
      var imageDecode = Img.decodeImage(imageFile!.readAsBytesSync())!;
      imageFile = await FlutterImageCompress.compressAndGetFile(imageFile!.absolute.path,
          '${tempDir!.path}/img${DateTime.now().millisecondsSinceEpoch}.jpg',
          format: CompressFormat.jpeg,
          quality: 70,
          minWidth: (imageDecode.width * 0.5).toInt(),
          minHeight: (imageDecode.height * 0.5).toInt(),
          inSampleSize: 2);
      _isShowImage.value = true;
      changeType(TypeTicket.IMAGE);
      showShowSendButton(true);
    }
  }

  void deleteImage() async {
    try {
      if (imageFile != null && await imageFile!.exists()) await imageFile!.delete();
      _isShowImage.value = false;
    } catch (e) {
      _isShowImage.value = false;
    }
  }

  void setIndexSelectedStatus(int index) {
    _indexSelectedStatus.safeValue = index;
    filterListTicket();
  }

  void filterListTicket() {
    if (TicketStatus.values[_indexSelectedStatus.value] == TicketStatus.ALL) {
      _tickets.safeValue = _tempListTickets;
    } else
      _tickets.safeValue = _tempListTickets
          .where((element) => element.status == TicketStatus.values[_indexSelectedStatus.value])
          .toList();
  }

  void dispose() {
    _showServerError.close();
    _progressNetwork.close();
    _showProgressItem.close();
    _isRecording.close();
    _isShowFileAudio.close();
    _isShowRecorder.close();
    _typeTicket.close();
    _supportItemSelected.close();
    _SupportItems.close();
    _isShowSendButton.close();
    _showTime.close();
    if (_timer != null) _timer!.cancel();
    //  _isPlay.close();
  }
}
