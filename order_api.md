# Orders & Items API Documentation

Base URL: `/api`

All endpoints in this document are grouped under **Items** (`/api/items/`) and **Orders** (`/api/orders/`).

---

## Authentication & Authorization

### Authentication
All endpoints require a **JWT Bearer token** unless explicitly stated otherwise.

```
Authorization: Bearer <access_token>
```

### Roles & Permissions

| Role | Notes |
|------|-------|
| `SUPERUSER` | Bypasses PIN checks. Always treated as `ADMIN`. Can manage all business types. |
| `ADMIN` | Scoped to their assigned `business` (`"gents"` or `"kids"`). Some destructive actions require a `pin`. |
| `AGENT` | Scoped to their own orders and assigned items. |

### PIN Check
For certain destructive admin operations (deleting items/orders), a valid `pin` must be supplied in the request body. Superusers and agents skip this check.

**Error (403):**
```json
{ "error": "Invalid PIN" }
```

### Business Scoping
Admins are scoped by their `business` type. Requests that fall outside their scope return `404` (rather than `403`) to avoid leaking existence.

---

## Common HTTP Status Codes

| Code | Meaning |
|------|---------|
| `200 OK` | Successful read / update / action |
| `201 Created` | Successful creation |
| `204 No Content` | Successful deletion |
| `400 Bad Request` | Validation error, business-rule violation, insufficient stock |
| `401 Unauthorized` | Missing / invalid JWT token |
| `403 Forbidden` | Authenticated but lacks permission, wrong PIN, not owner |
| `404 Not Found` | Resource not found or business-scoped out |
| `500 Internal Server Error` | Unexpected server error |

### Common Error Formats
- Action/APIView errors:
  ```json
  { "error": "Human-readable message" }
  ```
- Serializer validation errors:
  ```json
  { "field_name": ["Error message"] }
  ```

---

# Part 1 — Items API

Endpoints for managing products, their variants (QR codes, images), and stock.

---

## 1. List Items

Returns all active (non-deleted) items that are not out-of-stock for more than 30 days.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/`
- **Permission:** `IsAuthenticated`

**Response (200):**
```json
[
  {
    "id": 1,
    "name": "Premium Kurta",
    "type": "gents",
    "price": "599.00",
    "description": "High quality kurta",
    "brand_id": 1,
    "brand_name": "BrandX",
    "out_of_stock_since": null,
    "variants": [
      {
        "id": 10,
        "qr_code": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
        "image": "http://host/media/items/1/photo.jpg",
        "sizes": [
          { "id": 100, "size": "M,L,XL", "stock": 50 },
          { "id": 101, "size": "XXL", "stock": 20 }
        ],
        "display_order": "1"
      }
    ]
  }
]
```

---

## 2. Create Item

Creates a new item with its variants and variant sizes.

- **HTTP Method:** `POST`
- **Endpoint:** `/api/items/`
- **Permission:** `IsAdmin`
- **Content-Type:** `multipart/form-data` (for image upload)

**Request Body:**
```json
{
  "name": "Premium Kurta",
  "description": "High quality kurta",
  "price": 599.00,
  "type": "gents",
  "brand_id": 1,
  "variants": [
    {
      "image": "<file>",
      "remove_image": false,
      "display_order": "1",
      "sizes": [
        { "size": "M,L,XL", "stock": 50 },
        { "size": "XXL", "stock": 20 }
      ]
    }
  ]
}
```

**Field Notes:**
- `type`: `"gents"` or `"kids"`.
- `brand_id`: required for superusers; auto-assigned to the admin's own brand otherwise.
- Variant `size` values must be valid for the item `type` (kids vs gents).

**Response (201):** Full `ItemSerializer` representation (same shape as list response, single object).

**Errors:**
- `400`: `{ "brand_id": ["brand_id is required for superuser"] }`
- `400`: `{ "brand_id": ["Invalid brand_id"] }`
- `400`: `{ "brand_id": ["User has no brand assigned, please contact your superuser."] }`
- `400`: `{ "variants": ["'<size>' is not a valid size for kids items"] }`

---

## 3. Retrieve Item

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/{id}/`
- **Permission:** `IsAuthenticated`

