import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///
const int tSAMPLERATE = 8000;

///
const int tBLOCKSIZE = 4096;

///
enum Media {
  ///
  file,

  ///
  buffer,

  ///
  asset,

  ///
  stream,

  ///
  remoteExampleFile,
}
enum AudioState {
  ///
  isPlaying,

  ///
  isPaused,

  ///
  isStopped,

  ///
  isRecording,

  ///
  isRecordingPaused,
}

class CustomPlayer extends StatefulWidget {
  Media? media;
  String? url;
  bool? isAdmin;
  String? timeRecord;

  CustomPlayer({Key? key, this.media, this.url, this.isAdmin, this.timeRecord})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  MyWidgetPlayer createState() => MyWidgetPlayer(media, url, isAdmin);
}

class MyWidgetPlayer extends ResourcefulState<CustomPlayer> {
  MyWidgetPlayer(this._media, this.url, this.isAdmin);

  Media? _media;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  bool? isAdmin;
  Codec _codec =  Codec.mp3;
  bool _isAudioPlayer = false;
  bool _decoderSupported = true; //
  bool _isPlaying = false;

  String? url;
  Duration? _position;
  Duration? _duration;
  FlutterSoundPlayer? _myPlayer = FlutterSoundPlayer();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    init();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
  }

  @override
  void dispose() {
    // Be careful : you must `close` the audio session when you have finished with it.
    _myPlayer!.closePlayer();
    _myPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      textDirection: context.textDirectionOfLocale,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            //  Fimber.d('counter audio ${message['audioCounter']} / $selectedAudio');
            //   Fimber.d('counter audio ${message['audioCounter']} / $selectedAudio');
            _play();
          },
          child: CircleAvatar(
            radius: 4.w,
            backgroundColor: AppColors.primary,
            child: loading
                ? SpinKitCircle(
                    size: 70.0,
                    itemBuilder: (BuildContext context, index) {
                      return DecoratedBox(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.accentColor,
                                width: 3,
                              ),
                              color: Colors.white,
                              shape: BoxShape.circle));
                    },
                  )
                : Icon(
                    _isPlaying
                        ? Icons.pause_outlined
                        : Icons.play_arrow_outlined,
                    color: Colors.white,
                    size: 6.w,
                  ),
          ),
        ),
        Expanded(
          child: Stack(
            textDirection: context.textDirectionOfLocaleInversed,
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  _duration != null
                      ? _duration?.toString().split('.').first ??
                      widget.timeRecord!
                      : "",
                  style: Theme.of(context).textTheme.caption!.copyWith(color: AppColors.labelColor),
                ),
              ),
              Container(
                height: 8.h,
                child: Slider(
                  value: sliderCurrentPosition,
                  min: 0.0,
                  max: maxDuration,
                  /*value: (_position != null &&
                      _duration != null)
                      ? _position.inSeconds.toDouble()
                      : 0.0,*/
                  onChanged: (val) => {SeekTo(val)},
                  activeColor: AppColors.primary,
                  inactiveColor: isAdmin!
                      ? Color.fromRGBO(237, 237, 237, 1)
                      : Color(0xffDADBE6),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 15,
                child: Text(
                  _position?.toString().split('.').first ?? '00:00',
                  style: Theme.of(context).textTheme.caption!.copyWith(color: AppColors.labelColor),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  Future<void> _initializeExample(bool withUI) async {
    await _myPlayer!.closePlayer();
    // _isAudioPlayer = withUI;
    await _myPlayer!.openPlayer(
        /*withUI: withUI,
        focus: AudioFocus.requestFocusAndStopOthers,
        category: SessionCategory.playAndRecord,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker*/);
    await _myPlayer!.setSubscriptionDuration(Duration(milliseconds: 10));
    // await initializeDateFormatting();
    //await setCodec(_codec);
  }

  Future<void> init() async {
    try {
      await _myPlayer!.openPlayer(
          /*focus: AudioFocus.requestFocusAndStopOthers,
          category: SessionCategory.playAndRecord,
          mode: SessionMode.modeDefault,
          device: AudioDevice.speaker*/);
      await _initializeExample(false);
    }catch(err){

    }
   // await _initializeExample(false);
    //onStartPlayerPressed();
    /*   if ((!kIsWeb) && Platform.isAndroid) {
      await copyAssets();
    }*/
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

/*  Future<void> copyAssets() async {
    var dataBuffer =
    (await rootBundle.load('assets/audio.mp3')).buffer.asUint8List();
    var path = '${await _myPlayer.getResourcePath()}/assets';
    if (!await Directory(path).exists()) {
      await Directory(path).create(recursive: true);
    }
    await File('$path/audio.mp3').writeAsBytes(dataBuffer);
  }*/
  void _addListeners() async {
    cancelPlayerSubscriptions();
    _playerSubscription = _myPlayer!.onProgress!.listen((e) {
      setState(() {
        maxDuration = e.duration.inMilliseconds.toDouble();
        if (maxDuration <= 0) maxDuration = 0.0;
        _position = e.position;
        _duration = e.duration;
        sliderCurrentPosition = e.position.inMilliseconds.toDouble();
        if (sliderCurrentPosition < 0.0) {
          sliderCurrentPosition = 0.0;
        }
      });
    });
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
  }

  static Future<Uint8List?> _readFileByte(String filePath) async {
    var myUri = Uri.parse(filePath);
    var audioFile = File.fromUri(myUri);
    Uint8List? bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
     // Fimber.d('reading of bytes is completed');
    });
    return bytes;
  }

  Future<void> feedHim(String path) async {
    var data = await (_readFileByte(path) as FutureOr<Uint8List>);
    return _myPlayer!.feedFromStream(data);
  }

  Future<void> startPlayer() async {
    try {
      Uint8List? dataBuffer;
      String? audioFilePath;
      var codec = _codec;
      if (_media == Media.file || _media == Media.stream) {
        // Do we want to play from buffer or from file ?
        if (kIsWeb || await fileExists(url!)) {
          audioFilePath = url;
        }
      } else if (_media == Media.remoteExampleFile) {
        // We have to play an example audio file loaded via a URL
        if (_codec == Codec.mp3) {
          audioFilePath = url;
        } else if (codec == Codec.opusOGG) {
          audioFilePath = url;
        } else if (codec == Codec.pcm16WAV) {
          // exampleAudioFilePathWave;
        }
      }
      // Check whether the user wants to use the audio player features
      if (_media == Media.stream) {
        await _myPlayer!.startPlayerFromStream(
          codec: _codec,
          numChannels: 1,
          sampleRate: tSAMPLERATE,
        );
        _addListeners();
        setState(() {});
        await feedHim(audioFilePath!);
        //await finishPlayer();
        await stopPlayer();
        return;
      } else {
        if (audioFilePath != null) {
          //Fimber.d("_myPlayer >> Start");
          await _myPlayer!
              .startPlayer(
                  fromURI: audioFilePath,
                  codec: codec,
                  sampleRate: tSAMPLERATE,
                  whenFinished: () {
                    isStopped = true;
                    stopPlayer();
                    setState(() {
                      _isPlaying = false;
                    });
                  })
              .then((value) => {
                    setState(() {
                      //Fimber.d("_myPlayer >> Start End");
                      _isPlaying = true;
                      loading = false;
                      isInit = true;
                      if (isStopped) pauseResumePlayer();
                    })
                  });
        } else if (dataBuffer != null) {
          if (codec == Codec.pcm16) {
            dataBuffer = await flutterSoundHelper.pcmToWaveBuffer(
              inputBuffer: dataBuffer,
              numChannels: 1,
              sampleRate: (_codec == Codec.pcm16 && _media == Media.asset)
                  ? 48000
                  : tSAMPLERATE,
            );
            codec = Codec.pcm16WAV;
          }
          await _myPlayer!.startPlayer(
              fromDataBuffer: dataBuffer,
              sampleRate: tSAMPLERATE,
              codec: codec,
              whenFinished: () {
                stopPlayer();
                setState(() {});
              });
        }
      }
      _addListeners();
      setState(() {});
     // Fimber.d('<--- startPlayer');
    } on Exception {
     // Fimber.d('error: $err');
    }
  }

  static Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  static Future<Uint8List?> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      var file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
     // Fimber.d('The file is ${contents.length} bytes long.');
      return contents;
    } on Exception {
     // Fimber.d("error Exception",ex: e);
      return null;
    }
  }

  bool isStopped = false;

  Future<void> stopPlayer() async {
    try {
      await _myPlayer!.stopPlayer();
    //  Fimber.d('stopPlayer');
      if (_playerSubscription != null) {
        await _playerSubscription!.cancel();
        _playerSubscription = null;
      }
      onStartPlayerPressed();
    } on Exception {
     // Fimber.d('error: $err');
    }
    setState(() {
      _isPlaying = false;
      sliderCurrentPosition = 0.0;
      /*_duration=Duration(milliseconds: 0);*/
      _position = Duration(milliseconds: 0);
    });
  }

  void pauseResumePlayer() {
    if (_myPlayer!.isPlaying) {
     // Fimber.d("_myPlayer >> Pause");
      _myPlayer!.pausePlayer();
      _isPlaying = false;
    } else {
      _myPlayer!.resumePlayer();
      _isPlaying = true;
    }
    setState(() {});
  }

  void Function()? onStartPlayerPressed() {
    setState(() {
      loading = true;
    });
    if (_myPlayer == null) {
      setState(() {
        loading = false;
      });
      return null;
    }
    if (_media == Media.buffer && kIsWeb) {

      return null;
    }
    if (_media == Media.file ||
        _media == Media.stream ||
        _media == Media.buffer) // A file must be already recorded to play it
    {

      if (url == null) return null;
    }
    if (_media == Media.remoteExampleFile &&
        !(_codec == Codec.mp3 ||
            _codec == Codec.opusOGG ||
            _codec ==
                Codec
                    .pcm16WAV) ) // in this example we use just a remote mp3 or upus file
    {
      return null;
    }

    if (_media == Media.stream && _codec != Codec.pcm16) {
      return null;
    }

    if (_media == Media.stream && _isAudioPlayer) {
      return null;
    }

    // Disable the button if the selected codec is not supported
    if (!(_decoderSupported || _codec == Codec.pcm16)) {
      return null;
    }
    if ((_myPlayer!.isStopped)) {
      startPlayer();
    } else {
      return null;
    }
    return null;
  }

  void Function()? onPauseResumePlayerPressed() {
    if (_myPlayer == null) return null;
    if (_myPlayer!.isPaused || _myPlayer!.isPlaying) {
      pauseResumePlayer();
    }
    return null;
  }

  StreamSubscription? _playerSubscription;

  bool isInit = false;

  void _play() async {
    isInit ? onPauseResumePlayerPressed() : onStartPlayerPressed();
  }

  void SeekTo(val) async {
    await _myPlayer!.seekToPlayer(Duration(milliseconds: val.toInt()));
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
