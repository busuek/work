# netology 2 

1 задача 

1) Скорость и уменьшение затрат. IaC позволяет быстрее конфигурировать инфраструктуру и направлен на обеспечение наиболее эффективной и бстрой работы сотрудников. Подобный подход поволяет экономить большой ресурс. 

2) Масштабируемость и стандартизация: IaC предоставляет стабильные среды быстро и на должном уровне. Командам разработчиков не нужно прибегать к ручной настройке - они обеспечивают корректность, описывая с помощью кода требуемое состояние сред. IaC полностью стандартизирует сетап инфраструктуры, что снижает вероятность ошибок или отклонений.

3) Безопасность и документация: Если за провизионирование всех вычислительных, сетевых и служб хранения отвечает код, они каждый раз будут развертываться одинаково. Это означает, что стандарты безопасности можно легко и последовательно применять в разных компаниях. IaC также служит некой формой документации о правильном способе создания инфраструктуры и страховкой. Поскольку код можно версионировать, IaC позволяет документировать, регистрировать и отслеживать каждое изменение конфигурации вашего сервера.

4) Восстановление в аварийных ситуациях: IaC — чрезвычайно эффективный способ отслеживания инфраструктуры и повторного развертывания последнего работоспособного состояния после сбоя или катастрофы любого рода.

Основопологающим принципом IaC подхода является — описание инфраструктуры при помощи кода, переиспользуя практики из разработки ПО. 

2 задача

- Ansible отличается своей простотой. Главное - он не требует установки агентов на управляемых устройствах и использует YAML для написания конфигураций.
- Лично на мой взгляд, я считаю, что наиболее надежным методом является

3 задача

[vega@fedora ~]$ vboxmanage --version
7.0.12r159484

[vega@fedora ~]$ vagrant --version
Vagrant 2.2.19

[vega@fedora ~]$ terraform --version
Terraform v1.6.6-dev

[vega@fedora ~]$ ansible --version
ansible [core 2.14.11]

4 задача



# netology 3

1 задача

Ссылка на docker Hub: https://hub.docker.com/repository/docker/alexbsk/nginx/general

2 задача

«Подходит ли в этом сценарии использование Docker-контейнеров или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты?»

Ответ:
В данной ситуации стоит построить некоторую инфраструктуру, из физических серверов и docker контейнеров. В общем виде пояснение к данному утверждению сводится к 

1. Грамотному распределению ресурсов на те или иные сервисы.
2. Обеспечение безопастности и отказоустойчивости сервисов.

Если говорить подробнее, то для построения наиболее грамотной инфраструктуры, по моему мнению стоит выделить одну физическую машину с достаточно Хорошим ресурсом в железе под монолит на Java, NodeJs веб приложение и мобильные приложения под IOS и Android. Внутри данной виртуальной машины  стоит поднять докер и распределить ресурсы для каждого прложения, так как явно Java будет проблемой в использовании оперативной памяти и CPU а те же мобильные приложения будут использовать не мало оперативки и стоит четко распределить ресурс на них. Так же, стоит идейно отделить это все на отдельный физический сервер, чтобы работа самих приложений не влияла на другие сервисы. Так же, тут стоит вопрос безопастности, который стоит рассматривать со стороны разграничения доступов на все сервисы внутри инфраструктуры.

Так же, стоит отметить, что использование виртуальных машин для подобых сервисов не является логичным по причине того, что сам гипервизор неопраданно будет съедать ресурс, который явно понадобится нам в большом количестве, учитывая особенно то, что у нас монолит на Java.

Не маловажным стоит отметить ОС на железе, стоит выбрать например centOS, OpenSUSE, redhat linux. Будет явно удобнее работать с docker, нежели на каком нибудь KVM из за возмжных проблем с настройкой и работой сети.

Далее, стоит выделить отдельный физический сервер под мониторинг системы, весь стек ELK и Grafana + Prometheus. Так же, соответственно, стоит разнести их по разным docker контейнерам. 

Следующим стоит выделить физический сервер под данные: туда пойдут Mongo DB, шина данных на Apache Kafkа.

Далее, отдельный сервер под gitlab CI/CD, можно так же поставить на сервер простую серверную ОС и поверх поднять gitlab в docker контейнере. Выгоды - удобно управлять, отдеьный ресурс под сервер сборки, обезапасили от падения другие сервисы при появлении проблем тут.

Последним стоит поставить еще один физический сервер, для бэкапа, всегда стоит выделять под это именно физический отдельный сервер, так как крах на любом другом сервере понесет и потерю всех данных на бэкапе, это просто глупо.

3 задача

Листинг комманд по заданию:

[vega@fedora ~]$ sudo docker pull centos # Скачиваем docker образы 
[vega@fedora ~]$ sudo docker pull debian

[vega@fedora ~]$ mkdir data # Создаем директорию по заданию
[vega@fedora ~]$ sudo docker run -it -v "$(pwd)/data":/data:Z centos bash # Создаем и запускаем контейнеры с образами дистрибутивов в фоне. Так же, подключаем
[vega@fedora ~]$ sudo docker run -it -v "$(pwd)/data":/data:Z debian bash # к ним созданную локально директорию data

[root@b9be457bbea8 ~]# cd data               # Подключаемся к первой машине и создаем текстовый файл в директории data
[root@b9be457bbea8 data]# touch file1.txt

[vega@fedora data]$ sudo nano file2.txt      # Подключаемся к хостовой машине и создаем второй текстовый файл в директории data

root@ae4e0bec45fd:/# cd data                 # Подключаемся ко второй машине и смотрим листинг двух файлов
root@ae4e0bec45fd:/data# ls
file1.txt  file2.txt
root@ae4e0bec45fd:/data# cat file1.txt file2.txt
Это первый файл, созданный в певом контейнере.
Это второй файл, созданный на хостовой машине.
root@ae4e0bec45fd:/data# 

# netology 4
