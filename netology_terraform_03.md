### Задание 1

Приложите скриншот входящих правил "Группы безопасности" в ЛК Yandex Cloud.

![image](https://github.com/busuek/work/assets/101875725/e6dd2cff-422d-4553-b152-6a37860ca693)

<details>
<summary>Вывод консоли</summary>

``` sh
admin@virtual: ~/Desktop/projects/devops-netology/assets/terraform-03-control-structures/src$ terraform apply 

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

...

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 1s [id=enpredncv398taslojr7]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_security_group.example: Creating...
yandex_vpc_subnet.develop: Creation complete after 0s [id=e9bfgpik2rb0jlgp3gvp]
yandex_vpc_security_group.example: Creation complete after 1s [id=enpufp91vrv8e2nikfrk]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```   
</details>

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нем создание двух **одинаковых** ВМ  web-1 и web-2(не web-0 и web-1!), с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в 1-м задании группу безопасности.
2. Создайте файл for_each-vm.tf. Опишите в нем создание 2 ВМ с именами "main" и "replica" **разных** по cpu/ram/disk , используя мета-аргумент **for_each loop**. Используйте переменную типа list(object({ vm_name=string, cpu=number, ram=number, disk=number  })). При желании внесите в переменную все возможные параметры.
3. ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.
4. Используйте функцию file в local переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ №2.
5. Инициализируйте проект, выполните код.
