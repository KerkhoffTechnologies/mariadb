include:
  - mariadb.config
  - mariadb.python

{% from "mariadb/defaults.yaml" import rawmap with context %}
{%- set mariadb = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb:lookup')) %}

{% set os = salt['grains.get']('os', None) %}
{% set os_family = salt['grains.get']('os_family', None) %}
{% set mariadb_root_user = salt['pillar.get']('mariadb:server:root_user', 'root') %}
{% set mariadb_root_password = salt['pillar.get']('mariadb:server:root_password', salt['grains.get']('server_id')) %}
{% set mariadb_host = salt['pillar.get']('mariadb:server:host', 'localhost') %}
{% set mariadb_salt_user = salt['pillar.get']('mariadb:salt_user:salt_user_name', mariadb_root_user) %}
{% set mariadb_salt_password = salt['pillar.get']('mariadb:salt_user:salt_user_password', mariadb_root_password) %}
{% set mariadb_datadir = salt['pillar.get']('mariadb:server:mysqld:datadir', '/var/lib/mysql') %}

{% if mariadb_root_password %}

mariadb_debconf_utils:
  pkg.installed:
    - name: {{ mariadb.debconf_utils }}

mariadb_debconf:
  debconf.set:
    - name: {{ mariadb.server }}
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': '{{ mariadb_root_password }}'}
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ mariadb_root_password }}'}
        'mysql-server-5.1/start_on_boot': {'type': 'boolean', 'value': 'true'}
    - require_in:
      - pkg: {{ mariadb.server }}
    - require:
      - pkg: mariadb_debconf_utils

{% endif %}

mysqld-packages:
  pkg.installed:
    - name: {{ mariadb.server }}
{% if os_family == 'Debian' and mariadb_root_password %}
    - require:
      - debconf: mariadb_debconf
{% endif %}
    - require_in:
      - file: mariadb_config

mysqld:
  service.running:
    - name: {{ mariadb.service }}
    - enable: True
    - require:
      - pkg: {{ mariadb.server }}
    - watch:
      - pkg: {{ mariadb.server }}
      - file: mariadb_config
{% if "config_directory" in mariadb and "server_config" in mariadb %}
      - file: mariadb_server_config
{% endif %}

