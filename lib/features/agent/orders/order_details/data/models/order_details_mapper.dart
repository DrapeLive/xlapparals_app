import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/agent_details.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/customer_detals.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';

import 'order_details_model.dart';

extension OrderDetailsMapper on OrderDetailsModel {
  OrderDetailsModel toEntity() {
    return OrderDetailsModel(
      id: id,
      items: items.map((e) {
        return OrderItem(
          id: e.id,
          item: e.item,
          variant: e.variant,
          itemName: e.itemName,
          itemPrice: e.itemPrice,
          variantImage: e.variantImage,
          sizeGroup: e.sizeGroup,
          itemType: e.itemType,
          quantity: e.quantity,
          pieceCount: e.pieceCount,
        );
      }).toList(),
      customerDetails: CustomerDetails(
        id: customerDetails.id,
        name: customerDetails.name,
        contact: customerDetails.contact,
        address: customerDetails.address,
        gst: customerDetails.gst,
      ),
      agentDetails: AgentDetails(
        id: agentDetails.id,
        username: agentDetails.username,
        contact: agentDetails.contact,
      ),
      totalSets: totalSets,
      totalPieces: totalPieces,
      status: status,
      expectedDeliveryDate: expectedDeliveryDate,
      preferredTransport: preferredTransport,
      transportCompany: transportCompany,
    );
  }
}
