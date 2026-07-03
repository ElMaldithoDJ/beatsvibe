import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:just_audio/just_audio.dart';

late AudioHandlerService globalAudioHandler;

class AudioHandlerService extends BaseAudioHandler
    with SeekHandler, QueueHandler {
  final AudioPlayer player = AudioPlayer();

  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration> get bufferedPositionStream => player.bufferedPositionStream;
  Stream<Duration?> get durationStream => player.durationStream;

  // Create audio source from a media item
  UriAudioSource _createAudioSource(MediaItemData item) {
    return ProgressiveAudioSource(
      Uri.parse(item.audioUrl),
      tag: item.toMediaItem(),
    );
  }

  // Listen for changes in current song index and update media item
  void _listenForCurrenSongIndexChange() {
    player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (playlist.isEmpty || index == null) return;
      mediaItem.add(playlist[index]);
    });
  }

  // Broadcast current playback state based on the recived playback event
  void _broadcastState(PlaybackEvent event) {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          (player.playing) ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
          // MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[player.processingState]!,
        playing: player.playing,
        updatePosition: player.position,
        bufferedPosition: event.bufferedPosition,
        speed: player.speed,
        queueIndex: event.currentIndex,
      ),
    );
  }

  // Function to init the songs and set up the audio player
  Future<void> initPlayer({required List<MediaItemData> songs}) async {
    player.playbackEventStream.listen(_broadcastState);
    final audioSource = songs.map<UriAudioSource>((e) => _createAudioSource(e));
    await player.setAudioSource(
      ConcatenatingAudioSource(children: audioSource.toList()),
    );
    queue.value.clear();
    final newQueue = queue.value..addAll(songs.map((e) => e.toMediaItem()));
    queue.add(newQueue);
    _listenForCurrenSongIndexChange();

    // Auto skip song when the current song ends (loop all songs)
    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  @override
  Future<void> play() => player.play();
  @override
  Future<void> pause() => player.pause();
  @override
  Future<void> seek(Duration position) => player.seek(position);

  // Skip to a specific song in the queue
  @override
  Future<void> skipToQueueItem(int index) async {
    await player.seek(Duration.zero, index: index);
    await play();
  }

  // Jump to a specific song in the queue
  Future<void> jumpToQueueItem(int index) async {
    await player.seek(Duration.zero, index: index);
  }

  // Skip song (next or previous)
  @override
  Future<void> skipToNext() async {
    if (player.currentIndex == queue.value.length - 1) {
      await player.seek(Duration.zero, index: 0);
    } else if (player.currentIndex! < queue.value.length - 1) {
      await player.seekToNext();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (player.currentIndex == 0) {
      await player.seek(Duration.zero, index: queue.value.length - 1);
    } else if (player.currentIndex! > 0) {
      await player.seekToPrevious();
    }
  }
}
