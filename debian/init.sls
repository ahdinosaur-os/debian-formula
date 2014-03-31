{% set source = salt['pillar.get']('debian:source', 'http://ftp.debian.org/debian/') %}
{% set dist = salt['pillar.get']('debian:dist', 'stable') %}
{% set comps = salt['pillar.get']('debian:comps', ['main']) %}

debian_deb:
  pkgrepo.managed:
    - file: /etc/apt/sources.list
    - name: deb {{ source }} {{ dist }} {{ ' '.join(comps)) }}

debian_deb_src:
  pkgrepo.managed:
    - file: /etc/apt/sources.list
    - name: deb-src {{ source }} {{ dist }} {{ ' '.join(comps)) }}