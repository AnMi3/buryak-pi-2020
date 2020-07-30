# Хотфиксы ревизии 1:

1) Так как в схеме перепутаны сигналы XTAL1, XTAL2 для активного генератора клавиатурной меги, 
активный генератор ставить только с ниже приведенными фиксами.

2) Вместо активного генератора можно: 

- запаять выводной пассивный кварц на 16 МГц (цилиндр)

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/passive_16mhz_crystal_cylinder.jpg)

- либо отрезать питающую контактную площадку и поставить туда пассивный кварц на 16 МГц в форм-факторе 7050

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/mod_for_7050_passive_crystal.jpg)

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/passive_16mhz_crystal_7050.jpg)

3) Для коректной работы прошивки, сигнал SD_NDETECT нужно подтянуть к питанию, согласно фото:

![image](https://github.com/andykarpov/buryak-pi-2020/raw/master/docs/photos/hotfixes-rev1/sd_ndetect_pullup.jpg)