**Response (200):** Single item object (same shape as list).

**Error (404):**
```json
{ "detail": "Not found." }
```

---

## 4. Update Item (Full / Partial)

Updates an item and its variants. Variants are updated by passing their `id`; new variants can be added (no `id`); omitted variants are deleted.

- **HTTP Method:** `PUT` / `PATCH`
- **Endpoint:** `/api/items/{id}/`
- **Permission:** `IsAdmin`
- **Content-Type:** `multipart/form-data`

**Request Body:** Same structure as Create Item. Add `"id"` to variants to update an existing variant.

```json
{
  "name": "Premium Kurta",
  "type": "gents",
  "price": 599.00,
  "variants": [
    {
      "id": 10,
      "image": "<file>",
      "remove_image": false,
      "display_order": "2",
      "sizes": [
        { "size": "M,L,XL", "stock": 80 }
      ]
    }
  ]
}
```

**Response (200):** Full `ItemSerializer` representation.

**Errors:** Same validation errors as Create Item.

---

## 5. Delete Item (Soft-Delete)

Marks the item as deleted. Orphaned variant images are removed from disk (only if not referenced by any `OrderItem`).

- **HTTP Method:** `DELETE`
- **Endpoint:** `/api/items/{id}/`
- **Permission:** `IsAdmin` + valid `pin` (superusers/agents skip)

**Request Body (for admins):**
```json
{ "pin": "1234" }
```

**Response:** `204 No Content`

**Error (403):**
```json
{ "error": "Invalid PIN" }
```

---

## 6. Stock List

Returns items with their variants, per-size stock, and totals. For agents, stock includes a "boost" from their own EDITING orders.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/stock-list/`
- **Permission:** `IsAuthenticated`

**Response (200):**
```json
[
  {
    "id": 1,
    "name": "Premium Kurta",
    "type": "gents",
    "price": "599.00",
    "image": "http://host/media/items/1/photo.jpg",
    "variants": [
      {
        "id": 10,
        "qr_code": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
        "image": "http://host/media/items/1/photo.jpg",
        "sizes": [
          { "size_range": "M,L,XL", "stock": 50 },
          { "size_range": "XXL", "stock": 20 }
        ],
        "total_stock": 70,
        "display_order": "1"
      }
    ]
  }
]
```

---

## 7. Get Item By QR Code

Looks up an item by scanning its variant QR code.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/by-qr/?qr_code=<uuid>&agent_id=<int>`
- **Permission:** `IsAuthenticated`

**Query Parameters:**
| Param | Required | Description |
|-------|----------|-------------|
| `qr_code` | Yes | The variant UUID |
| `agent_id` | No | If provided, validates the item is assigned to that agent |

**Response (200):**
```json
{
  "id": 1,
  "name": "Premium Kurta",
  "price": "599.00",
  "type": "gents",
  "description": "...",
  "variants": [
    {
      "id": 10,
      "qr_code": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "image": "http://host/media/items/1/photo.jpg",
      "sizes": [
        { "id": 100, "size_range": "M,L,XL", "stock": 50 }
      ],
      "display_order": "1"
    }
  ],
  "matched_variant_id": 10
}
```

**Errors:**
- `400`: `{ "error": "No such item with this QR exists" }`
- `400`: `{ "error": "Invalid QR code" }`
- `400`: `{ "error": "This item is not assigned to you. Please contact admin for assignment." }`
- `404`: `{ "error": "Variant not found" }`
- `404`: `{ "error": "Not found" }` (business-scoped)
- `404`: `{ "error": "Agent not found" }`

---

## 8. Archived Items

Items that are out of stock and have been so for more than 30 days.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/archived/`
- **Permission:** `IsAuthenticated`

**Response (200):** Array of full `ItemSerializer` objects.

---

## 9. Check Stock Availability (by QR)

Checks whether a variant (per QR) is in stock for a given item type, considering existing draft quantities.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/by-qr/out-of-stock/?qr_code=<uuid>&order_id=<int>`
- **Permission:** `IsAuthenticated`

