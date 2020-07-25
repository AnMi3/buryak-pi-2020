# Порядок сборки

1) Монтаж:
- Запаиваются все большие тараканы (CPLD, процессор, ОЗУ, МК и мелкая логика). **ПЗУ не запаиваем**.
- Потом припаиваем все остальные пассивные компоненты
- Затем запаиваются разъемы
- Припойные перемычки не устанавливаются

2) Прошивается МК Atmega8
- Прошивка (hex-файл) выбирается в зависимости от типа тактирования (8МГц внутренних или 16 МГц от внешнего кварца или генератора)
- Фьюзы для 8МГц: Low 84h, High: D9h
- Фьюзы для 16МГц: Low 8Eh, High: D9h

3) Устанавливается припойная перемычка **CPLD Power**

4) Устанавливается припойная перемычка **5/3 SRAM Power** в зависимости от установленной микросхемы ОЗУ
- Для 3.3В - в положение **"3"**
- Для 5В - в положение **"5"**

5) Прошивка CPLD EPM7512
- Прошивается файлом **firmware_top.pof** с помощью Quartus Programmer

6) Тестовое включение:
- После подключения монитора, клавиатуры и подачи питания на плату через MicroUSB разъем, на экране монитора должен наблюдаться **"матрас"** (вертикальные полосы). Что говорит о том, что плата запущена, просто ПЗУ мы еще не запаивали.
- Отключаем питание и остальные коннекторы

7) Программирование и монтаж ПЗУ
- В комплекте с платами есть переходник **TSOP-32 в DIP-32**
- Запаиваем микросхему ПЗУ на этот переходник и зашиваем в программаторе прошивкой из **firmware/roms/buryak_pi_29c040.bin**
- Передуваем микросхему на плату Буряка

8) Подготовка MicroSD карты
- Карта должна быть отформатирована в **FAT32** (никаких EXFAT, NTFS и прочей экзотики)
- Записываем на карту релиз **ESXDOS 0.8.7** (папки BIN, SYS, TMP из дистрибутива с сайта https://esxdos.org)
- Записываем на карту нужно количество игр, демо и программ в форматах tap, trd, sna, z80.

9) Боевое включение
- После подачи питания, плата должна инициализировать ESXDOS (черный экран с заставкой ESXDOS) и перейти в режим BASIC-48.
- По кнопке **NMI** (F11) должен открыться NMI browser для выбора файла, что грузить
- Profit

10) Сборка платы расширения 
- Запаиваем все компоненты
- Прошиваем STM32 согласно инструкции на странице разработчика: https://forum.tslabs.info/viewtopic.php?f=6&t=687