# README

## Decisiones de Diseño

Documentar aquí cualquier decisión de diseño importante que se haya tomado.

## Requisitos Técnicos

* Ruby version: 3.0.0
* Rails version: ~> 8.0.0
* Base de datos: sqlite3 >= 2.1
* Servidor web: Puma >= 5.0
* Otras gemas interesantes:
  * tailwindcss-rails (para styling)
  * devise ~> 4.9 (autentificación)
  * pundit (autorización)
  * faker (generar datos random en el seed)
  * rails_live_reload (live reload para development)
  * kaminari ~> 1.2 (paginación)
  * ransack ~> 4.2 (busqueda)

## Pasos para Ejecutar la Aplicación

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
        ./bin/rails db:seeds
    ```
4. Levantar servidor:
    ```sh
        ./bin/rails server
    ```
