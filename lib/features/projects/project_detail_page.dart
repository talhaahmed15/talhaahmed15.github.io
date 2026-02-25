import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/link_utils.dart';
import '../../core/widgets/action_button.dart';
import '../../core/widgets/image_fallback.dart';
import '../../data/models/portfolio_data.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({required this.project, super.key});

  final PortfolioProject project;

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late List<String> _images;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _images = [
      widget.project.image,
      ...widget.project.galleryImages.where(
        (img) => img != widget.project.image,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final selectedImage = _images[_selectedIndex];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.textPrimary,
        title: Text(project.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1020),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.year,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.description,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 420,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      border: Border.all(color: AppColors.border, width: 1.6),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: GestureDetector(
                        key: ValueKey(selectedImage),
                        onTap: () => _openImagePreview(
                          context,
                          images: _images,
                          initialIndex: _selectedIndex,
                          title: project.title,
                        ),
                        child: Container(
                          width: double.infinity,
                          color: AppColors.cardAlt,
                          padding: const EdgeInsets.all(12),
                          child: _selectedIndex == 0
                              ? Hero(
                                  tag: 'project-image-${project.title}',
                                  child: Image.asset(
                                    selectedImage,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            ImageFallback(label: project.title),
                                  ),
                                )
                              : Image.asset(
                                  selectedImage,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      ImageFallback(label: project.title),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap image for fullscreen preview',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final selected = index == _selectedIndex;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 130,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              border: Border.all(
                                color: selected
                                    ? AppColors.accent
                                    : AppColors.border,
                                width: selected ? 2 : 1.3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              _images[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const ImageFallback(label: 'Image'),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemCount: _images.length,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.tags
                        .map(
                          (tag) => Chip(
                            label: Text(
                              tag,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            backgroundColor: AppColors.cardAlt,
                            side: const BorderSide(color: AppColors.border),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (project.liveUrl.isNotEmpty)
                        ActionButton(
                          label: 'Live Site',
                          onPressed: () => openUrl(project.liveUrl),
                        ),
                      if (project.repoUrl.isNotEmpty)
                        ActionButton(
                          label: 'Code',
                          onPressed: () => openUrl(project.repoUrl),
                        ),
                      if (project.caseStudyUrl.isNotEmpty)
                        ActionButton(
                          label: 'Case Study',
                          onPressed: () => openUrl(project.caseStudyUrl),
                        ),
                    ],
                  ),
                  if (project.videos.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Videos',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: project.videos.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) => AssetVideoCard(
                          onOpenFullPreview: () => _openVideoPreview(
                            context,
                            videoAsset: project.videos[index],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tap video card for fullscreen preview',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openImagePreview(
    BuildContext context, {
    required List<String> images,
    required int initialIndex,
    required String title,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (context) => _ImagePreviewDialog(
        images: images,
        initialIndex: initialIndex,
        title: title,
      ),
    );
  }

  Future<void> _openVideoPreview(
    BuildContext context, {
    required String videoAsset,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (context) => _VideoPreviewDialog(videoAsset: videoAsset),
    );
  }
}

class AssetVideoCard extends StatelessWidget {
  const AssetVideoCard({required this.onOpenFullPreview, super.key});

  final VoidCallback onOpenFullPreview;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenFullPreview,
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1.3),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(16),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_fill_rounded,
                size: 56,
                color: AppColors.accent,
              ),
              SizedBox(height: 10),
              Text(
                'Open video preview',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tap to play in fullscreen',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePreviewDialog extends StatefulWidget {
  const _ImagePreviewDialog({
    required this.images,
    required this.initialIndex,
    required this.title,
  });

  final List<String> images;
  final int initialIndex;
  final String title;

  @override
  State<_ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<_ImagePreviewDialog> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final canGoPrev = _index > 0;
    final canGoNext = _index < widget.images.length - 1;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.85,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 4,
                      child: Center(
                        child: Image.asset(
                          widget.images[_index],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              ImageFallback(label: widget.title),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Scroll to zoom. Drag to pan.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  if (widget.images.length > 1) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${_index + 1} / ${widget.images.length}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (canGoPrev)
            Positioned(
              left: 8,
              top: size.height * 0.38,
              child: IconButton.filled(
                onPressed: () => setState(() => _index--),
                icon: const Icon(Icons.chevron_left),
              ),
            ),
          if (canGoNext)
            Positioned(
              right: 8,
              top: size.height * 0.38,
              child: IconButton.filled(
                onPressed: () => setState(() => _index++),
                icon: const Icon(Icons.chevron_right),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton.filled(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPreviewDialog extends StatefulWidget {
  const _VideoPreviewDialog({required this.videoAsset});

  final String videoAsset;

  @override
  State<_VideoPreviewDialog> createState() => _VideoPreviewDialogState();
}

class _VideoPreviewDialogState extends State<_VideoPreviewDialog> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller?.play();
        }
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.85,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: controller == null || !controller.value.isInitialized
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: controller.value.size.width,
                                height: controller.value.size.height,
                                child: VideoPlayer(controller),
                              ),
                            ),
                          ),
                        ),
                        VideoProgressIndicator(
                          controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: AppColors.accentStrong,
                            bufferedColor: AppColors.border,
                            backgroundColor: AppColors.cardAlt,
                          ),
                        ),
                        const SizedBox(height: 8),
                        IconButton.filled(
                          onPressed: () {
                            if (controller.value.isPlaying) {
                              controller.pause();
                            } else {
                              controller.play();
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton.filled(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
