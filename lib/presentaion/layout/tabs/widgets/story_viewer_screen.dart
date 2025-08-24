import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:zytronic_task/core/utils/app_colors.dart';
import 'package:zytronic_task/domain/entity/stories_entity.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryEntity> stories;
  final int initialIndex;
  final VoidCallback? onComplete;
  final Function(String storyId)? onStoryViewed;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0,
    this.onComplete,
    this.onStoryViewed,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  VideoPlayerController? _videoController;
  Timer? _timer;
  
  int _currentIndex = 0;
  Duration _storyDuration = const Duration(seconds: 5);
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: _storyDuration,
    );
    
    _loadStory(_currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _videoController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _loadStory(int index) {
    if (index >= widget.stories.length) return;

    final story = widget.stories[index];
    
    // Mark story as viewed
    widget.onStoryViewed?.call(story.id);
    
    // Reset animation controller
    _animationController.reset();
    
    if (story.type == StoryType.video) {
      _loadVideo(story.mediaUrl);
    } else {
      _loadImage();
    }
  }

  void _loadVideo(String videoUrl) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    
    _videoController!.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _videoController!.play();
        
        // Set duration based on video length
        _storyDuration = _videoController!.value.duration;
        _animationController.duration = _storyDuration;
        _startTimer();
      }
    }).catchError((error) {
      print('Error loading video: $error');
      _nextStory();
    });
  }

  void _loadImage() {
    _storyDuration = const Duration(seconds: 5);
    _animationController.duration = _storyDuration;
    _startTimer();
  }

  void _startTimer() {
    if (_isPaused) return;
    
    _animationController.forward().then((_) {
      if (mounted && !_isPaused) {
        _nextStory();
      }
    });
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _loadStory(_currentIndex);
    } else {
      // All stories completed
      widget.onComplete?.call();
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _loadStory(_currentIndex);
    }
  }

  void _pauseStory() {
    _isPaused = true;
    _animationController.stop();
    _videoController?.pause();
  }

  void _resumeStory() {
    _isPaused = false;
    _animationController.forward();
    _videoController?.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Stories PageView
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _loadStory(index);
              },
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                final story = widget.stories[index];
                return _buildStoryContent(story);
              },
            ),
            
            // Progress indicators
            _buildProgressIndicators(),
            
            // Story header
            _buildStoryHeader(),
            
            // Touch areas for navigation
            _buildTouchAreas(),
            
            // Story caption
            if (widget.stories[_currentIndex].caption != null)
              _buildCaption(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent(StoryEntity story) {
    return GestureDetector(
      onTapDown: (_) => _pauseStory(),
      onTapUp: (_) => _resumeStory(),
      onTapCancel: () => _resumeStory(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: story.type == StoryType.video
            ? _buildVideoPlayer()
            : _buildImageViewer(story.mediaUrl),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      ),
    );
  }

  Widget _buildImageViewer(String imageUrl) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildProgressIndicators() {
    return Positioned(
      top: 20,
      left: 8,
      right: 8,
      child: Row(
        children: List.generate(
          widget.stories.length,
          (index) => Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: LinearProgressIndicator(
                value: index < _currentIndex
                    ? 1.0
                    : index == _currentIndex
                        ? _animationController.value
                        : 0.0,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryHeader() {
    final story = widget.stories[_currentIndex];
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryColor.withOpacity(0.2),
            child: Text(
              story.userName.isNotEmpty ? story.userName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _formatTime(story.createdAt),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTouchAreas() {
    return Row(
      children: [
        // Left side - previous story
        Expanded(
          child: GestureDetector(
            onTap: _previousStory,
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
            ),
          ),
        ),
        // Right side - next story
        Expanded(
          child: GestureDetector(
            onTap: _nextStory,
            child: Container(
              color: Colors.transparent,
              height: double.infinity,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaption() {
    return Positioned(
      bottom: 100,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.stories[_currentIndex].caption!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}