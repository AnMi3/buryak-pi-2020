# Buryak Pi 2020

ZX Spectrum совместимый микро-компьютер, специально разработанный под корпус от Raspberry Pi 3B.

Отличительными особенностями данного клона являются:

1) Форм-фактор
2) Наличие реального процессора **Z-80** на борту
3) PS/2 клавиатура
4) VGA-выход
5) Звуковой модуль AYX-32 (на базе STM32, автор - tslabs)
6) Wi-Fi модуль ESP-12 на i/o порту AY
7) DivMMC для загрузки софта (tap, trd, sna) с SD-карты
8) 1 Мб ОЗУ по стандарту Profi (порт #dffd)

## Прогресс

На данном этапе запущена нижняя плата в полном объеме:
- vga выход (50Гц)
- ps/2 клавиатура
- divmmc

Верхняя плата:
- работает AYX-32 звуковой модуль

Ожидается:
- прошивка для STM32 с поддержкой i/o порта AY для работы wi-fi модуля
- прошивка клавиатурной AVR с поддержкой Sega-джойстика


## Фото:

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/buryak_pi.png)

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/buryak_pi_enclosure.png)

