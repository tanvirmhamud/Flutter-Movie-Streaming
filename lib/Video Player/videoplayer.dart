import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerpage extends StatefulWidget {
  const VideoPlayerpage({Key? key}) : super(key: key);

  @override
  _VideoPlayerpageState createState() => _VideoPlayerpageState();
}

class _VideoPlayerpageState extends State<VideoPlayerpage> {
  VideoPlayerController? videoPlayerController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network('https://r1---sn-oxunjv2xcq-q5je.googlevideo.com/videoplayback?expire=1628259333&ei=pe8MYeCILJr3juMP966BsAU&ip=103.77.190.94&id=o-AF19FKjUwg8YoaLaHBNzmdhqe9hCvUzbZlhGl-UZhAad&itag=248&aitags=133%2C134%2C135%2C136%2C137%2C160%2C242%2C243%2C244%2C247%2C248%2C278%2C394%2C395%2C396%2C397%2C398%2C399&source=youtube&requiressl=yes&mh=tO&mm=31%2C29&mn=sn-oxunjv2xcq-q5je%2Csn-n0hhpujvh-jb2s&ms=au%2Crdu&mv=m&mvi=1&pcm2cms=yes&pl=24&gcr=bd&initcwndbps=456250&vprv=1&mime=video%2Fwebm&ns=QIPL6G7U3VsDsexnMQNXREcG&gir=yes&clen=43489629&dur=226.893&lmt=1623512678848915&mt=1628237355&fvip=1&keepalive=yes&fexp=24001373%2C24007246&c=WEB&txp=5535432&n=V3f0IXvv3q7ZfQ&sparams=expire%2Cei%2Cip%2Cid%2Caitags%2Csource%2Crequiressl%2Cgcr%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cdur%2Clmt&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpcm2cms%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRgIhAKVeLaFp_qS5kucVS1HWSNGS-02B_JRAVVhqOlydFy3HAiEA5GJVgbFTJsYk2LTtrQ4Ma7KI9ad0wJaL812Pc8ufoS0%3D&alr=yes&sig=AOq0QJ8wRgIhAOPQIjdYoVSMiUgEchb_-TOOOzdH6GV97y9jwlV-AvZEAiEA8eb...')
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((value) => videoPlayerController!.play());
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: videoPlayerController != null &&
                videoPlayerController!.value.isInitialized
            ? Container(
                alignment: Alignment.topCenter,
                child: AspectRatio(
                  aspectRatio: videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(
                    videoPlayerController!,
                  ),
                ),
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
