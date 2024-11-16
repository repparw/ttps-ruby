# README

## Decisiones de Diseño

* Otras gemas interesantes utilizadas:
  * tailwindcss-rails (para styling)
  * devise ~> 4.9 (autentificación)
  * pundit (autorización)
  * faker (generar datos random en el seed)
  * rails-live-reload (live reload para development)
  * kaminari ~> 1.2 (paginación)
  * ransack ~> 4.2 (busqueda)

## Requisitos Técnicos

* Ruby version: 3.2.5
* Rails version: ~> 8.0.0
* Base de datos: sqlite3 >= 2.1

## Pasos para Ejecutar la Aplicación

0. Instalar [Ruby](https://www.ruby-lang.org/es/downloads/)

1. Ejecutar script
    ```sh
        ./start.sh
    ```

ó

1. Instalar las dependencias:
    ```sh
        bundle install
    ```

2. Configurar la base de datos:
    ```sh
        ./bin/rails db:create
        ./bin/rails db:migrate
    ```

3. Llenar de datos iniciales la base de datos:
    ```sh
        ./bin/rails db:seed
    ```

4. Construir los estilos de Tailwind CSS:
    ```sh
        ./bin/rails tailwindcss:build
    ```

5. Levantar servidor:
    ```sh
        ./bin/rails server
    ```
