{% from "mariadb/defaults.yaml" import rawmap with context %}
{%- set mariadb = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb:lookup')) %}

{% set mariadb_root_user = salt['pillar.get']('mariadb:server:root_user', 'root') %}
{% set mariadb_root_pass = salt['pillar.get']('mariadb:server:root_password', salt['grains.get']('server_id')) %}
{% set mariadb_host = salt['pillar.get']('mariadb:server:host', 'localhost') %}
{% set db_states = [] %}

{% set mariadb_salt_user = salt['pillar.get']('mariadb:salt_user:salt_user_name', mariadb_root_user) %}
{% set mariadb_salt_pass = salt['pillar.get']('mariadb:salt_user:salt_user_password', mariadb_root_pass) %}

include:
  - mariadb.python

{% for database in salt['pillar.get']('mariadb:database', []) %}
{% set state_id = 'mariadb_db_' ~ loop.index0 %}
{{ state_id }}:
  mysql_database.present:
    - name: {{ database }}
    - connection_host: '{{ mariadb_host }}'
    - connection_user: '{{ mariadb_salt_user }}'
    {% if mariadb_salt_pass %}
    - connection_pass: '{{ mariadb_salt_pass }}'
    {% endif %}
    - connection_charset: utf8

{% if salt['pillar.get'](['mariadb', 'schema', database, 'load']|join(':'), False) %}
{{ state_id }}_schema:
  file.managed:
    - name: /etc/mysql/{{ database }}.schema
    - source: {{ salt['pillar.get'](['mariadb', 'schema', database, 'source']|join(':')) }}
{%- set template_type = salt['pillar.get'](['mariadb', 'schema', database, 'template']|join(':'), False) %}
{%- set template_context = salt['pillar.get'](['mariadb', 'schema', database, 'context']|join(':'), {}) %}
{%- if template_type %}
    - template: {{ template_type }}
    - context: {{ template_context|yaml }}
{% endif %}
    - user: {{ salt['pillar.get']('mariadb:server:user', 'mysql') }}
    - makedirs: True

{{ state_id }}_load:
  cmd.wait:
    - name: mysql -u {{ mariadb_salt_user }} -h{{ mariadb_host }} -p{{ mariadb_salt_pass }} {{ database }} < /etc/mysql/{{ database }}.schema
    - watch:
      - file: {{ state_id }}_schema
      - mysql_database: {{ state_id }}
{% endif %}

{% do db_states.append(state_id) %}
{% endfor %}
