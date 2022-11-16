'Ultrasonic and Time of Flight Testing

CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _ConClkFreq / 1_000

        'Time of Flight Pins
 {       ToF1RST = 8        'GPIO0
        ToF1SCL = 6
        ToF1SDA = 4

        ToF2RST = 22        'GPIO0
        ToF2SCL = 20
        ToF2SDA = 18


        'Ultrasonic Pins
        Ultra1SCL = 11
        Ultra1SDA = 13

        Ultra2SCL = 17  'SCL TRIG
        Ultra2SDA = 19  'SDA ECHO

  }
        '---------------------------------------
        'SENSOR I2C PINS
  ToF1SDA = 14
  ToF1SCL = 13
  ToF1RST = 15

  ToF2SDA = 20
  ToF2SCL = 21
  ToF2RST = 22

  Ultra1SCL = 24  'SCL TRIG
  Ultra1SDA = 26  'SDA ECHO

  Ultra2SCL = 25
  Ultra2SDA = 27

VAR

OBJ
  tof[2]        : "ToF.spin"
  ultra         : "Ultrasonic_v3.spin"
  pst           : "Parallax Serial Terminal"

PUB main | ToF_Range1, ToF_Range2, UltraRange1, UltraRange2

    pst.Start(9600)

    WAITCNT((2*(clkfreq/1000)) + cnt)

   ToF_Init

   ultra.Init(Ultra1SCL, Ultra1SDA, 0)
   ultra.Init(Ultra2SCL, Ultra2SDA, 1)

  repeat
  ''Time of Flight #1
    pst.Chars(pst#NL, 2)
    pst.Str(String("TOF 1 -> Getting range"))
    pst.Chars(pst#NL, 2)
    ToF_Range1 := tof[0].GetSingleRange($29)
    pst.Str(String("TOF 1 - >Single range shot range: "))
    pst.Dec(ToF_Range1)
    WAITCNT((1*(clkfreq)) + cnt)
    pst.Chars(pst#NL, 2)
  ''Time of Flight #2
    pst.Str(String("TOF 2 -> Getting range"))
    ToF_Range2:= tof[1].GetSingleRange($29)
    pst.Chars(pst#NL, 2)
    pst.Str(String("TOF 2 - >Single range shot range: "))
    pst.Dec(ToF_Range2)
    WAITCNT((1*(clkfreq)) + cnt)
    pst.Chars(pst#NL, 2)

  ''Ultrasonic #1
    pst.Str(String("Ultrasonic 1 -> Getting range"))
    UltraRange1:= ultra.readSensor(0)
    pst.Chars(pst#NL, 2)
    pst.Str(String("Ultrasonic 1 - >Single range shot range: "))
    pst.Dec(UltraRange1)
    WAITCNT((1*(clkfreq)) + cnt)
    pst.Chars(pst#NL, 2)
  ''Ultrasonic #2
    pst.Str(String("Ultrasonic 2 -> Getting range"))
    UltraRange2:= ultra.readSensor(1)
    pst.Chars(pst#NL, 2)
    pst.Str(String("Ultrasonic 2 - >Single range shot range: "))
    pst.Dec(UltraRange2)
    WAITCNT((1*(clkfreq)) + cnt)
    pst.Chars(pst#NL, 2)

PRI ToF_Init | i

  tof[0].init(ToF1SCL,ToF1SDA,ToF1RST)
  tof[0].ChipReset(1)
  Pause(1000)
  tof[0].FreshReset($29)
  tof[0].MandatoryLoad($29)
  tof[0].RecommendedLoad($29)
  tof[0].FreshReset($29)

  tof[1].init(ToF2SCL,ToF2SDA,ToF2RST)
  tof[1].ChipReset(1)
  Pause(1000)
  tof[1].FreshReset($29)
  tof[1].MandatoryLoad($29)
  tof[1].RecommendedLoad($29)
  tof[1].FreshReset($29)

PRI Pause(ms) | t

  t:=cnt - 1088
  repeat (ms#>0)
    waitcnt(t += _Ms_001)
  return