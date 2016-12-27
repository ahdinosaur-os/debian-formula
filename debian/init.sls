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

{% endfor %}

{% for pin in salt['pillar.get']('debian:pins', [{}]) %}

{% set name = pin.get('name') %}
{% set value = pin.get('value') %}
{% set priority = pin.get('priority') %}

/etc/apt/preferences.d/{{ name }}
  file.managed:
    - source: salt://debian/fs/etc/apt/preferences.d/pin
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        pin: {{ value }}
        priority: {{ priority }}

{% endfor %}

/etc/apt/apt.conf.d/10defaultrelease:
  file.managed:
    - source: salt://debian/fs/etc/apt/apt.conf.d/10defaultrelease
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        dist: {{ release }}
