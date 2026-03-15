{% macro assert_ci_seed_baseline_ready() %}

    {% if not execute %}
        {{ return('') }}
    {% endif %}

    {% set required_relations = [
        {'schema': 'input_layer', 'identifier': 'appointment'},
        {'schema': 'input_layer', 'identifier': 'eligibility'},
        {'schema': 'input_layer', 'identifier': 'immunization'},
        {'schema': 'input_layer', 'identifier': 'lab_result'},
        {'schema': 'input_layer', 'identifier': 'medical_claim'},
        {'schema': 'input_layer', 'identifier': 'observation'},
        {'schema': 'input_layer', 'identifier': 'pharmacy_claim'},
        {'schema': 'input_layer', 'identifier': 'provider_attribution_source'},
        {'schema': 'reference_data', 'identifier': 'calendar'},
        {'schema': 'terminology', 'identifier': 'provider'}
    ] %}

    {% set db_name = target.database if target.database is not none else none %}
    {% set missing = [] %}

    {% for required in required_relations %}
        {% set relation = adapter.get_relation(
            database=db_name,
            schema=required['schema'],
            identifier=required['identifier']
        ) %}
        {% if relation is none %}
            {% do missing.append(required['schema'] ~ '.' ~ required['identifier']) %}
        {% endif %}
    {% endfor %}

    {% if missing | length > 0 %}
        {% do exceptions.raise_compiler_error(
            "CI baseline seed schemas are not ready for run-only mode. Missing required objects: "
            ~ (missing | join(', '))
            ~ ". Run `/ci build` or `/ci build-<warehouse>` on this PR to refresh demo seed baselines."
        ) %}
    {% endif %}

{% endmacro %}
