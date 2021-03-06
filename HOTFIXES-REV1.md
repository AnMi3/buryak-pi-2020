# Хотфиксы ревизии 1:

1) Так как в схеме перепутаны сигналы XTAL1, XTAL2 для активного генератора клавиатурной меги, 
активный генератор ставить только с ниже приведенными фиксами.

2) Вместо активного генератора можно: 

- не запаивать вообще ничего, а для меги использовать прошивку с внутренним генератором на 8 МГц
- запаять выводной пассивный кварц на 16 МГц (цилиндр)
- либо отрезать питающую контактную площадку и поставить туда пассивный кварц на 16 МГц в форм-факторе 7050

- ниже фото фикса для установки активного генератора

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/passive_16mhz_crystal_cylinder.jpg)

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/mod_for_7050_passive_crystal.jpg)

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/passive_16mhz_crystal_7050.jpg)

3) Для коректной работы прошивки, сигнал SD_NDETECT нужно подтянуть к питанию, согласно фото:

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/sd_ndetect_pullup.jpg)

4) Если сильно греется CPLD , нужно переключить CPU и ROM на 3.3в 

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/Fix_for_hot_CPLD.jpg)

4.1) а так же перевести основную SRAM на 3.3в существующей перемычкой

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/SRAM_Power.jpg)

5) если не устраивает присутствие звука во время паузы , прошиваем это https://github.com/andykarpov/buryak-pi-2020/blob/master/firmware/avr_kbd/avr_kbd.ino_atmega8_16000000L_sound_off.hex 

в прошивке изменена индикация , теперь не "0" банк ПЗУ мигает светодиодом "ACT" , а пауза светит "LED_XX" , дальше схема и фото фикса

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/audio_off_fix.png)

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/audio_off_fix.jpg)
