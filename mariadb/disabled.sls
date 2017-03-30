{% from "mariadb/defaults.yaml" import rawmap with context %}
{%- set mariadb = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb:server:lookup')) %}

mariadb:
  service.dead:
      - name: {{ mariadb.service }}
      - enable: False