**Query Parameters:**
| Param | Required | Description |
|-------|----------|-------------|
| `qr_code` | Yes | UUID of the variant |
| `order_id` | No | DRAFT order ID whose quantities should be subtracted |

**Response (200):**
```json
{
  "out_of_stock": false,
  "group_stock": {
    "S,M,L,XL,XXL": 20,
    "S,M,L,XL": 15
  }
}
```

**Errors:**
- `400`: `{ "error": "Invalid QR code" }`
- `404`: `{ "error": "Variant not found" }`
- `404`: `{ "error": "Not found" }`

---

## 10. Size Ranges

Returns the allowed size ranges for item creation and order creation, grouped by item type.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/size-ranges`
- **Permission:** `AllowAny` (no auth required)

**Response (200):**
```json
{
  "item_creation_sizes_by_type": {
    "gents": ["S,M,L,XL,XXL", "S,M,L,XL", "M,L,XL,XXL", "M,L,XL"],
    "kids": ["20-24", "26-36", "38"]
  },
  "order_creation_sizes_by_type": {
    "gents": ["S,M,L,XL,XXL", "S,M,L,XL", "M,L,XL,XXL", "M,L,XL"],
    "kids": ["20-24", "20-36", "20-30", "26-36", "32-36", "20-38", "26-38", "32-38"]
  }
}
```

---

## 11. List Variants

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/variants/`
- **Permission:** `IsAuthenticated`

**Response (200):**
```json
[
  {
    "id": 10,
    "qr_code": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "image": "http://host/media/items/1/photo.jpg",
    "sizes": [
      { "id": 100, "size": "M,L,XL", "stock": 50 }
    ],
    "display_order": "1"
  }
]
```

---

## 12. Create Variant

- **HTTP Method:** `POST`
- **Endpoint:** `/api/items/variants/`
- **Permission:** `IsAdmin`

**Request Body:**
```json
{
  "item": 1,
  "image": "<file>",
  "display_order": "1",
  "sizes": [
    { "size": "M,L,XL", "stock": 50 }
  ]
}
```

**Response (201):** Full `ItemVariantSerializer` representation.

---

## 13. Retrieve Variant

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/variants/{id}/`
- **Permission:** `IsAuthenticated`

**Response (200):** Single variant object.

---

## 14. Update Variant

- **HTTP Method:** `PUT` / `PATCH`
- **Endpoint:** `/api/items/variants/{id}/`
- **Permission:** `IsAdmin`

**Request Body:** Same structure as Create Variant.

**Response (200):** Full variant representation.

---

## 15. Delete Variant

Permanently deletes a variant. The image is removed from disk; parent item stock/`out_of_stock_since` is recalculated.

- **HTTP Method:** `DELETE`
- **Endpoint:** `/api/items/variants/{id}/`
- **Permission:** `IsAdmin`

**Response:** `204 No Content`

---

## 16. All Variants (Flat Stock List)

Returns a flat list of all variants with item details, stock, and available sizes.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/items/variants/all/`
- **Permission:** `IsAuthenticated`

**Response (200):**
```json
[
  {
    "id": 10,
    "item_id": 1,
    "item_name": "Premium Kurta",
    "item_type": "gents",
    "item_price": "599.00",
    "qr_code": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "image": "http://host/media/items/1/photo.jpg",
    "sizes": [
      { "size": "M,L,XL", "stock": 50 },
      { "size": "XXL", "stock": 20 }
    ],
    "total_stock": 70,
    "unique_sizes": ["M,L,XL", "XXL"]
  }
]
```

---

# Part 2 — Orders API

Endpoints for creating and managing orders, order items, and the order lifecycle (draft → pending → editing → packed → dispatched).

---

## Order Statuses

| Status | Description |
|--------|-------------|
| `DRAFT` | In progress, no stock deducted yet. Stale drafts (>15 min) auto-deleted. |
| `PENDING` | Confirmed, stock deducted. Open for editing by the owning agent. |
| `EDITING` | Agent is editing a PENDING order; stock temporarily returned to pool. |
| `PACKED` | Items packed (partial/fully); only unpacked stock returned on dispatch. |
| `DISPATCHED` | Shipped. Orders dispatched >30 days move to archive. |

