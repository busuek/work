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

2 - 4. Дописал playbook, создал новый play, который устанавливает и настраивает vector. 
```
- name: Install vector
  hosts: clickhouse
  handlers:
    - name: Start vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm"
        dest: "./vector-{{ vector_version }}.rpm"
        mode: "0644"
      notify: Start vector service
    - name: Install vector packages
      become: true
      ansible.builtin.yum:
        name:
          - vector-{{ vector_version }}.rpm
    - name: Flush handlers to restart vector
      ansible.builtin.meta: flush_handlers
```
Так же, создал [template](), с конфигурацией для деплоя vector. Playbook использует модули `get_url`, `template`, `unarchive`, `file` и `shell`. В Playbook выполняется скачивание, разархивирование в указанную директорию, добавление конфигурации из файла шаблона и запуск Vector.

5. Запустил `ansible-lint site.yml`, увидел наличие ошибок.
```
Исправил ошибки
[vega@fedora ~]$ ansible-lint site.yml 
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```
7. Запускаю playbook с флагом `--check`. Флаг `--check` не вносит изменения в конечную систему.
```
[vega@fedora ~]$ ansible-playbook site.yml -i inventory/prod.yml --check
PLAY [Install Vector] ***********************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [vector-01]
TASK [Get Vector distrib] *******************************************************************************************************************************************************************************************************************
ok: [vector-01]
TASK [Install Vector packages] **************************************************************************************************************************************************************************************************************
fatal: [vector-01]: FAILED! => {"changed": false, "module_stderr": "/bin/sh: sudo: command not found\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 127}
PLAY RECAP **********************************************************************************************************************************************************************************************************************************
vector-01                  : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```
7. Запускаю playbook с флагом --diff. Этот флаг позволяет отслеживать изменения в файлах на удаленных хостах, чтобы можно было видеть, какие конкретные изменения будут внесены на хостах в результате выполнения плейбука.
```
[vega@fedora ~]$ ansible-playbook site.yml -i inventory/prod.yml --diff
PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]
TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}
TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]
TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************************
ok: [clickhouse-01]
TASK [Create database] **********************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]
PLAY [Install vector] ***********************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [vector-01]
TASK [Get vector distrib] *******************************************************************************************************************************************************************************************************************
ok: [vector-01]
TASK [Install vector packages] **************************************************************************************************************************************************************************************************************
ok: [vector-01]
PLAY RECAP **********************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
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
