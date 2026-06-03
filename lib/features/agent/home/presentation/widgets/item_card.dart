import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_state.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/variant_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      buildWhen: (previous, current) =>
          previous.expandeditems != current.expandeditems,
      builder: (context, state) {
        final expanded = state.expandeditems.contains("${item.id}");

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
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
                        child: CachedNetworkImage(
                          imageUrl: item.variants[0].image,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
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
                                  ),
                                ),

                                const SizedBox(width: 6),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.border,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.type,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Text("${item.variants.length} variants"),

                                const SizedBox(width: 8),

                                Text(
                                  "₹${item.price}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),

                                // if ()
                                //   const Padding(
                                //     padding: EdgeInsets.only(left: 12),
                                //     child: Text(
                                //       "Some out",
                                //       style: TextStyle(color: Colors.red),
                                //     ),
                                //   ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ),
              ),

              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: item.variants
                        .asMap()
                        .entries
                        .map(
                          (entry) => VariantCard(
                            variant: entry.value,
                            index: (entry.key) + 1,
                          ),
                        )
                        .toList(),
                  ),
                ),
                crossFadeState: expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        );
      },
    );
  }
}
