import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/item_filter/item_filter_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/item_card.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/items_header.dart';

class ItemsPage extends StatelessWidget {
  final List<Item> items;

  const ItemsPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No items found'));
    }

    return BlocProvider(
      create: (_) => ItemFilterBloc(),
      child: _ItemsView(allItems: items),
    );
  }
}

class _ItemsView extends StatelessWidget {
  final List<Item> allItems;

  const _ItemsView({required this.allItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemsHeader(allItems: allItems),

        Expanded(
          child: BlocBuilder<ItemFilterBloc, ItemFilterState>(
            builder: (context, state) {
              final filtered = filterItems(
                items: allItems,
                tab: state.activeTab,
                searchQuery: state.searchQuery,
              );

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No items found',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return ItemCard(item: filtered[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
