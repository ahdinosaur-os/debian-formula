{% set release = salt['pillar.get']('debian:release') %}

{% set defaultSource = {} %}
{% for source in salt['pillar.get']('debian:sources', [defaultSource]) %}

{% set src = source.get('src', 'http://ftp.debian.org/debian') %}
{% set dist = source.get('dist', release) %}
{% set comps = source.get('comps', ['main']) %}

debian_deb:
  pkgrepo.managed:
    - file: /etc/apt/sources.list
    - name: deb {{ src }} {{ dist }} {{ ' '.join(comps) }}

debian_deb_src:
  pkgrepo.managed:
    - file: /etc/apt/sources.list
    - name: deb-src {{ src }} {{ dist }} {{ ' '.join(comps) }}

{% endfor %}

/etc/apt/preferences.d/release:
  file.managed:
    - source: salt://debian/fs/etc/apt/preferences.d/release
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        dist: {{ release }}

/etc/apt/preferences.d/nonrelease:
  file.managed:
    - source: salt://debian/fs/etc/apt/preferences.d/nonrelease
    - user: root
    - group: root
    - mode: 644
