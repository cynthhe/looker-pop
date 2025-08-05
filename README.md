# looker-pop

A modular LookML toolkit for implementing dynamic Period over Period (PoP) comparisons, custom date granularity controls, and parameter-driven filtering across Looker dashboards. Designed for both **GoogleSQL** and **Databricks SQL** environments, this repo enables teams to add flexible, reusable time-based logic to their models and explores.

---

## 📁 Repository Structure

| File                            | Purpose                                                                                                                                               |
|---------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| `base_filters.view.lkml`        | Provides a `formatting_style` parameter used by other views to standardize formatting behavior.                                                       |
| `dynamic_pop.view.lkml`         | Implements dynamic period-over-period logic for **GoogleSQL** models. Includes current/previous period calculations and filter handling.             |
| `pop_block.lkml`                | A **Databricks-compatible** variant of `dynamic_pop.view.lkml`. Provides identical PoP filtering logic with syntax tailored for Databricks SQL.       |
| `granularity_controls.view.lkml` | Offers a `timeframe_picker` parameter and dynamic date aggregation (Day, Week, Month, Quarter, Year) using a shared date field. Enables UI-driven granularity changes. |

---

## 🔧 Key Features

### 1. Dynamic Period-over-Period Filtering
- Automatically determines the current period and previous period based on user-selected date ranges.
- Uses calculated dimensions (`is_current_period`, `is_previous_period`) for clear PoP segmentation.
- Compatible with Looker extensions to centralize PoP logic.

### 2. Environment-Specific Implementations
- `dynamic_pop.view.lkml` is designed for **GoogleSQL**.
- `pop_block.lkml` is designed for **Databricks SQL** (with syntax differences like `DATEDIFF()` and `DATEADD()`).

### 3. Flexible Date Granularity
- `granularity_controls.view.lkml` allows users to dynamically switch aggregation levels via a parameterized picker.
- Automatically adjusts dimensions using `if-else` logic based on the selected granularity.

### 4. Base Parameterization
- `base_filters.view.lkml` includes configurable `formatting_style` parameters (e.g., `"Simple"` or `"Custom"`) for standardizing visual behavior or formatting logic across views.

---

## 🚀 Usage Guide

### Step 1: Extend Views

In your core views or explores, extend the base views:

```lookml
include: "path/to/base_filters.view.lkml"
include: "path/to/dynamic_pop.view.lkml"
include: "path/to/granularity_controls.view.lkml"
```
### Step 2: Use Date Filters
Apply the provided `date_filter` or `pop_date_filter` in your explore definitions or dashboard filters:

```lookml
explore: orders {
  view_label: "Period Over Period"
  always_filter: {
    field: dynamic_period_over_period.date_filter
    value: "30 days"
  }
}
```

### Step 3: Leverage Dimensions in Visuals
Use the period dimension to break down metrics by Current and Previous periods for easy visualization in Looker dashboards.

---

## 🧩 Integration Tips
- Make sure your views define a `common_date_for_extension` field to enable correct interval logic.
- Always check compatibility between your SQL dialect (GoogleSQL vs Databricks SQL) and the appropriate view (`dynamic_pop` vs `pop_block`).
- These views are designed to be extended, not queried directly.

---

## 📌 Dependencies
- Looker (LookML 4.0+)
- Compatible with models using time-based data and a standard date field (`common_date_for_extension` recommended)
