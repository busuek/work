# Домашнее задание к занятию 9.6 «GitLab»

## Подготовка к выполнению

1. Подготовьте к работе GitLab.
2. Создайте свой новый проект.
3. Создайте новый репозиторий в GitLab, наполните его файлами.
4. Проект должен быть публичным, остальные настройки по желанию.

### Подготовительный этап:
Создал проект
![image](https://github.com/busuek/work/blob/main/1.png)

## Основная часть

Файлы:  
[gitlab-CI](https://github.com/busuek/work/blob/main/playbook/files/gitlab-ci.yml)  
[Dockerfile](https://github.com/busuek/work/blob/main/playbook/files/Dockerfile)

### DevOps

В репозитории содержится код проекта на Python. Проект — RESTful API сервис. Ваша задача — автоматизировать сборку образа с выполнением python-скрипта:

1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated).
2. Python версии не ниже 3.7.
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`.
4. Создана директория `/python_api`.
5. Скрипт из репозитория размещён в /python_api.
6. Точка вызова: запуск скрипта.
7. Если сборка происходит на ветке `master`: должен подняться pod kubernetes на основе образа `python-api`, иначе этот шаг нужно пропустить.

### Product Owner

Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить.
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`.
3. Issue поставить label: feature.

### Developer

Пришёл новый Issue на доработку, вам нужно:

1. Создать отдельную ветку, связанную с этим Issue.
2. Внести изменения по тексту из задания.
3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно.


### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность.
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.

## Итог

В качестве ответа пришлите подробные скриншоты по каждому пункту задания:

- файл gitlab-ci.yml;
- Dockerfile; 
- лог успешного выполнения пайплайна;
- решённый Issue.

### Результаты выполнения основной части DevOps
* Создадим файл `requirements.txt`, в котором пропишем зависимости, подлежащие установке:
```
flask
flask_restful
flask_jsonpify
```
* Создадим `Dockerfile` для сборки образа, содержащий следующие инструкции:
```
FROM centos:7
RUN yum install python3 python3-pip -y
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
WORKDIR /python_api
COPY python-api.py python-api.py
CMD ["python3", "python-api.py"]
```
* Создадим файл `.gitlab-ci.yml` для сборки и развертывания Docker-образа:
![Gitlab_ci](https://github.com/busuek/work/blob/main/2.png)
* Для обеспечения процесса сборки необходима установка и настройка внешенего `runner'a` CI/CD. Выполним его развертывание на базе Yandex cloud:
![Runner](https://github.com/busuek/work/blob/main/3.png)
* После настройки `Runner` CI/CD появился в Gitlab:
![Runner_OK](https://github.com/busuek/work/blob/main/4.png)
* Для обеспечения корректной работы `runner'a` в настройках Gitlab пропишем значения требуемых переменных среды:
![Variables](https://github.com/busuek/work/blob/main/5.png)
* Выполним коммит файлов для репозитория и убедимся в автоматическом запуске CI/CD. Результаты работы CI/CD:
![CICD_OK](https://github.com/busuek/work/blob/main/6.png)
* Убедимся, что в собранный Docker-образ загрузился в Gitlab Container Registry:
![Image](https://github.com/busuek/work/blob/main/7.png)
* На основе собранного образа попробуем поднять pod kubernetes. Хотя тема использования kubernetes рассматривается намного позже в курсе. 
Будем использовать ту же VM в Yandex cloud:
![Kubectl](https://github.com/busuek/work/blob/main/8.png)

### Результаты выполнения основной части Product Owner
* Создан новый объект Issue с именем `Изменить message` с описанием `Текст с { "message": "Already started" } изменить на { "message": "Running"}` и label `feature`:
![Issue](https://github.com/busuek/work/blob/main/9.png)

### Результаты выполнения основной части Developer
* Создадим отдельную ветку с именем `1-message` и `merge request`
* Отредактируем файл python-api.py изменив значение `message`
* Сохраним изменения в ветке `1-message`
* Переходим в Gitlab на вкладку `Merge request`. Отмечаем request `Mark as ready`. Дожидаемся, чтобы pipeline CI/CD отработал:
![Resolve](https://github.com/busuek/work/blob/main/10.png)
* Выполняем merge в корневую ветку. Дожидаемся, чтобы pipeline CI/CD отработал:
![Resolve_OK](https://github.com/busuek/work/blob/main/11.png)

### Результаты выполнения основной части Tester
* Поднимем докер-контейнер с образом и проверим возврат метода на корректность.
![Result](https://github.com/busuek/work/blob/main/12.png)
* Закрываем Issue с комментарием об успешности прохождения:
![Result_OK](https://github.com/busuek/work/blob/main/13.png)
