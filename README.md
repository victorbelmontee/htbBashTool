# 🛡️ HTB Bash Tool

![License](https://img.shields.io/badge/license-MIT-blue.svg)  
![Bash Version](https://img.shields.io/badge/bash-4.0%2B-green.svg)  
![Purpose](https://img.shields.io/badge/purpose-HTB%20Helper-orange.svg)  
![Status](https://img.shields.io/badge/status-active-success.svg)  

Herramienta en Bash para buscar y filtrar máquinas de Hack The Box usando el bundle oficial de datos.

---

## 📋 Tabla de Contenidos

- [🚀 Características Principales](#-características-principales)  
- [📦 Instalación](#-instalación)  
- [💡 Uso](#-uso)  
- [🔍 Opciones de Búsqueda](#-opciones-de-búsqueda)  
- [📚 Documentación Técnica](#-documentación-técnica)  
- [🤝 Contribución](#-contribución)  
- [📄 Licencia](#-licencia)  

---

## 🚀 Características Principales

- **Actualización Automática**: Descarga/actualiza `bundle.js` con datos HTB  
- **Búsqueda por Nombre**: Filtra máquinas por su nombre exacto  
- **Búsqueda por IP**: Obtén máquina asociada a una IP  
- **Filtrado por Dificultad**: Muestra máquinas "Fácil", "Media", "Difícil" o "Insane"  
- **Filtrado por SO**: Lista máquinas Linux o Windows  
- **Enlaces YouTube**: Recupera link de tutorial de cada máquina  

---

## 📦 Instalación

> **Requisitos**  
> - Bash 4.0+  
> - `curl`, `js-beautify`, `md5sum`  
> - Conexión a internet  

```bash
git clone https://github.com/victorbelmontee/htbBashTool.git
cd htbBashTool
chmod +x htbmachines.sh
```

---

## 💡 Uso

```bash
# Mostrar ayuda
./htbmachines.sh -h

# Descargar/actualizar datos
./htbmachines.sh -u

# Buscar máquina por nombre
./htbmachines.sh -m OpenAdmin

# Buscar por IP
./htbmachines.sh -i 10.10.10.10

# Filtrar por dificultad
./htbmachines.sh -d Media

# Filtrar por sistema operativo
./htbmachines.sh -o Linux
```

---

## 🔍 Opciones de Búsqueda

| Opción       | Descripción                                         |
| ------------ | --------------------------------------------------- |
| `-u`         | Descargar o actualizar bundle.js                    |
| `-m <name>`  | Buscar máquina por nombre                           |
| `-i <ip>`    | Buscar máquina por dirección IP                     |
| `-d <level>` | Filtrar por dificultad (Fácil/Media/Difícil/Insane) |
| `-o <OS>`    | Filtrar por SO (Linux/Windows)                      |
| `-y <name>`  | Mostrar enlace YouTube de la máquina                |

---

## 📚 Documentación Técnica

Flujo del script:

1. **Trap SIGINT** para limpiar cursor.
2. **updateFiles()** descarga o compara bundle.js.
3. **searchMachine()/searchIP()** parsean JSON embebido con awk/grep.
4. **Filtros combinados** según flags `-d` y `-o`.

---

## 🤝 Contribución

Como siempre: Fork → Branch → Commit → PR.

---

## 📄 Licencia

MIT. Ver [`LICENSE`](LICENSE) para detalles.
