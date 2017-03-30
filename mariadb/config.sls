{% from "mariadb/defaults.yaml" import rawmap with context %}
{%- set mariadb = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb:lookup')) %}
{% set os_family = salt['grains.get']('os_family', None) %}

{% if "config_directory" in mariadb %}
mariadb_config_directory:
  file.directory:
    - name: {{ mariadb.config_directory }}
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 755
    {% endif %}
    - makedirs: True

{% if "server_config" in mariadb %}
mariadb_server_config:
  file.managed:
    - name: {{ mariadb.config_directory + mariadb.server_config.file }}
    - template: jinja
    - source: salt://mariadb/files/server.cnf
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
{% endif %}

{% if "galera_config" in mariadb %}
mariadb_galera_config:
  file.managed:
    - name: {{ mariadb.config_directory + mariadb.galera_config.file }}
    - template: jinja
    - source: salt://mariadb/files/galera.cnf
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
{% endif %}

{% if "library_config" in mariadb %}
mariadb_library_config:
  file.managed:
    - name: {{ mariadb.config_directory + mariadb.library_config.file }}
    - template: jinja
    - source: salt://mariadb/files/client.cnf
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
{% endif %}

{% if "clients_config" in mariadb %}
mariadb_clients_config:
  file.managed:
    - name: {{ mariadb.config_directory + mariadb.clients_config.file }}
    - template: jinja
    - source: salt://mariadb/files/mariadb-clients.cnf
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
{% endif %}

{% endif %}

mariadb_config:
  file.managed:
    - name: {{ mariadb.config.file }}
    - template: jinja
{% if "config_directory" in mariadb %}
    - source: salt://mariadb/files/my-include.cnf
{% else %}
    - source: salt://mariadb/files/my.cnf
{% endif %}
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
