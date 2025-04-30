# Развёртывание микросервиса с использованием Terraform, Vagrant, Ansible и Docker

## Описание

Этот проект направлен на автоматизацию создания ВМ с помощью Vagrant, развертывания микросервиса на виртуальной машине с использованием Ansible. Микросервис представляет собой HTTP-сервер, экспортирующий метрики для Prometheus. Система использует Docker для контейнеризации и настройки окружения для микросервиса. В качестве инструмента для управления инфраструктурой используется Terraform.


## Структура проекта

Проект содержит следующие компоненты:

- `README.md` — документация по проекту.
- `Vagrantfile` — конфигурация виртуальной машины.
- `Dockerfile` — инструкция по сборке образа микросервиса.
- `microservice.py` — код HTTP-сервиса на Flask.
- `terraform/`
  - `main.tf` — Terraform-описание ресурсов.
- `ansible/`
  - `playbook.yml` — основной playbook для настройки и запуска микросервиса.
  - `inventories/hosts` — инвентарь с IP-адресом ВМ.
  - `roles/`
    - `docker/` — установка Docker и сборка образа.
      - `tasks/main.yml`
    - `microservice/` — установка микросервиса на сервер без контейнера.
      - `tasks/main.yml`


## Требования

Перед началом работы установите следующие инструменты:

- Vagrant
- Ansible
- Terraform



## Развёртывание

### 1. Инициализация Terraform

```bash
terraform init
```

### 2. Применение конфигурации

```bash
terraform apply
```

Terraform создаст виртуальную машину через Vagrant и запустит Ansible для настройки и деплоя.



## Переключение способа развёртывания

По умолчанию микросервис развёртывается в Docker-контейнере.  
Можно переключиться на запуск **на сервере без контейнера**, удалив в файле `main.tf` -e container_runtime=server:

Запуск микросервиса на ВМ:
```hcl
command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./ansible/inventories/hosts ./ansible/playbook.yml"
```

Запуск микросервиса через контейнере:
```hcl
command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./ansible/inventories/hosts ./ansible/playbook.yml -e container_runtime=server"
``` 

## Доступ к микросервису

После запуска, микросервис будет доступен по адресу:

```
http://192.168.56.10:8080
```

Если сервис работает — он ответит HTML-страницей, а по пути `/metrics` — экспортирует метрики Prometheus (Полный адрес: http://192.168.56.10:8080/metrics).


