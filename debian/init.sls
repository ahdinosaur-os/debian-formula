{% set source = salt['pillar.get']('debian:source', 'http://ftp.debian.org/debian/') %}
{% set dist = salt['pillar.get']('debian:dist', 'stable') %}
{% set comps = salt['pillar.get']('debian:comps', ['main']) %}

debian_deb:
  pkgrepo.managed:
    - file: /etc/apt/sources.list
    - name: deb {{ source }} {{ dist }} {{ ' '.join(comps) }}

debian_deb_src:
  pkgrepo.managed:
    - file: /etc/apt/sources.list
    - name: deb-src {{ source }} {{ dist }} {{ ' '.join(comps) }}

/etc/apt/preferences.d/release:
  file.managed:
    - source: salt://debian/fs/etc/apt/preferences.d/release
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        dist: {{ dist }}

/etc/apt/preferences.d/nonrelease:
  file.managed:
    - source: salt://debian/fs/etc/apt/preferences.d/nonrelease
    - user: root
    - group: root
    - mode: 644