---

## 1. List Orders

- **HTTP Method:** `GET`
- **Endpoint:** `/api/orders/`
- **Permission:** `IsAuthenticated`

**Query Parameters:**
| Param | Required | Description |
|-------|----------|-------------|
| `customer` | No | Filter by customer ID |
| `agent` | No | Filter by agent ID (admin only) |
| `status` | No | Repeatable filter; values: `DRAFT`, `PENDING`, `EDITING`, `PACKED`, `DISPATCHED` |
| `from_date` | No | Orders created on/after this date |
| `to_date` | No | Orders created on/before this date |
| `search` | No | Searches customer name, agent username, order ID |
| `page` | No | Pagination; default page_size `50`, max `200` |
| `page_size` | No | Override page size |

**Side Effects on List:**
- Stale `DRAFT` orders (>15 min) for the requesting agent are deleted.
- Stale `EDITING` orders (>15 min) are reverted to `PENDING`.
- `DISPATCHED` orders older than 30 days are excluded (moved to archive).

**Response (200) — Paginated:**
```json
{
  "count": 100,
  "next": "http://host/api/orders/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "status": "PENDING",
      "expected_delivery_date": "2026-09-15",
      "preferred_transport": 3,
      "transport_company": null,
      "lr_number": "",
      "reservation_snapshot": [],
      "editing_started_at": null,
      "notes": "Urgent delivery",
      "created_at": "2026-09-01T10:00:00Z",
      "dispatched_at": null,
      "customer": 1,
      "agent": 1,
      "total_sets": 5,
      "total_pieces": 20,
      "agent_details": {
        "id": 1,
        "username": "agent1",
        "contact": "9876543210"
      },
      "customer_details": {
        "id": 1,
        "name": "Ravi Traders",
        "contact": "9876543211",
        "address": "Delhi, India",
        "gst": "07AAACR1234F1ZH"
      },
      "items": [
        {
          "id": 10,
          "item": 1,
          "variant": 10,
          "size_group": "S,M,L,XL",
          "item_type": "gents",
          "item_name": "Premium Kurta",
          "item_name_display": "Premium Kurta",
          "item_price": "599.00",
          "item_price_display": "599.00",
          "variant_image": "http://host/media/items/1/photo.jpg",
          "variant_image_display": "http://host/media/items/1/photo.jpg",
          "variant_display_order": "1",
          "size": "",
          "size_display": "",
          "quantity": 5,
          "packed_quantity": 0,
          "piece_count": 3
        }
      ]
    }
  ]
}
```

**Notes:**
- `total_sets` = sum of item `quantity`.
- `total_pieces` = sum of `quantity × piece_count` per item.
- `piece_count` depends on `item_type` + `size_group`.
- `customer` is write-only; the customer object is always returned via `customer_details`.

---

## 2. Create Order

Creates a `DRAFT` order for the requesting agent.

- **HTTP Method:** `POST`
- **Endpoint:** `/api/orders/`
- **Permission:** `IsAuthenticated`

**Request Body:**
```json
{ "customer": 1 }
```

The `agent` is auto-set to `request.user.agent`.

**Response (201):** Full `OrderSerializer` representation.

**Errors:**
- `400`: `{ "customer": ["This field is required."] }`
- `400`: `{ "customer": ["Invalid pk \"999\" - object does not exist."] }`

---

## 3. Retrieve Order

- **HTTP Method:** `GET`
- **Endpoint:** `/api/orders/{id}/`
- **Permission:** `IsAuthenticated`

**Response (200):** Full `OrderSerializer` representation (same as list item).

**Error (404):**
```json
{ "detail": "Not found." }
```

---

## 4. Update Order

- **HTTP Method:** `PUT` / `PATCH`
- **Endpoint:** `/api/orders/{id}/`
- **Permission:** `IsAuthenticated`

