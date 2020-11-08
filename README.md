# Buryak Pi 2020

ZX Spectrum совместимый микро-компьютер, специально разработанный под корпус от Raspberry Pi 3B.

Отличительными особенностями данного клона являются:

1) Форм-фактор (становится в корпус от Raspberry Pi 3B+)
2) Наличие реального процессора **Z-80** на борту
3) PS/2 клавиатура
4) VGA-выход (49 Гц)
5) Звуковой модуль AYX-32 (на базе STM32, автор - tslabs)
6) Wi-Fi модуль ESP-12 на i/o порту AY
7) DivMMC для загрузки софта (tap, trd, sna) с SD-карты
8) 1 Мб ОЗУ по стандарту Profi (порт #dffd)
9) Turbo режим 3.5/7 МГц ( переключается Scroll Lock с индикацией )
10) Режим PAUSE , вейтит процессор по нажатию Print Screen до повторного нажатия с индикацие миганием "ACT"
11) Kempston Joystick (и альтернативная прошивка с поддержкой Sega геймпада)
12) 8 ромсетов ПЗУ (переключаются по F1-F8)

## Прогресс

На данном этапе запущена нижняя плата в полном объеме:
- vga выход (50Гц)
- ps/2 клавиатура
- divmmc
- kempston joystick
- turbo 7 MHz

Верхняя плата:
- работает AYX-32 звуковой модуль
- альтернативная прошивка Wild Sound II для AYX-32 с поддержкой IOA порта AY 
- Wi-Fi работает на прошивке Wild Sound II

Нужно протестировать:
- прошивку с Sega Joystick

Ожидается:
- прошивка от TSL для STM32 с поддержкой i/o порта AY для работы wi-fi модуля

обнаружился БРАК на плате от Павла https://zx-pk.ru/threads/32074-burya...=1#post1088301

## Хотфиксы ревизии 1

[Хотфиксы - фото-мануал](https://github.com/andykarpov/buryak-pi-2020/blob/master/HOTFIXES-REV1.md).

## Руководство по сборке

[Руководство по сборке](https://github.com/andykarpov/buryak-pi-2020/blob/master/HOWTO.md).

## Фото:

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/buryak_pi.png)

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/buryak_pi_enclosure.png)

