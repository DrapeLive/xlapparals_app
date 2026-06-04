import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/item_filter/item_filter_bloc.dart';

class ItemsHeader extends StatefulWidget {
  final List<Item> allItems;

  const ItemsHeader({super.key, required this.allItems});

  @override
  State<ItemsHeader> createState() => _ItemsHeaderState();
}

class _ItemsHeaderState extends State<ItemsHeader> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemFilterBloc, ItemFilterState>(
      builder: (context, state) {
        final inStockCount = widget.allItems
            .where((item) => !isItemOutOfStock(item))
            .length;
        final outOfStockCount = widget.allItems
            .where(
              (item) =>
                  isItemOutOfStock(item) ||
                  item.variants.any((v) => isVariantOutOfStock(v, item.type)),
            )
            .length;

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => context.read<ItemFilterBloc>().add(
                    ItemFilterSearchChanged(value),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    hintStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    suffixIcon: state.hasActiveFilters
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.textPrimary,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              context.read<ItemFilterBloc>().add(
                                const ItemFilterCleared(),
                              );
                            },
                          )
                        : null,
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
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _TabButton(
                        label: 'Stock In',
                        count: inStockCount,
                        isActive: state.activeTab == StockTab.inStock,
                        onTap: () => context.read<ItemFilterBloc>().add(
                          const ItemFilterTabChanged(StockTab.inStock),
                        ),
                      ),
                      _TabButton(
                        label: 'Stock Out',
                        count: outOfStockCount,
                        isActive: state.activeTab == StockTab.outOfStock,
                        onTap: () => context.read<ItemFilterBloc>().add(
                          const ItemFilterTabChanged(StockTab.outOfStock),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.black : AppColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? Colors.black12 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.primary : Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
