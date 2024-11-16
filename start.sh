#!/bin/sh

# Instalar las dependencias
bundle install

# Configurar la base de datos
./bin/rails db:create
./bin/rails db:migrate

# Llenar de datos iniciales la base de datos
./bin/rails db:seed

# Construir los estilos con TailwindCSS
./bin/rails tailwindcss:build

# Levantar servidor
./bin/rails server

