view: product_facts {
  derived_table: {
    sql: SELECT var_attr_pid AS product_id
              , brand
              , category
              , department
              , retail_price
              , cost
          FROM
            (SELECT p_a_c.product_id AS var_attr_pid
                  , MAX(CASE WHEN attr.name = 'brand' THEN p_a_c.value ELSE NULL END) AS brand
                  , MAX(CASE WHEN attr.name = 'category' THEN p_a_c.value ELSE NULL END) AS category
                  , MAX(CASE WHEN attr.name = 'department' THEN p_a_c.value ELSE NULL END) AS department
            FROM brands.p_a_c AS p_a_c
            LEFT JOIN brands.attribute AS attr
            ON p_a_c.attribute_id = attr.id
            LEFT JOIN brands.p_a_n AS p_a_n
            ON attr.id = p_a_n.attribute_id
            GROUP BY 1) AS var_attr
          INNER JOIN
            (SELECT p_a_n.product_id AS int_attr_pid
                  , MAX(CASE WHEN attr.name = 'retail_price' THEN p_a_n.value ELSE NULL END) AS retail_price
                  , MAX(CASE WHEN attr.name = 'cost' THEN p_a_n.value ELSE NULL END) AS cost
            FROM brands.p_a_n AS p_a_n
            LEFT JOIN brands.attribute AS attr
            ON p_a_n.attribute_id = attr.id
            GROUP BY 1) AS int_attr
          ON var_attr.var_attr_pid = int_attr.int_attr_pid
           ;;
          datagroup_trigger: product_facts_build
          indexes: ["product_id"]
          }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: product_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  set: detail {
    fields: [
      product_id,
      brand,
      category,
      department,
      retail_price,
      cost
    ]
  }
}
