::esto ejecuta el archivo .ps1 con el mismo nombre que el .bat (deben estar en la misma carpeta tambien)
::en modo normal
powershell.exe -ExecutionPolicy Bypass -File ""%~dpn0.ps1""
::como admin (es más lento, usar solo si es necesario)
::powershell.exe -NoProfile -Command "& {Start-Process powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dpn0.ps1""' -Verb RunAs}"
