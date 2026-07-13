# 🚗 Sistema de Gestión para Taller Mecánico

Aplicación desarrollada con **Django REST Framework** como Backend y **Flutter** como Frontend para la gestión de un taller mecánico.

El sistema permite administrar clientes, vehículos, servicios, mecánicos, órdenes de reparación y citas, además de implementar autenticación mediante JWT y control de acceso para usuarios autenticados.

---

# Tecnologías utilizadas

## Backend

- Python 3.13
- Django
- Django REST Framework
- PostgreSQL
- Simple JWT
- django-filter

## Frontend

- Flutter
- Provider
- Dio
- Flutter Secure Storage

---

# Requisitos

Antes de ejecutar el proyecto es necesario tener instalado:

- Python 3.13 o superior
- PostgreSQL
- Git
- Flutter SDK
- Android Studio o Visual Studio Code
- Un emulador Android o un dispositivo físico

---

# Instalación

## 1. Clonar el repositorio

```bash
git clone https://github.com/Roman2018122/Flutter-Taller.git

Ingresar al proyecto

```bash
cd torres_taller_api
```

---

## 2. Crear entorno virtual

Windows

```bash
python -m venv venv
```

Activar

```bash
venv\Scripts\activate
```

Linux

```bash
python3 -m venv venv
source venv/bin/activate
```

---

## 3. Instalar dependencias

```bash
pip install -r requirements.txt
```

---

## 4. Crear la base de datos PostgreSQL

Ejemplo

```
Base de datos:
taller_db

Usuario:
postgres

Contraseña:
********
```

---

## 5. Configurar variables de entorno

Crear un archivo

```
.env
```

Ejemplo

```env
SECRET_KEY=TU_SECRET_KEY

DEBUG=True

DB_NAME=taller_db
DB_USER=postgres
DB_PASSWORD=tu_password
DB_HOST=localhost
DB_PORT=5432
```

---

## 6. Ejecutar migraciones

```bash
python manage.py makemigrations
```

```bash
python manage.py migrate
```

---

## 7. Crear superusuario

```bash
python manage.py createsuperuser
```

---

## 8. Ejecutar el servidor

```bash
python manage.py runserver 0.0.0.0:8000
```

---

# Configuración

El proyecto utiliza autenticación JWT mediante Simple JWT.

Toda petición protegida debe incluir:

```
Authorization

Bearer <ACCESS_TOKEN>
```

---

# Obtención del Token

POST

```
/api/token/
```

Body

```json
{
    "username":"taller_user",
    "password":"taller123"
}
```

Respuesta

```json
{
    "refresh":"...",
    "access":"..."
}
```

Actualizar token

```
POST

/api/token/refresh/
```

---

# URL de la API

Servidor local

```
http://127.0.0.1:8000/
```

Endpoints principales

```
POST    /api/token/
POST    /api/token/refresh/

GET     /api/clientes/
POST    /api/clientes/

GET     /api/vehiculos/
POST    /api/vehiculos/

GET     /api/modelos-vehiculo/
POST    /api/modelos-vehiculo/

GET     /api/marcas/

GET     /api/servicios/

GET     /api/especialidades/

GET     /api/mecanicos/

GET     /api/citas/

GET     /api/ordenes-reparacion/

GET     /api/detalles-servicio/
```

---

# Modelos implementados

- Cliente
- Marca
- ModeloVehiculo
- Vehiculo
- Servicio
- Especialidades
- Mecanico
- CitaWeb
- OrdenReparacion
- DetalleServicio

---

# Funcionalidades implementadas

## Administración

✔ Login JWT

✔ CRUD Clientes

✔ CRUD Vehículos

✔ CRUD Marcas

✔ CRUD Modelos de Vehículos

✔ CRUD Servicios

✔ CRUD Especialidades

✔ CRUD Mecánicos

✔ CRUD Órdenes de Reparación

✔ CRUD Detalle de Servicios

✔ Gestión de Citas

---

## Cliente

- Registro
- Inicio de sesión
- Gestión de vehículos
- Solicitud de citas
- Consulta del historial de reparaciones

---

# Arquitectura

Backend

```
Django
│
├── Models
├── Serializers
├── ViewSets
├── URLs
└── JWT
```

Frontend

```
Flutter

Data
Domain
Presentation
Core
Theme
```

Arquitectura basada en Repository Pattern y Provider.

---


# Autor

Jonathan Torres

Proyecto desarrollado para la asignatura de Desarrollo de Aplicaciones Móviles utilizando Flutter y Django REST Framework.

2026