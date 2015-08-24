{% set release = salt['pillar.get']('debian:release') %}

{% set defaultSource = { source: 'http://ftp.debian.org/debian/', dist: release, comps: ['main'] } %}
{% for source in salt['pillar.get']('debian:sources', [defaultSource]) %}

{% set src = source.get('source') %}
{% set dist = source.get('dist') %}
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
