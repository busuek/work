### Задание 1

Приложите скриншот входящих правил "Группы безопасности" в ЛК Yandex Cloud.

![](pic/terraform-03-security-groups.png)  

<details>
<summary>Вывод консоли</summary>

``` sh
PS D:\projects\devops-netology\assets\terraform-03-control-structures\src> terraform apply 

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
