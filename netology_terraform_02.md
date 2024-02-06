Задание 1

Решение: 

1. Проект изучен. Файл variables.tf нужен для того, чтобы определить типы переменных и при необходимости, установить их значения по умолчанию.
2. Создал сервисный аккаунт и ключ. service_account_key_file.
3. Создал короткий ssh ключ используя ssh-keygen -t ed25519, записал его pub часть в переменную vms_ssh_root_key.
4. Инициализировал проект, выполнил код. Нашел ошибки в блоке resource "yandex_compute_instance" "platform" {.
   Ошибки:
   - В строке platform_id = "standart-v4" должно быть слово standard
   - Версия v4 неправильная. Согласно документации Yandex.Cloud (https://cloud.yandex.ru/docs/compute/concepts/vm-platforms)         
     платформы могут быть только v1, v2 и v3.
   - В строке cores = 1 указано неправильное количество ядер процессора. Согласно документации Yandex.Cloud 
     (https://cloud.yandex.ru/docs/compute/concepts/performance-levels) минимальное количество виртуальных ядер процессора для всех 
     платформ равно двум.
   После исправления ошибок удалось запустить код и создать виртуальную машину.

Исправленный блок ресурса выглядит следующим образом:

![Screenshot from 2024-02-05 15-24-54](https://github.com/busuek/work/assets/101875725/c7efbfe4-4994-4edb-95c9-3a2c2b2b89b7)

5. Подключился к консоли вм. Вм успешно создана.

![image](https://github.com/busuek/work/assets/101875725/dacb3305-386d-4a7b-bb11-e6af2d6d8582)

![img_3](https://github.com/busuek/work/assets/101875725/f0a3acfe-d670-446f-8172-591ee8e86435)

Подключение по протоколу ssh:

![image](https://github.com/busuek/work/assets/101875725/0a7add02-7914-405f-a1c9-474d16c3d7b5)

6. Ответы на вопросы:

Параметр preemptible = true применяется в том случае, если нужно сделать виртуальную машину прерываемой, то есть возможность остановки ВМ в любой момент. Применятся если с момента запуска машины прошло 24 часа либо возникает нехватка ресурсов для запуска ВМ. Прерываемые ВМ не обеспечивают отказоустойчивость.

Параметр core_fraction=5 указывает базовую производительность ядра в процентах. Указывается для экономии ресурсов.

Задание 2

Заменил хардкод-значения для ресурсов yandex_compute_image и yandex_compute_instance с добавлением префикса vm_web_

![image](https://github.com/busuek/work/assets/101875725/13768136-d384-4616-a1c9-def0dd7c6cfb)

Объявил переменные в файле variables.tf:

![image](https://github.com/busuek/work/assets/101875725/0fcbf86a-0909-4003-bc20-deb76e827717)

Выполнил terraform plan, появилось сообщение о том, что terraform не нашел отличий от действующей инфраструктуры:

![image](https://github.com/busuek/work/assets/101875725/c99346a4-7906-47d7-b98b-8c776b5e265c)

Задание 3

Создал в корне проекта файл 'vms_platform.tf'. Перенес в него все переменные первой ВМ:

![image](https://github.com/busuek/work/assets/101875725/e16f192c-56d5-4783-abb1-94524937838a)

В блоке ресурса создал вторую ВМ с указанными параметрами и объявил её переменные с префиксом vm_db_ в файле vms_platform.tf:

![image](https://github.com/busuek/work/assets/101875725/521b621c-8171-439d-966f-e9f8b25cd9af)

![image](https://github.com/busuek/work/assets/101875725/b9d36683-49cb-4d44-8ac7-57e2ade95c67)

Применяю конфигурацию, вносится изменение в текущую инфраструктуру, создается еще одна виртуальная машина:

![image](https://github.com/busuek/work/assets/101875725/0c37967e-5b23-43f4-8601-2c770e265474)

![img_12_new](https://github.com/busuek/work/assets/101875725/d340427b-ce29-4aec-abce-9f5b39cfd3a3)

Задание 4

Объявил в outputs.tf output типа map, получился следующий output:

![image](https://github.com/busuek/work/assets/101875725/cccd8cd0-bfa0-4859-8edc-fca496a37ee2)

Применил изменения, terraform output показал следующее:

![image](https://github.com/busuek/work/assets/101875725/c073faf0-734c-4256-b28e-385ee9192476)

Задание 5 

В файле locals.tf применил интерполяцию, в одном блоке описал имена ВМ:

![image](https://github.com/busuek/work/assets/101875725/b05b323a-1c80-4a35-a9fe-dbfc9d9f1e89)

Закомментировал старые variables с именами, в main сослался на созданный local:

![image](https://github.com/busuek/work/assets/101875725/76fb30f1-6796-4e78-910b-01dca95a12ee)

![image](https://github.com/busuek/work/assets/101875725/58162810-1fca-4c9f-baac-0b34f2c5b557)

Применил изменения.

Задание 6 

Описываю переменные ".._cores",".._memory",".._core_fraction" в vms_platform.tf:

![image](https://github.com/busuek/work/assets/101875725/5b4b5015-9d4e-4095-bf10-ab70237f5ba3)

В main.tf в блоке resources применяю описанные выше переменные:

![image](https://github.com/busuek/work/assets/101875725/2cc510c2-ad39-42ed-9bf4-3fdb0335e6c7)

![image](https://github.com/busuek/work/assets/101875725/29108575-36dd-49d7-ba69-809fc162e0f8)

Для блока metadata описываю переменные:

![image](https://github.com/busuek/work/assets/101875725/bc2aebd2-a2a1-4a13-84ca-ec7a520c9243)

В main.tf в блоке resources применяю описанные выше переменные:

![image](https://github.com/busuek/work/assets/101875725/c5612966-e650-42a9-8108-5817a6a229eb)

Нашел и удалил неиспользуемые переменные.

Команда `terraform plan` изменение не выявила:

![image](https://github.com/busuek/work/assets/101875725/2bb39eab-b993-43cf-b1ca-c928300a7a84)

