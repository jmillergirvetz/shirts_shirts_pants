connection: "shirts_shirts_pants"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: shirts_and_shirts_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: product_facts_build {
  sql_trigger: SELECT 1 ;;
}

persist_with: shirts_and_shirts_default_datagroup

explore: order_items {

  join: product_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.product_id} = ${product_facts.product_id} ;;
  }
}
