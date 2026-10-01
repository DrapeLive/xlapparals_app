import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/variant.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_state.dart';

class ItemSearchBox extends StatefulWidget {
  final ValueChanged<String> onItemSelected;

  const ItemSearchBox({super.key, required this.onItemSelected});

  @override
  State<ItemSearchBox> createState() => _ItemSearchBoxState();
}

class _ItemSearchBoxState extends State<ItemSearchBox> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ItemFetchBloc>().state;
      if (state is! ItemFetchLoaded && state is! ItemFetchLoading) {
        context.read<ItemFetchBloc>().add(FetchItems());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Variant _pickVariant(Item item) {
    for (final variant in item.variants) {
      if (variant.sizeRanges.any((s) => s.stock > 0)) return variant;
    }
    return item.variants.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemFetchBloc, ItemFetchState>(
      builder: (context, state) {
        final items = state is ItemFetchLoaded ? state.items : <Item>[];

        final query = _query.trim().toLowerCase();

        final results = query.isEmpty
            ? <Item>[]
            : items.where((item) {
                return item.name.toLowerCase().contains(query);
              }).toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search item by name...',
                hintStyle: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textPrimary,
                  size: 16,
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            if (_query.trim().isNotEmpty) ...[
              const SizedBox(height: 8),

              results.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Center(
                        child: Text(
                          state is ItemFetchLoading
                              ? 'Loading items...'
                              : 'No items found',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      constraints: const BoxConstraints(maxHeight: 180),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: results.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1, color: AppColors.border),
                        itemBuilder: (context, index) {
                          final item = results[index];

                          return InkWell(
                            onTap: () {
                              widget.onItemSelected(
                                _pickVariant(item).qrCode,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: item.variants.first.image,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      placeholder: (_, _) => Container(
                                        width: 40,
                                        height: 40,
                                        color: Colors.grey.shade200,
                                      ),
                                      errorWidget: (_, _, _) => Container(
                                        width: 40,
                                        height: 40,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.inventory_2_outlined,
                                          size: 20,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${item.variants.length} colors',
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '₹${item.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ],
        );
      },
    );
  }
}