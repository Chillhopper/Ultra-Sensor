{{

  Developer: Kenichi Kato
  Copyright (c) 2021, Singapore Institute of Technology
  Platform: Parallax USB Project Board (P1)
  Date: 30 Aug 2021
  Modified 2022-10-20 by Sum Yee Loon for RSE1101 AY2022


}}


CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000
  _ConClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
  _Ms_001   = _ConClkFreq / 1_000

  '' [ Definitions ]

  '' Hardware
  ' RoboClaw 1
  S1 = 8
  S2 = 2
  S3 = 3
  S4 = 4

  ' Motor Offset
  S1Offset = 0
  S2Offset = 0
  S3Offset = 0
  S4Offset = 0

  MotorZero = 1500              'Refer to RoboClaw datasheet

VAR
  long mainHubMS, cog, cogStack[64]



OBJ

  PWM   : "Servo32v9.spin"
  DBG   : "FullDuplexSerialExt.spin"


PUB Start(MS, Cmd, Pulse)                                   'Start a new core       'comments
  mainHubMS := MS
  Stop
  cog := cognew(motorCore(Cmd, Pulse), @cogStack) + 1
  return cog


PUB Stop                                                                         'comments
{{ Stop & Release Core }}
  if cog
    cogstop(cog~ - 1)
  return
PUB motorCore(Cmd, Pulse) | i, j, k                                      'Main will be replaced with "motorCore" when make into an object that will
                                                        'keep looping and checking for cmd.

  DBG.Start(31, 30, 0, 115200)
  Pause(1000)

  PWM.Start
  StopAllMotor

'Forward(1000)
'Forward(1000)
'Forward(1000)
'StopAllMotor
'Backward(1000)

StopAllMotor

repeat
    case long[Cmd]

      0: StopAllMotor

      1: Forward (long[Pulse])

      2: Backward (long[Pulse])


'StopAllMotor

PRI StopALLMotor
  PWM.Set(S1, MotorZero+S1Offset)
  PWM.Set(S2, MotorZero+S2Offset)
  PWM.Set(S3, MotorZero+S3Offset)
  PWM.Set(S4, MotorZero+S4Offset)
  Pause(1000)

     return
PRI Pause(ms) | t
  t := cnt - 1088                                               ' sync with system counter
  repeat (ms #> 0)                                              ' delay must be > 0
    waitcnt(t += _MS_001)
  return


PRI Forward(Pulse) | i
i:=1700
    PWM.Set(S1, i+S1Offset)
    PWM.Set(S2, i+S2Offset)
    PWM.Set(S3, i+S3Offset)
    PWM.Set(S4, i+S4Offset)
    Pause(200)

Pause(Pulse)
'return }

{PRI Forward(Pulse) | i
  repeat i from 1500 to 1660 step 20
    PWM.Set(S1, i+S1Offset)
    PWM.Set(S2, i+S1Offset)
    PWM.Set(S3, i+S1Offset)
    PWM.Set(S4, i+S1Offset)
    Pause(200)
  Pause(Pulse/2)

  repeat i from 1720 to 1500 step 20
    PWM.Set(S1, i+S1Offset)
    PWM.Set(S2, i+S1Offset)
    PWM.Set(S3, i+S1Offset)
    PWM.Set(S4, i+S1Offset)
    Pause(200)
  Pause(Pulse/2)
 }
  return


PRI Backward(Pulse) |i
'Enter your code here to move backward
i:=1400
    PWM.Set(S1, i+S1Offset)
    PWM.Set(S2, i+S2Offset)
    PWM.Set(S3, i+S3Offset)
    PWM.Set(S4, i+S4Offset)
    Pause(200)

Pause(Pulse)
{
PRI Backward(Pulse) | i

  repeat i from 1500 to 1200 step 20
    PWM.Set(S1, i+S1Offset)
    PWM.Set(S2, i+S1Offset)
    PWM.Set(S3, i+S1Offset)
    PWM.Set(S4, i+S1Offset)
    Pause(200)
  Pause(Pulse/2)

  repeat i from 1500 to 1650 step 20
    PWM.Set(S1, i+S1Offset)
    PWM.Set(S2, i+S1Offset)
    PWM.Set(S3, i+S1Offset)
    PWM.Set(S4, i+S1Offset)
    Pause(200)
  Pause(Pulse/2)

   return}