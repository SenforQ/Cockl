import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class DiscoverVideoFullscreenPage extends StatefulWidget {
  const DiscoverVideoFullscreenPage({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  State<DiscoverVideoFullscreenPage> createState() => _DiscoverVideoFullscreenPageState();
}

class _DiscoverVideoFullscreenPageState extends State<DiscoverVideoFullscreenPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onVideoUpdate);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _onVideoUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onVideoUpdate);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (c.value.isInitialized)
            LayoutBuilder(
              builder: (context, constraints) {
                final sz = c.value.size;
                if (sz.width > 0 && sz.height > 0) {
                  return Center(
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: sz.width,
                          height: sz.height,
                          child: VideoPlayer(c),
                        ),
                      ),
                    ),
                  );
                }
                return Center(
                  child: AspectRatio(
                    aspectRatio: c.value.aspectRatio,
                    child: VideoPlayer(c),
                  ),
                );
              },
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 4,
            left: 4,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
              tooltip: 'Exit Fullscreen',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (c.value.isPlaying) {
                    c.pause();
                  } else {
                    c.play();
                  }
                });
              },
              iconSize: 72,
              icon: Icon(
                c.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
