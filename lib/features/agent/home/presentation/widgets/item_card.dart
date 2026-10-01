import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/core/utils/stock_validators.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_state.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/stock_badge.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/variant_card.dart';
import 'package:xlapparals_app/shared/widgets/zoom_image.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool autoExpand;
  final String? highlightVariantQrCode;

  const ItemCard({
    super.key,
    required this.item,
    this.autoExpand = false,
    this.highlightVariantQrCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      buildWhen: (previous, current) =>
          previous.expandeditems != current.expandeditems,
      builder: (context, state) {
        final expanded =
            state.expandeditems.contains("${item.id}") || autoExpand;

        final allOut = isItemOutOfStock(item);
        final partialOut = isItemPartiallyOutOfStock(item);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: allOut ? const Color(0xFFFFF1F1) : Colors.white,
            border: Border.all(
              color: allOut ? Colors.red.shade200 : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  context.read<ItemBloc>().add(
                    ToggleItemExpansion("${item.id}"),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ZoomableImage(
                          imageUrl: item.variants[0].image,
                          width: 55,
                          height: 55,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontFamily: AppConstants.fontFamily,
                                  ),
                                ),

                                const SizedBox(width: 6),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.border,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.type,
                                    style: const TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Text(
                                  "${item.variants.length} colors",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                    fontFamily: AppConstants.fontFamily,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  "₹${item.price}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    fontFamily: AppConstants.fontFamily,
                                    fontSize: 12,
                                  ),
                                ),

                                if (allOut)
                                  StockBadge(
                                    label: "Out of stock",
                                    color: Colors.red,
                                  )
                                else if (partialOut)
                                  StockBadge(
                                    label: "Some out",
                                    color: Colors.orange,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      _ShareItemButton(item: item),

                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ),
              ),

<<<<<<< HEAD
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: (item.variants.toList()
                          ..sort((a, b) {
                            final aOrder = int.tryParse(a.displayOrder) ?? 0;
                            final bOrder = int.tryParse(b.displayOrder) ?? 0;
                            return aOrder.compareTo(bOrder);
                          }))
                        .map(
                          (variant) => VariantCard(
                            isOutofStock: allOut,
                            type: item.type,
                            variant: variant,
                          ),
                        )
                        .toList(),
                  ),
                ),
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
=======
              // AnimatedCrossFade kept the full variant list built for every
              // collapsed item (it always lays out both children), turning the
              // Items tab into a huge invisible tree. Build variants only when
              // expanded and animate the size change instead.
              AnimatedSize(
>>>>>>> ae51382 (Update agent app features)
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                clipBehavior: Clip.none,
                child: expanded
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: item.variants
                              .asMap()
                              .entries
                              .map(
                                (entry) => VariantCard(
                                  isOutofStock: allOut,
                                  type: item.type,
                                  variant: entry.value,
                                  index: (entry.key) + 1,
                                  highlightQrCode: highlightVariantQrCode,
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShareItemButton extends StatefulWidget {
  final Item item;

  const _ShareItemButton({required this.item});

  @override
  State<_ShareItemButton> createState() => _ShareItemButtonState();
}

class _ShareItemButtonState extends State<_ShareItemButton> {
  bool _sharing = false;

  String get _shareDescription {
    final item = widget.item;
    final buffer = StringBuffer('*${item.name}*\n');
    buffer.writeln('Price: ₹${item.price}');
    buffer.writeln('Colors: ${item.variants.length}');
    return buffer.toString();
  }

  Future<void> _shareVariants() async {
    if (_sharing) return;
    setState(() => _sharing = true);

    try {
      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final files = <XFile>[];

      for (var i = 0; i < widget.item.variants.length; i++) {
        final imageUrl = widget.item.variants[i].image;
        if (imageUrl.isEmpty) continue;

        final uri = Uri.parse(imageUrl);
        final lastSegment = uri.pathSegments.isNotEmpty
            ? uri.pathSegments.last
            : 'variant_${i + 1}.jpg';
        final extension = lastSegment.contains('.')
            ? lastSegment.split('.').last
            : 'jpg';
        final filePath =
            '${tempDir.path}/item_${widget.item.id}_variant_${i + 1}.$extension';

        await dio.download(imageUrl, filePath);
        files.add(XFile(filePath));
      }

      if (!mounted) return;
      if (files.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No images available to share')),
        );
        return;
      }

      await SharePlus.instance.share(
        ShareParams(
          files: files,
          text: _shareDescription,
          subject: widget.item.name,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share item: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      icon: _sharing
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.share, size: 20, color: AppColors.primary),
      tooltip: 'Share all colors',
      onPressed: _sharing ? null : _shareVariants,
    );
  }
}
