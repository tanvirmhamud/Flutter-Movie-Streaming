import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPage extends StatefulWidget {
  final String youtubeurl;
  const YoutubePlayerPage({Key? key, required this.youtubeurl}) : super(key: key);

  @override
  _YoutubePlayerPageState createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  YoutubePlayerController? youtubePlayerController;
  late PlayerState _playerState;
  late YoutubeMetaData _youtubeMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  @override
  void initState() {
    runyoutubeplayer();
    super.initState();
  }

  void runyoutubeplayer() {
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.youtubeurl,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  void listener() {
    if (_isPlayerReady &&
        _muted &&
        youtubePlayerController!.value.isFullScreen) {
      setState(() {
        _playerState = youtubePlayerController!.value.playerState;
        _youtubeMetaData = youtubePlayerController!.metadata;
      });
    }
  }

  @override
  void deactivate() {
    youtubePlayerController!.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubePlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        
        controller: youtubePlayerController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
      ),
      builder: (context, player) {
        return player;
      },
    );
  }
}
