version: '2'

services:
  elkarbackup:
    image: elkarbackup/elkarbackup:1.3.1-apache
    environment:
      SYMFONY__DATABASE__PASSWORD: ${mysql_root_password}
    {{- if eq .Values.cron_enabled "true" }}
      EB_CRON: "enabled"
    {{- end }}
      TZ: ${timezone}
    volumes:
    - backups:/app/backups
    - uploads:/app/uploads
    - sshkeys:/app/.ssh
    {{- if eq .Values.http_enabled "true" }}
    ports:
      - ${http_port}:80/tcp
    {{- else}}
    expose:
      - 80/tcp
    {{- end }}
    
  db:
    image: mysql:5.7.22
    environment:
      MYSQL_ROOT_PASSWORD: ${mysql_root_password}
    volumes:
    - db:/var/lib/mysql

volumes:
  db:
    driver: ${volume_driver}
  backups:
    driver: ${volume_driver}
  uploads:
    driver: ${volume_driver}
  sshkeys:
    driver: ${volume_driver}