**Request Body:**
```json
{
  "expected_delivery_date": "2026-09-15",
  "preferred_transport": 3,
  "notes": "Updated notes"
}
```

**Response (200):** Full `OrderSerializer` representation.

---

## 5. Delete Order

Deletes an order. For non-DRAFT orders, stock is returned to the warehouse and an `ORDER_DELETED` log is created.

- **HTTP Method:** `DELETE`
- **Endpoint:** `/api/orders/{id}/`
- **Permission:** `IsAuthenticated` + `pin` (admins; superusers/agents skip)

**Request Body (for admins):**
```json
{ "pin": "1234" }
```

**Response:** `204 No Content`

**Error (403):**
```json
{ "error": "Invalid PIN" }
```

---

## 6. Place Order

Validates stock, deducts it, and transitions a `DRAFT` order to `PENDING`. Sends push notifications on both success and out-of-stock failure.

- **HTTP Method:** `POST`
- **Endpoint:** `/api/orders/{id}/place-order/`
- **Permission:** `IsAuthenticated`

**Request Body:**
```json
{
  "expected_delivery_date": "2026-09-15",
  "preferred_transport": 3,
  "notes": "Urgent delivery"
}
```

All fields optional.

**Success Response (200):**
```json
{
  "message": "Order placed successfully",
  "order_id": 1
}
```

**Error (400):**
```json
{
  "error": "Some items are no longer available. Another agent may have placed an order.",
  "out_of_stock_items": [
    {
      "item_name": "Premium Kurta",
      "size_group": "S,M,L,XL",
      "size": "M,L,XL",
      "required": 5,
      "available": 2,
      "order_item_id": 10
    }
  ]
}
```

---

## 7. Add Item to Order

Adds an item (by QR) to a DRAFT/EDITING order. Snapshots item name, price, and image onto the order item.

- **HTTP Method:** `POST`
- **Endpoint:** `/api/orders/{id}/add-item/`
- **Permission:** `IsAgent`

**Request Body:**
```json
{
  "qr_code": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "quantity": 5,
  "size_group": "S,M,L,XL",
  "size": ""
}
```

**Validation Rules:**
- Order must be `DRAFT`, `EDITING`, or `PENDING`.
- QR must resolve to a non-deleted variant.
- Item must be assigned to the agent (`AgentItem`).
- All items in the order must share the same `item_type`.
- `size_group` must be valid for the item type.

**Success Response (201):**
```json
{ "message": "Item added successfully" }
```

**Errors (400):**
```json
{ "error": "Items can only be added to DRAFT or EDITING orders" }
```
```json
{ "error": "This item is not assigned to you. Please contact admin for assignment." }
```
```json
{ "error": "Order can only contain items of gents type" }
```
```json
{ "error": "Invalid size group" }
```
```json
{ "error": "Invalid QR Code" }
```
```json
{ "error": "This item has been deleted" }
```

---

## 8. Delete Item from Order

- **HTTP Method:** `DELETE`
- **Endpoint:** `/api/orders/{id}/delete-item/{item_id}/`
- **Permission:** `IsAuthenticated`

**Behavior:**
- For non-DRAFT/non-EDITING orders: stock is returned to the warehouse.
- For DRAFT/EDITING orders: no stock was deducted, so none is returned.
- Creates an `ITEM_DELETED` log.

**Response (200):**
```json
{ "message": "Item Deleted Successfully" }
```

---

## 9. Start Edit

Begins editing a `PENDING` order. Snapshots current items, returns nothing to stock yet (handled on save), clears view tracking.

- **HTTP Method:** `POST`
- **Endpoint:** `/api/orders/{id}/start-edit/`
- **Permission:** `IsAgent` (must own the order)

**Response (200):**
```json
{ "message": "Edit started" }
```

**Errors:**
- `400`: `{ "error": "Only PENDING orders can be edited" }`
- `403`: `{ "error": "Unauthorized" }`

---

## 10. Save Edit

Commits an edited `PENDING` order. Returns snapshot stock, re-checks current stock, deducts, and sets status back to `PENDING`.

