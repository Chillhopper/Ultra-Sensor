{Object_Title_and_Purpose}


CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000
  _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _Ms_001   = _ConClkFreq / 1_000

  ToF_limit = 200
  Ultra_limit = 200

VAR
  ' Motors
  long Cmd, Pulse

  ' Sensors
  long ToF[2], Ultra[2]

  ' Wireless Communication
  long  Comm[16]

OBJ
  Def   : "Definitions.spin"
  pst   : "Parallax Serial Terminal.spin"
  PWM   : "Servo32v9.spin"

  Mot   : "MotorControl.spin"
  Sen   : "SensorControl.spin"
  'Com   : "CommControl.spin"


PUB Main  | i

  pst.Start(9600)

  Mot.Start(_Ms_001, @Cmd, @Pulse)
  Sen.Start(_Ms_001, @Tof, @Ultra)
  'Com.Start(_Ms_001, @Comm)


  Cmd := 1

  repeat
    'Your logic goes here

    Cmd := i
    Pulse := 1000
    Pause (500)

      if (Ultra[0] < Ultra_limit) {(ToF[0] > (ToF_limit + 100)) OR (Ultra[0] < Ultra_limit)}
        Cmd := 2
        i := 2
        Pulse := 1000
        'Pause (1000)
        Cmd := 0

      if (Ultra[1] < Ultra_limit) {(ToF[1] > (ToF_limit + 100)) OR (Ultra[1] < Ultra_limit) }
        Cmd := 1
        i := 1
        Pulse := 1000
        'Pause (1000)
        Cmd := 0

    ''Pause(500)


PRI Pause(ms) | t
  t := cnt - 1088                                               ' sync with system counter
  repeat (ms #> 0)                                              ' delay must be > 0
    waitcnt(t += _MS_001)