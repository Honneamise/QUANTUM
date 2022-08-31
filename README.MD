# QUANTUM PROGRAMMING IN PASCAL

A set of Pascal functions for Quantum Computing based on the book "Learn Quantum Computing with Python and Q#" by SARAH KAISER and CHRISTOPHER GRANADE

---
## Units
---

**QNUM_U** : basic unit for operation on complex numbers

**QMAT_U** : basic unit for operations on matrices

**QBIT_U** : simple qbit definition

**QDEV_U** : quantum device implementation

---
## Functions
---

## procedure QDevInit(var dev:QDEV);

Initialize the quantum device, by default it can handle up to 16 qbits.

(It should be released with a call to QDevClose)

## procedure QDevClose(var dev:QDEV);

Release the allocated space previously created by the function QDevInit.

## function QDevAllocate(var dev:QDEV):QBIT;

Return a pointer to the first available qbit of the quantum device.
If all the qbits of the device are already in use, the function will return **nil** 

## procedure QDevRelease(dev:QDEV;q:QBIT);

Release an active qbit and make it again available.

## procedure QDevReset(dev:QDEV;q:QBIT);

Reset the state of the selected qbit (KET_0).

## procedure QDevH(dev:QDEV;q:QBIT);

Apply the H operation to the selected qbit.

## procedure QDevX(dev:QDEV;q:QBIT);

Apply the X operation to the selected qbit.

## function QDevMeasure(dev:QDEV;q:QBIT):boolean;

Return the "logic" state of the qbit .

---
**Test Program**

```
program QUANTUM;

uses QDEV_U,QBIT_U;

(**********)
function QRNG(dev:QDEV;q:QBIT):boolean;

begin
     QDevReset(dev,q);

     QDevH(dev,q);

     QRNG:=QDevMeasure(dev,q);
end;

(**********)
var
   dev:QDEV;
   q:QBIT;
   i:integer;

begin

     QDevInit(dev);

     q:=QDevAllocate(dev);

     for i:=1 to 10 do
       begin
         writeln('round:', i, ' val:', QRNG(dev,q));
       end;

     QDevClose(dev);

end.
```
**Output**
```
round:1 val:FALSE
round:2 val:FALSE
round:3 val:TRUE
round:4 val:FALSE
round:5 val:FALSE
round:6 val:TRUE
round:7 val:TRUE
round:8 val:FALSE
round:9 val:FALSE
round:10 val:FALSE
```

---
**Notes:**

The file __"trex.zip"__ contains a ready-to-run DOSBOX environment emulating a intel 386 to run and/or modify the program with the included Turbo Pascal 5.5.




