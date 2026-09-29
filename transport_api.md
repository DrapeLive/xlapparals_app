# Transport API

## Overview

The Transport API manages transport/shipping methods used for customer preferences and order dispatch. Transports can be assigned as a customer's preferred transport and used when dispatching orders.

**Base URL:** `/api/transports/`

---

## Data Model

| Field | Type | Description |
|---|---|---|
| `id` | integer | Unique identifier (auto-generated) |
| `name` | string | Transport name (max 100 characters) |
| `is_active` | boolean | Whether this transport is currently available (default: `true`) |
| `created_at` | datetime | Timestamp of creation (auto-generated) |

---

## Endpoints

### List All Transports

```
GET /api/transports/
```

**Auth:** Public (no authentication required)

**Response:** `200 OK`

```json
[
  {
    "id": 1,
    "name": "FastCargo",
    "is_active": true,
    "created_at": "2026-01-15T10:30:00Z"
  }
]
```

---

### List Active Transports

```
GET /api/transports/active/
```

**Auth:** Public (no authentication required)

Returns only transports where `is_active` is `true`. Used by frontend dropdowns when selecting a transport.

**Response:** `200 OK`

```json
[
  {
    "id": 1,
    "name": "FastCargo",
    "is_active": true,
    "created_at": "2026-01-15T10:30:00Z"
  }
]
```

---

### Retrieve a Transport

```
GET /api/transports/{id}/
```

**Auth:** Public (no authentication required)

**Response:** `200 OK`

```json
{
  "id": 1,
  "name": "FastCargo",
  "is_active": true,
  "created_at": "2026-01-15T10:30:00Z"
}
```

**Error:** `404 Not Found` if transport does not exist.

---

### Create a Transport

```
POST /api/transports/
```

**Auth:** Admin only (requires `is_staff=true`)

**Request Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | Yes | Transport name |
| `is_active` | boolean | No | Defaults to `true` |

```json
{
  "name": "FastCargo",
  "is_active": true
}
```

**Response:** `201 Created`

```json
{
  "id": 1,
  "name": "FastCargo",
  "is_active": true,
  "created_at": "2026-01-15T10:30:00Z"
}
```

**Error:** `400 Bad Request` if validation fails. `403 Forbidden` if not admin.

---

### Update a Transport

```
PATCH /api/transports/{id}/
```

**Auth:** Admin only (requires `is_staff=true`)

**Request Body:** Partial update — only include fields to change.

```json
{
  "is_active": false
}
```

**Response:** `200 OK`

```json
{
  "id": 1,
  "name": "FastCargo",
  "is_active": false,
  "created_at": "2026-01-15T10:30:00Z"
}
```

**Error:** `400 Bad Request` if validation fails. `403 Forbidden` if not admin. `404 Not Found` if transport does not exist.

---

### Delete a Transport

```
DELETE /api/transports/{id}/
```

**Auth:** Admin only (requires `is_staff=true`)

**Response:** `204 No Content`

**Error:** `403 Forbidden` if not admin. `404 Not Found` if transport does not exist.

> **Note:** If a transport is referenced by customers or orders (via `preferred_transport` or `transport_company` foreign keys), deleting it will set those references to `NULL` (due to `SET_NULL` on delete).

---

## Permissions Summary

| Action | Auth Required |
|---|---|
| List (`GET /api/transports/`) | No |
| List active (`GET /api/transports/active/`) | No |
| Retrieve (`GET /api/transports/{id}/`) | No |
| Create (`POST /api/transports/`) | Admin |
| Update (`PATCH /api/transports/{id}/`) | Admin |
| Delete (`DELETE /api/transports/{id}/`) | Admin |

---

## Related Usage in Other APIs

Transports are referenced by other parts of the system:

- **Customers** — `preferred_transport` field accepts a transport ID when creating/updating a customer. Bulk import resolves transport by name (case-insensitive, must be active).
- **Orders** — `preferred_transport` field on place-order and save-edit. `transport_company` field on dispatch (along with `lr_number`).
