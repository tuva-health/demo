{% macro redshift__get_batch_size() %}
  {# Let redshift seed batching be controlled via per-seed config when provided. #}
  {% if model is defined %}
    {% set configured_batch_size = model['config'].get('batch_size') %}
    {% if configured_batch_size is not none %}
      {{ return(configured_batch_size | int) }}
    {% endif %}
  {% endif %}

  {{ return(500) }}
{% endmacro %}
