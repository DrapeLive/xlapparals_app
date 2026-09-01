import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/utils/size_utils.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_detail_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_event.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/widgets/quntity_selector.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/widgets/size_drop_down.dart';
import 'package:xlapparals_app/shared/pages/loading_page.dart';

import '../widgets/add_to_order_button.dart';
import '../widgets/item_image_section.dart';
import '../widgets/variant_thumbnail_list.dart';

import 'package:xlapparals_app/core/theme/app_colors.dart';

class ItemDetailsPage extends StatefulWidget {
  final int agentId;
  final int orderId;
  final String qrCode;

  const ItemDetailsPage({
    super.key,
    required this.orderId,
    required this.qrCode,
    required this.agentId,
  });

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  void initState() {
    super.initState();

    context.read<ItemDetailsBloc>().add(
      FetchItemDetails(qrCode: widget.qrCode, agentId: widget.agentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(
            RouteNames.scanner,
            extra: {"agentId": widget.agentId, "orderId": widget.orderId},
          );
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.go(
                  RouteNames.scanner,
                  extra: {"agentId": widget.agentId, "orderId": widget.orderId},
                );
              },
            ),
          ),
          body: BlocConsumer<ItemDetailsBloc, ItemDetailsState>(
            listener: (context, state) async {
              if (state.isUnassignedItem) {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    icon: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.link_off_rounded,
                        color: Colors.orange.shade600,
                        size: 32,
                      ),
                    ),
                    title: const Text(
                      'Unassigned Item',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      'This item is not assigned to you. Please contact admin for assignment.',
                      textAlign: TextAlign.center,
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            context.go(
                              RouteNames.scanner,
                              extra: {
                                "agentId": widget.agentId,
                                "orderId": widget.orderId,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Scan Another Item',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return;
              }

              if (state.addedSuccessfully) {
                context.go(RouteNames.orderDetails, extra: widget.orderId);
              }
              if (state.error != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error!)));
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return LoadingPage(message: "Fetch Items...");
              }

              if (state.item == null) {
                return const SizedBox();
              }

              final item = state.item!;
              final variant = item.variants[state.selectedVariantIndex];

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemImageSection(imageUrl: variant.image),

                      const SizedBox(height: 16),

                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      Text(
                        "PREMIUM COLLECTION",
                        style: TextStyle(fontSize: 12),
                      ),

                      const SizedBox(height: 16),

                      VariantThumbnailList(variants: item.variants),

                      const SizedBox(height: 16),

                      Text(
                        "DESCRIPTION",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),

                      Text(item.description, style: TextStyle(fontSize: 11)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Size Group",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      SizeDropdown(
                        sizes: SizeRangeUtils.getAvailableSizes(
                          variantSizes: variant.sizes,
                          itemType: item.type,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const QuantitySelector(),

                      const SizedBox(height: 24),

                      AddToOrderButton(
                        loading: state.isAdding,
                        onTap: () {
                          context.read<ItemDetailsBloc>().add(
                            AddItemToOrder(widget.orderId),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