- **HTTP Method:** `POST`
- **Endpoint:** `/api/orders/{id}/save-edit/`
- **Permission:** `IsAgent`

**Request Body:**
```json
{
  "expected_delivery_date": "2026-09-20",
  "preferred_transport": 5,
  "notes": "Updated notes"
}
```

All fields optional.

**Success Response (200):**
```json
{ "message": "Order saved successfully", "order_id": 1 }
```

**Error (400):**
```json
{
  "error": "Some items are no longer available. Another agent may have placed an order.",
  "out_of_stock_items": [ ... ]
}
```

---

## 11. Cancel Edit

Reverts an `EDITING` order back to `PENDING`, restoring items from the reservation snapshot.

- **HTTP Method:** `POST`
- **Endpoint:** `/api/orders/{id}/cancel-edit/`
- **Permission:** `IsAuthenticated` (must own the order)

**Response (200):**
```json
{ "message": "Edit cancelled" }
```

**Errors:**
- `400`: `{ "error": "Order is not in editing mode" }`
- `403`: `{ "error": "Unauthorized" }`

---

## 12. Dispatch Order

Dispatches a `PENDING` or `PACKED` order. Returns the unpacked portion of stock and sets `dispatched_at`.

- **HTTP Method:** `POST`
- **Endpoint:** `/api/orders/{id}/dispatch/`
- **Permission:** `IsAuthenticated`

**Request Body:**
```json
{
  "transport_company": 3,
  "lr_number": "LR-12345"
}
```

All fields optional.

**Response (200):**
```json
{ "message": "Order dispatched successfully" }
```

**Error (400):**
```json
{ "error": "Only PENDING or PACKED orders can be dispatched" }
```

---

## 13. Get Invoice

Generates an invoice including brand details, GST rate, and total price.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/orders/{id}/invoice/`
- **Permission:** `IsAuthenticated`

**Response (200):**
```json
{
  "id": 1,
  "customer": {
    "id": 1,
    "name": "Ravi Traders",
    "contact": "9876543211",
    "address": "Delhi, India",
    "gst": "07AAACR1234F1ZH"
  },
  "agent": {
    "id": 1,
    "username": "agent1",
    "contact": "9876543210"
  },
  "brand": {
    "id": 1,
    "name": "BrandX",
    "phone": "1234567890",
    "email": "brand@example.com",
    "address_line1": "123 Main St",
    "address_line2": "",
    "gst": "07AAACR1234F1ZG",
    "logo_url": "http://host/media/brand/logo.png"
  },
  "created_at": "2026-09-01T10:00:00Z",
  "status": "PENDING",
  "items": [ ... ],
  "total_price": 8985.00,
  "gst_rate": 5.0
}
```

- `total_price` = sum of `item_price × quantity × piece_count` for each item.
- `gst_rate` is the global GST rate from settings.

**Error (404):**
```json
{ "error": "Not found" }
```

---

## 14. Get Order Logs

Returns the audit log for an order.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/orders/{id}/logs/`
- **Permission:** `IsAuthenticated`

**Log Actions:** `ITEM_DELETED`, `ORDER_DELETED`, `ORDER_EDITED`, `DISPATCHED`, `EDIT_STARTED`, `EDIT_SAVED`, `EDIT_CANCELLED`

**Response (200):**
```json
[
  {
    "id": 1,
    "action": "EDIT_SAVED",
    "details": { "items_count": 3 },
    "performed_by": "agent1",
    "created_at": "2026-09-01T10:30:00+00:00"
  },
  {
    "id": 2,
    "action": "DISPATCHED",
    "details": { "packed_items": 2, "total_items": 3 },
    "performed_by": "admin1",
    "created_at": "2026-09-02T09:00:00+00:00"
  }
]
```

**Errors:**
- `403`: `{ "error": "Unauthorized" }`
- `404`: `{ "error": "Not found" }`

---

## 15. My Viewed Order IDs

