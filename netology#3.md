Задание 1

- Используя директорию help внутри этого домашнего задания, запустите связку prometheus-grafana.
- Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
- Подключите поднятый вами prometheus, как источник данных.
- Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

![Снимок](https://github.com/busuek/work/assets/101875725/712aabdf-5808-40bb-bc7f-b769a7833536)

```
[user@fedora project_netology]$ git clone https://github.com/netology-code/mnt-homeworks.git
Cloning into 'mnt-homeworks'...
remote: Enumerating objects: 1352, done.
remote: Counting objects: 100% (255/255), done.
remote: Compressing objects: 100% (171/171), done.
remote: Total 1352 (delta 98), reused 199 (delta 64), pack-reused 1097
Receiving objects: 100% (1352/1352), 324.55 KiB | 1.89 MiB/s, done.
Resolving deltas: 100% (532/532), done.

[user@fedora help]$ sudo docker-compose up -d
[sudo] password for vega: 
Creating network "help_monitor-net" with driver "bridge"
Creating volume "help_prometheus_data" with default driver
Creating volume "help_grafana_data" with default driver
Pulling nodeexporter (prom/node-exporter:v1.0.1)...
v1.0.1: Pulling from prom/node-exporter
86fa074c6765: Pull complete
ed1cd1c6cd7a: Pull complete
ff1bb132ce7b: Pull complete
Digest: sha256:cf66a6bbd573fd819ea09c72e21b528e9252d58d01ae13564a29749de1e48e0f
Status: Downloaded newer image for prom/node-exporter:v1.0.1
Pulling prometheus (prom/prometheus:v2.24.1)...
v2.24.1: Pulling from prom/prometheus
ea97eb0eb3ec: Pull complete
ec0e9aba71a6: Pull complete
1baa1560dccd: Pull complete
98aa0434d705: Pull complete
8dd5b14946f6: Pull complete
b3fc80730ff8: Pull complete
578d5328855d: Pull complete
e63d5ff37b28: Pull complete
aa74b1acc48d: Pull complete
d7f9032c18f5: Pull complete
0dec308978d6: Pull complete
618f8864f2c8: Pull complete
Digest: sha256:ea420f6cd98e4e43e264a7a2e6e27e8328f47aa32d937e0c6e8e3b30fdefe6eb
Status: Downloaded newer image for prom/prometheus:v2.24.1
Pulling grafana (grafana/grafana:7.4.0)...
7.4.0: Pulling from grafana/grafana
801bfaa63ef2: Pull complete
eb98ae7893eb: Pull complete
06dfedb30805: Pull complete
b5d5ccd6768e: Pull complete
6bb6cb68d42c: Pull complete
4f4fb700ef54: Pull complete
bdc4c340130b: Pull complete
f1b64e277fed: Pull complete
Digest: sha256:5d54d8c09218f7cf8bd81a1e6904c4fd600f63178d54cbae4445a8155d408c8a
Status: Downloaded newer image for grafana/grafana:7.4.0
Creating nodeexporter ... done
Creating prometheus   ... done
Creating grafana      ... done
```
Задание 2

Изучите самостоятельно ресурсы:

- PromQL tutorial for beginners and humans.
- Understanding Machine CPU usage.
- Introduction to PromQL, the Prometheus query language.

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);
```
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle", instance=~"nodeexporter:9100"}[1m])) * 100)
```

- CPULA 1/5/15; A:
```
(avg by(instance) (node_load1{instance=~"nodeexporter:9100"}) * 100) / count by(instance) (count by(cpu, instance) (node_cpu_seconds_total{instance=~"nodeexporter:9100"}))
```

- B:
```
(avg by(instance) (node_load5{instance=~"nodeexporter:9100"}) * 100) / count by(instance) (count by(cpu, instance) (node_cpu_seconds_total{instance=~"nodeexporter:9100"}))
```

- C:
```
(avg by(instance) (node_load15{instance=~"nodeexporter:9100"}) * 100) / count by(instance) (count by(cpu, instance) (node_cpu_seconds_total{instance=~"nodeexporter:9100"}))
```

- количество свободной оперативной памяти;
```
avg by (instance) (100 * ((avg_over_time(node_memory_MemFree_bytes{instance=~"nodeexporter:9100"}[5m]) + avg_over_time(node_memory_Cached_bytes{instance=~"nodeexporter:9100"}[5m]) + avg_over_time(node_memory_Buffers_bytes{instance=~"nodeexporter:9100"}[5m])) / avg_over_time(node_memory_MemTotal_bytes{instance=~"nodeexporter:9100"}[5m])))
```

- количество места на файловой системе.
```
100 - (node_filesystem_avail_bytes{instance=~"nodeexporter:9100",mountpoint="/"} * 100 / node_filesystem_size_bytes{instance=~"nodeexporter:9100",mountpoint="/"})
```

![10-monitoring-03-grafana-metrics](https://github.com/busuek/work/assets/101875725/9921931a-b6d7-468c-a619-ba0ebd840b33)

Задание 3 

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».

![10-monitoring-03-grafana-alerts](https://github.com/busuek/work/assets/101875725/f17b82c1-0409-4ca3-89fd-8d5fec8b6144)

Задание 4 

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.


