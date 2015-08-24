{% set release = salt['pillar.get']('debian:release', 'stable') %}

{% for source in salt['pillar.get']('debian:sources', [{}]) %}

{% set type = source.get('type', 'deb') %}
{% set url = source.get('url', 'http://ftp.debian.org/debian') %}
{% set distribution = source.get('distribution', release) %}
{% set components = source.get('components', ['main']) %}

debian_{{ type }}_{{ url }}_{{ distribution }}:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/debian.list
    - name: {{ type}} {{ url }} {{ distribution }} {{ ' '.join(components) }}
    - dist: {{ distribution }}
    - comps: {{ ','.join(components) }}
    - consolidate: True

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
