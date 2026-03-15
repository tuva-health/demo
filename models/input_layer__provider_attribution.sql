{{ config(
    schema='input_layer',
    tags=['tuva_demo']
) }}

with raw_provider_attribution as (

    select
          person_id
        , patient_id
        , cast(year_month as {{ dbt.type_string() }}) as year_month
        , payer
        , {{ the_tuva_project.quote_column('plan') }} as plan_name
        , data_source
        , payer_attributed_provider
        , payer_attributed_provider_practice
        , payer_attributed_provider_organization
        , payer_attributed_provider_lob
        , custom_attributed_provider
        , custom_attributed_provider_practice
        , custom_attributed_provider_organization
        , custom_attributed_provider_lob
    from {{ ref('provider_attribution_source') }}

),

eligibility as (

    select
          person_id
        , member_id
        , payer
        , {{ the_tuva_project.quote_column('plan') }} as plan_name
        {% if target.type == 'fabric' %}
        , cast(
            year(enrollment_start_date) * 100
            + month(enrollment_start_date)
            as {{ dbt.type_int() }}
          ) as enrollment_start_year_month
        , cast(
            year(enrollment_end_date) * 100
            + month(enrollment_end_date)
            as {{ dbt.type_int() }}
          ) as enrollment_end_year_month
        {% else %}
        , cast(
            extract(year from enrollment_start_date) * 100
            + extract(month from enrollment_start_date)
            as {{ dbt.type_int() }}
          ) as enrollment_start_year_month
        , cast(
            extract(year from enrollment_end_date) * 100
            + extract(month from enrollment_end_date)
            as {{ dbt.type_int() }}
          ) as enrollment_end_year_month
        {% endif %}
    from {{ ref('eligibility') }}

),

matched_provider_attribution as (

    select
          raw_provider_attribution.person_id
        , raw_provider_attribution.patient_id
        , eligibility.member_id
        , raw_provider_attribution.year_month
        , raw_provider_attribution.payer
        , raw_provider_attribution.plan_name
        , raw_provider_attribution.data_source
        , raw_provider_attribution.payer_attributed_provider
        , raw_provider_attribution.payer_attributed_provider_practice
        , raw_provider_attribution.payer_attributed_provider_organization
        , raw_provider_attribution.payer_attributed_provider_lob
        , raw_provider_attribution.custom_attributed_provider
        , raw_provider_attribution.custom_attributed_provider_practice
        , raw_provider_attribution.custom_attributed_provider_organization
        , raw_provider_attribution.custom_attributed_provider_lob
        , row_number() over (
            partition by
                  raw_provider_attribution.person_id
                , raw_provider_attribution.year_month
                , raw_provider_attribution.payer
                , raw_provider_attribution.plan_name
                , raw_provider_attribution.data_source
            order by eligibility.member_id
          ) as row_num
    from raw_provider_attribution
    left join eligibility
      on raw_provider_attribution.person_id = eligibility.person_id
     and raw_provider_attribution.payer = eligibility.payer
     and raw_provider_attribution.plan_name = eligibility.plan_name
     and cast(raw_provider_attribution.year_month as {{ dbt.type_int() }})
         between eligibility.enrollment_start_year_month
             and eligibility.enrollment_end_year_month

)

select
      person_id
    , patient_id
    , member_id
    , year_month
    , payer
    , plan_name as {{ the_tuva_project.quote_column('plan') }}
    , data_source
    , payer_attributed_provider
    , payer_attributed_provider_practice
    , payer_attributed_provider_organization
    , payer_attributed_provider_lob
    , custom_attributed_provider
    , custom_attributed_provider_practice
    , custom_attributed_provider_organization
    , custom_attributed_provider_lob
from matched_provider_attribution
where row_num = 1
