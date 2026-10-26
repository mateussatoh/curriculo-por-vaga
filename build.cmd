@echo off
rem Atalho para o build.ps1 sem precisar liberar scripts no PowerShell.
rem Uso: build.cmd vagas\empresa-cargo\cv.br.tex
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" %*
