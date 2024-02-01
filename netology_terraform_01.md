Задание 1

1. Перейдите в каталог src. Скачайте все необходимые зависимости, использованные в проекте.

Решение:

```
admin@virtual:~$ terraform --version 
Terraform v1.5.5
on linux_amd64

admin@virtual:~/netology/ter-homeworks/01/src$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding kreuzwerker/docker versions matching "~> 3.0.1"...
- Finding latest version of hashicorp/random...
- Installing hashicorp/random v3.6.0...
- Installed hashicorp/random v3.6.0 (unauthenticated)
- Installing kreuzwerker/docker v3.0.2...
- Installed kreuzwerker/docker v3.0.2 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│ 
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following providers:
│   - hashicorp/random
│   - kreuzwerker/docker
│ 
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another platform will fail to install these providers.
│ 
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
admin@virtual:~/netology/ter-homeworks/01/src$ 
```

2. Изучите файл .gitignore. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?

Решение:

```
# own secret vars store.
personal.auto.tfvars
```

3. Выполните код проекта. Найдите в state-файле секретное содержимое созданного ресурса random_password, пришлите в качестве ответа конкретный ключ и его значение.

Решение:

```
"result": "Lt8k2UlNUCKm86kk"
```

4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла main.tf. Выполните команду `terraform validate`. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.

```
admin@virtual:~/netology/ter-homeworks/01/src$ terraform validate
╷
│ Error: Missing name for resource
│ 
│   on main.tf line 24, in resource "docker_image":
│   24: resource "docker_image" {
│ 
│ All resource blocks must have 2 labels (type, name).
╵
╷
│ Error: Invalid resource name
│ 
│   on main.tf line 29, in resource "docker_container" "1nginx":
│   29: resource "docker_container" "1nginx" {
│ 
│ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
```

Ошибки:

- При объявлении ресурса docker_image пропущен параметр `name`
- Ошибка при обращении к ресурсу `random_password.random_string_fake.resuld`
- Невалидное имя контейнера `1nginx`, т.к. начинается с числа

5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды `docker ps`.

```
admin@virtual:~/netology/ter-homeworks/01/src$ terraform apply   
random_password.random_string: Refreshing state... [id=none]
...
docker_image.nginx: Creating...
docker_image.nginx: Still creating... [10s elapsed]
docker_image.nginx: Still creating... [20s elapsed]
docker_image.nginx: Still creating... [30s elapsed]
docker_image.nginx: Creation complete after 35s [id=sha256:f9c14fe76d502861ba0939bc3189e642c02e257f06f4c0214b1f8ca329326cdanginx:latest]
docker_container.nginx: Creating...
docker_container.nginx: Creation complete after 3s [id=e708e7761e6523c9f28885779cd88a5a96013d83cbf9be54a6a5ea1ba68cb1bf]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

```
admin@virtual:~/netology/ter-homeworks/01/src$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS              PORTS                  NAMES
e708e7761e65   f9c14fe76d50   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8000->80/tcp   example_Lt8k2UlNUCKm86kk
```

6. Замените имя docker-контейнера в блоке кода на `hello_world`, выполните команду `terraform apply -auto-approve`. Объясните своими словами, в чем может быть опасность применения ключа `-auto-approve`? В качестве ответа дополнительно приложите вывод команды `docker ps`.

```
admin@virtual:~/netology/ter-homeworks/01/src$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
f06026f825dd   f9c14fe76d50   "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   0.0.0.0:8000->80/tcp   hello_world
```
-auto-approve: Пропускает интерактивное одобрение плана развертывания.

7. Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.

```
{
  "version": 4,
  "terraform_version": "1.4.6",
  "serial": 11,
  "lineage": "191fa340-83b0-0273-4092-27b00d35a76c",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

8. Объясните, почему при этом не был удален docker образ nginx:latest ? Ответ подкрепите выдержкой из документации провайдера.
В main.tf присутвует параметр keep_locally = true Согласно документации провайдера, если стои true то он не будет удален.

```
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.
```
