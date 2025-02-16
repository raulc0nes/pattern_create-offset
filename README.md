d1d7b319c1602da02350cb6e3e75342460a81cc136491d358bafd1e2c243e125  buffer.ps1
e0c1372ee6978ea2777053feea68490b519c4cb33cb5ebc0c423cc4db283deeb  pattern_create-offset.ps1

## Generación de patrones sin repeticiones. Cada secuencia de 4 caracteres es única en todo el archivo de salida.
## Se guarda primero en UTF-8 y luego se convierte a ANSI.
## Compatible con PowerShell 5.1 y fichero salida con notepad.exe.

PS C:\Users\raulc0nes\Downloads> .\buffer.ps1
El primer argumento debe ser un numero mayor que 0.
PS C:\Users\raulc0nes\Downloads> .\buffer.ps1 10
El segundo argumento debe ser una sola letra.
PS C:\Users\raulc0nes\Downloads> .\buffer.ps1 10 A
AAAAAAAAAA
PS C:\Users\raulc0nes\Downloads> .\buffer.ps1 100 A
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
PS C:\Users\raulc0nes\Downloads> .\buffer.ps1 50 A | clip
PS C:\Users\raulc0nes\Downloads> AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
PS C:\Users\raulc0nes\Downloads> .\pattern_create-offset.ps1
Uso: .\pattern_create-offset.ps1 -Mode <c|s> -Length <longitud> [-SearchValue <cadena>]
  c -> Crea el patron de la longitud especificada.
  s -> Busca una cadena de 4 caracteres en el patron.
Ejemplos:
  .\pattern_create-offset.ps1 -Mode c -Length 687492
  .\pattern_create-offset.ps1 -Mode s -SearchValue Aa0B
PS C:\Users\raulc0nes\Downloads> .\pattern_create-offset.ps1 -Mode c -Length 100
Patron generado y guardado en C:\Users\raulc0nes\Downloads\pattern.txt
PS C:\Users\raulc0nes\Downloads> type .\pattern.txt
aA0AaA0BaA0CaA0DaA0EaA0FaA0GaA0HaA0IaA0JaA0KaA0LaA0MaA0NaA1OaA1PaA1QaA1RaA1SaA1TaA1UaA1VaA1WaA1XaA1Y
PS C:\Users\raulc0nes\Downloads> .\pattern_create-offset.ps1 -Mode s -SearchValue aA1Y
La secuencia 'aA1Y' se encuentra en la posicion: 96
PS C:\Users\raulc0nes\Downloads> .\pattern_create-offset.ps1 -Mode s -SearchValue aA0H
La secuencia 'aA0H' se encuentra en la posicion: 28
PS C:\Users\raulc0nes\Downloads> .\pattern_create-offset.ps1 -Mode c -Length 687492
Patron generado y guardado en C:\Users\raulc0nes\Downloads\pattern.txt
PS C:\Users\raulc0nes\Downloads> .\pattern_create-offset.ps1 -Mode s -SearchValue WXYZ
La secuencia 'WXYZ' se encuentra en la posicion: 687488
PS C:\Users\raulc0nes\Downloads> .\pattern_create-offset.ps1 -Mode s -SearchValue B7Cw
La secuencia 'B7Cw' se encuentra en la posicion: 585321
