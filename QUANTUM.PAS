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
       writeln('round:', i, ' val:', QRNG(dev,q));

     QDevClose(dev);

end.