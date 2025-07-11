# app_client

# Nombre de aplicación 

- app_client

# Asignatura

- Electivo Computación móvil

## Descripción

- Aplicación móvil desarrollada en Flutter para Restobar Ruta 5, proyecto de Computación Móvil.

## Integrantes del proyecto

- Aaron Silva Molina
- Jarol Riquelme Santibañez
- Benjamín Díaz González

## Nombre del docente

- Sebastián Salazar Molina

## Requisitos Previos

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) o [Visual Studio Code](https://code.visualstudio.com/)
- Dispositivo o emulador Android
- Cuenta en Google Firebase

## Configuración del Proyecto

1. *Clonar el repositorio:*
    bash
    git clone https://github.com/tu-usuario/app_client.git
    cd app_client
    

2. *Instalar las dependencias:*
    bash
    flutter pub get
    

3. *Configurar Firebase:*
    - Descargar el archivo google-services.json desde la consola de Firebase.
    - Colocar el archivo en las carpetas correspondientes:
      - android/app/

4. *Configurar variables de entorno:*
    - Crea un archivo .env en la raíz del proyecto y agrega las variables necesarias.

## Ejecución en Desarrollo

- *Android:*
  bash
  flutter run

## Despliegue

1. **Generar el APK:**
    bash
    flutter build apk --release
    ```
2. El archivo APK estará en build/app/outputs/flutter-apk/app-release.apk.
