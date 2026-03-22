{% macro clasificar_calidad_aire(indice_ica) %}
    CASE
        WHEN {{ indice_ica }} <= 50 THEN 'Bueno'
        WHEN {{ indice_ica }} <= 100 THEN 'Moderado'
        ELSE 'Dañino'
    END
{% endmacro %}
