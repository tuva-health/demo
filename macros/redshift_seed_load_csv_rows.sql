{% macro redshift__load_csv_rows(model, agate_table) %}
  {% set batch_size = get_batch_size() %}
  {% set cols_sql = get_seed_column_quoted_csv(model, agate_table.column_names) %}
  {% set statements = [] %}
  {% set is_medical_claim_seed = model['name'] == 'medical_claim' %}
  {% set total_rows = agate_table.rows | length %}
  {% set total_batches = ((total_rows / batch_size) | round(0, 'ceil')) | int %}

  {% for chunk in agate_table.rows | batch(batch_size) %}
      {% set bindings = [] %}

      {% for row in chunk %}
          {% do bindings.extend(row) %}
      {% endfor %}

      {% set sql %}
          insert into {{ this.render() }} ({{ cols_sql }}) values
          {% for row in chunk -%}
              ({%- for column in agate_table.column_names -%}
                  {{ get_binding_char() }}
                  {%- if not loop.last -%},{%- endif %}
              {%- endfor -%})
              {%- if not loop.last -%},{%- endif %}
          {%- endfor %}
      {% endset %}

      {% do adapter.add_query(sql, bindings=bindings, abridge_sql_log=True) %}

      {% if is_medical_claim_seed %}
          {# Keep this large seed from running inside one long transaction on Redshift. #}
          {% do adapter.commit() %}

          {% if loop.index % 100 == 0 or loop.last %}
              {{ log("redshift seed progress for medical_claim: batch " ~ loop.index ~ "/" ~ total_batches, info=True) }}
          {% endif %}
      {% endif %}

      {% if loop.first %}
          {% do statements.append(sql) %}
      {% endif %}
  {% endfor %}

  {{ return(statements[0]) }}
{% endmacro %}
