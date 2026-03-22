{% macro celsius_a_fahrenheit(celsius_column) %}
    CAST(({{ celsius_column }} * 9.0 / 5.0 + 32.0) AS NUMERIC(10,2))
{% endmacro %}