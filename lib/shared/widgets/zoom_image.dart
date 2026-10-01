import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';

class ZoomableImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ZoomableImage({
    super.key,
    required this.imageUrl,
    this.width = 55,
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    // Decode at display size (x device pixel ratio) instead of full source
    // resolution, so the many small thumbnails stay cheap to decode and cache.
    // Only width is constrained: ResizeImagePolicy.exact applies both values
    // verbatim, which would squash non-square images, so the engine derives
    // the height from the source's aspect ratio and BoxFit.cover crops.
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth = (width * pixelRatio).ceil();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullScreenImageViewer(imageUrl: imageUrl),
            ),
          );
        },
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          memCacheWidth: cacheWidth,
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  bool _sharing = false;

  Future<void> _shareImage() async {
    setState(() => _sharing = true);
    try {
      final dio = Dio();
      final tempDir = await getTemporaryDirectory();

      // Derive a safe filename from the URL
      final uri = Uri.parse(widget.imageUrl);
      final fileName = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : 'shared_image.jpg';
      final filePath = '${tempDir.path}/$fileName';

      await dio.download(widget.imageUrl, filePath);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          subject: 'Shared Image',
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _sharing
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  tooltip: 'Share image',
                  onPressed: _shareImage,
                ),
        ],
      ),

      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