Returns the IDs of orders the current user has marked as viewed.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/orders/my-viewed-ids/`
- **Permission:** `IsAuthenticated`

**Response (200):**
```json
[1, 5, 12]
```

---

## 16. Mark Order Viewed

- **HTTP Method:** `POST`
- **Endpoint:** `/api/orders/{id}/mark-viewed/`
- **Permission:** `IsAuthenticated`

**Behavior:**
- For `PENDING`/`PACKED` orders: creates a `UserViewedOrder` entry.
- For other statuses: removes any existing entry.

**Response (200):**
```json
{ "message": "Viewed status updated" }
```

---

## 17. Order IDs (Lightweight)

Returns lightweight ID/status list of all orders visible to the user.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/orders/order-ids/`
- **Permission:** `IsAuthenticated`

**Response (200):**
```json
[
  { "id": 1, "status": "PENDING" },
  { "id": 2, "status": "DRAFT" },
  { "id": 3, "status": "DISPATCHED" }
]
```

---

## 18. Archived Orders

`DISPATCHED` orders older than 30 days. Paginated.

- **HTTP Method:** `GET`
- **Endpoint:** `/api/orders/archived/`
- **Permission:** `IsAuthenticated`

**Response (200):** Paginated format identical to List Orders.

---

## 19. List Order Items

- **HTTP Method:** `GET`
- **Endpoint:** `/api/orders/order-items/`
- **Permission:** `IsAuthenticated`

**Response (200):** Array of `OrderItemSerializer` objects (see item shape in List Orders).

---

## 20. Create Order Item

- **HTTP Method:** `POST`
- **Endpoint:** `/api/orders/order-items/`
- **Permission:** `IsAuthenticated`

**Request Body:**
```json
{
  "order": 1,
  "item": 1,
  "variant": 10,
  "size_group": "S,M,L,XL",
  "item_type": "gents",
  "item_name": "Premium Kurta",
  "item_price": 599.00,
  "variant_image": "http://host/media/items/1/photo.jpg",
  "size": "",
  "quantity": 5
}
```

**Response (201):** Full `OrderItemSerializer` representation.

---

## 21. Retrieve Order Item

- **HTTP Method:** `GET`
- **Endpoint:** `/api/orders/order-items/{id}/`
- **Permission:** `IsAuthenticated`

**Response (200):** Single order item object.

---

## 22. Update Order Item

Updates quantity and/or size group of an order item.

- **HTTP Method:** `PUT` / `PATCH`
- **Endpoint:** `/api/orders/order-items/{id}/`
- **Permission:** `IsAuthenticated`

**Request Body:**
```json
{
  "quantity": 10,
  "size_group": "M,L,XL"
}
```

**Behavior:**
- Allowed statuses: `DRAFT`, `EDITING`, `PENDING`, `PACKED`.
- `EDITING`: saved directly with no stock adjustment.
- `PENDING`/`PACKED`: old stock returned, new stock validated/deducted, `ORDER_EDITED` log created.

**Errors (400):**
```json
{ "error": "Cannot edit items in this order status" }
```
```json
{ "error": "Invalid size group for this item type" }
```
```json
{ "error": "Size M,L,XL not found for this variant" }
```
```json
{ "error": "Insufficient stock in M,L,XL" }
```

---

## 23. Delete Order Item

- **HTTP Method:** `DELETE`
- **Endpoint:** `/api/orders/order-items/{id}/`
- **Permission:** `IsAuthenticated`

**Behavior:** For non-DRAFT/non-EDITING orders, returns stock to warehouse; creates `ITEM_DELETED` log.

**Response:** `204 No Content`

---

# Appendix — Stock Lifecycle Rules

1. **Deduction** happens only when:
   - An order transitions `DRAFT → PENDING` (via `place-order`).
   - An order item's quantity/size changes on a non-DRAFT/non-EDITING order.

2. **Restoration** happens when:
   - A non-DRAFT order is deleted.
   - An item is removed from a non-DRAFT/non-EDITING order.
   - An edit is saved (snapshot returned first).
   - An edit is cancelled.
   - An order is dispatched (only the unpacked portion).

3. **Agent reservation boost** — agents see extra available stock from their own EDITING orders (since that stock was returned to the global pool when editing started).
