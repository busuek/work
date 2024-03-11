# Домашнее задание к занятию 2 «Работа с Playbook»

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook).
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

## Решение основной части

1. Подготовил и дописал свой inventory-файл `prod.yml`
```
  GNU nano 7.2                        prod.yml                                  
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: <IP_here>

vector:
  hosts:
    ansible_connection: ssh
    ansible_ssh_user: root
    ansible_host: 192.168.100.226
    ansible_private_key_file: ~/ssh/id_ed25519
```

2 - 4. Дописал playbook, создал новый play, который устанавливает и настраивает vector. Так же, создал [template](), с конфигурацией для деплоя vector. Playbook использует модули `get_url`, `template`, `unarchive`, `file` и `shell`. В Playbook выполняется скачивание, разархивирование в указанную директорию, добавление конфигурации из файла шаблона и запуск Vector.

E5. Запустил `ansible-lint site.yml`, увидел наличие ошибок. У меня в playbook отсутствовали права на скачиваемые и исполняемые файлы, так же, были лишние отступы в коде, использовался устаревший синтаксис, и был исправлен порядок запуска сервиса Clickhouse.

6. Запускаю playbook с флагом `--check`. Флаг `--check` не вносит изменения в конечную систему.
```
TASK [Get clickhous distrib] *****************************************************************************************
changed: [clickhous-01] => (item=clickhouse-client)
changed: [clickhous-01] => (item=clickhouse-server)
faild: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest":}
```
7. Запускаю playbook с флагом --diff. Этот флаг позволяет отслеживать изменения в файлах на удаленных хостах, чтобы можно было видеть, какие конкретные изменения будут внесены на хостах в результате выполнения плейбука.
```
```

8. Повторно запускаю playbook с флагом `--diff`, вижу, что playbook идемпотентен, за исключением запуска Vector:
```
TASK [Template file] *****************************************************************************************
ok: [vector-01]

TASK [Run Vector] ********************************************************************************************
changed: [vector-01]

PLAY RECAP ***************************************************************************************************
clickhous-01                  : ok=3    changed=0    unreachable=0    faild=0    skipped=0    rescued=1    ignored=0
vector-01                     : ok=6    changed=1    unreachable=0    faild=0    skipped=0    rescued=0    ignored=0
```

9.  Ссылка на описание Playbook: https://github.com/busuek/work/blob/main/README.md
