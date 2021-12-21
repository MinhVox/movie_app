import 'package:chewie/chewie.dart';
import 'package:final_training_aia/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TrailerPage extends StatefulWidget {
  final GlobalKey<_PlayVideoLessonState> mkey = GlobalKey();
  @override
  _TrailerPageState createState() => _TrailerPageState(mkey);
}

class _TrailerPageState extends State<TrailerPage> {
  GlobalKey<_PlayVideoLessonState> mkey;
  _TrailerPageState(this.mkey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PlayVideoLesson(
            path:
                'https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4',
            key: mkey,
            autoplay: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.colorFFFFFF,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
        ],
      ),
    );
  }
}

class PlayVideoLesson extends StatefulWidget {
  final String path;
  final bool? looping;
  final bool? autoplay;
  final Function()? isPlayVideo;
  final Widget? placeholder;

  PlayVideoLesson(
      {Key? key,
      required this.path,
      this.looping,
      this.autoplay,
      this.isPlayVideo,
      this.placeholder})
      : super(key: key);

  @override
  _PlayVideoLessonState createState() => _PlayVideoLessonState();
}

class _PlayVideoLessonState extends State<PlayVideoLesson> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    initializeVideo();
    super.initState();
  }

  void initializeVideo() {
    _videoPlayerController = VideoPlayerController.network(widget.path);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: 16 / 9,
      autoPlay: widget.autoplay ?? false,
      looping: widget.looping ?? false,
      allowFullScreen: true,
      placeholder: widget.placeholder,
      fullScreenByDefault: true,
      // showOptions: false
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void pauseVideo() {
    if (_videoPlayerController.value.isInitialized &&
        _videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PlayVideoLesson oldWidget) {
    if (oldWidget.path != widget.path) {
      _chewieController.dispose();
      _videoPlayerController.dispose();
      initializeVideo();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
