connection: "shirts_shirts_pants"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: shirts_and_shirts_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: shirts_and_shirts_default_datagroup

explore: order_items {

  join: p_a_c {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.product_id} = ${p_a_c.product_id} ;;
  }
}
