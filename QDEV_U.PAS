unit QDEV_U;

interface

uses crt,QMAT_U,QBIT_U,QNUM_U;

const MAX_QBITS = 16;

type
    QDEV = record

             KET_0:QMAT;
             KET_1:QMAT;
             KET_PLUS:QMAT;

             H:QMAT;
             X:QMAT;

             qbits:array[0..MAX_QBITS-1] of QBIT;

           end;

procedure QDevInit(var dev:QDEV);
procedure QDevClose(var dev:QDEV);

function QDevAllocate(var dev:QDEV):QBIT;
procedure QDevRelease(dev:QDEV;q:QBIT);

procedure QDevReset(dev:QDEV;q:QBIT);
procedure QDevH(dev:QDEV;q:QBIT);
procedure QDevX(dev:QDEV;q:QBIT);
function QDevMeasure(dev:QDEV;q:QBIT):boolean;

implementation

(**********)
procedure QDevInit(var dev:QDEV);
var
   i:integer;
   q:QNUM;
   _q:QNUM;

begin
     Randomize;

     q:=QInt(2);
     _q:=QSqrt(q);

     dev.KET_0:=QMatInit(2,1);
     QMatSet(dev.KET_0, 0, 0, QInt(1));
     QMatSet(dev.KET_0, 1, 0, QInt(0));

     dev.KET_1:=QmatInit(2,1);
     QMatSet(dev.KET_1, 0, 0, QInt(0));
     QMatSet(dev.KET_1, 1, 0, QInt(1));

     dev.KET_PLUS:= QMatAdd(dev.KET_0,dev.KET_1);
     QMatDivNum(dev.KET_PLUS,_q);

     dev.H:=QMatInit(2,2);
     QMatSet(dev.H, 0, 0, QInt(1));
     QMatSet(dev.H, 0, 1, QInt(1));
     QMatSet(dev.H, 1, 0, QInt(1));
     QMatSet(dev.H, 1, 1, QInt(-1));
     QMatDivNum(dev.H,_q);

     dev.X:=QMatInit(2,2);
     QMatSet(dev.X, 0, 0, QInt(0));
     QMatSet(dev.X, 0, 1, QInt(1));
     QMatSet(dev.X, 1, 0, QInt(1));
     QMatSet(dev.X, 1, 1, QInt(0));


   for i:=0 to MAX_QBITS-1 do
     begin
       new(dev.qbits[i]);
       dev.qbits[i]^.id:=-1;
       dev.qbits[i]^.state:=nil;
     end;

   QClose(q);
   QClose(_q);

end;

(**********)
procedure QDevClose(var dev:QDEV);
var
   i:integer;

begin
     QMatClose(dev.KET_0);
     QMatClose(dev.KET_1);
     QMatClose(dev.KET_PLUS);

     QMatClose(dev.H);
     QMatClose(dev.X);

     for i:=0 to MAX_QBITS-1 do
       begin
         if(dev.qbits[i]^.state <> nil) then QMatClose(dev.qbits[i]^.state);
         dispose(dev.qbits[i]);
         dev.qbits[i]:=nil;
       end;
end;

(**********)
function QDevAllocate(var dev:QDEV):QBIT;
var
   i:integer;
   q:QBIT;

begin
     i:=0;
     q:=nil;
     while( (q=nil) and (i<MAX_QBITS)) do
       begin
         if (dev.qbits[i]^.id=-1) then
           begin
             dev.qbits[i]^.id:=i;
             dev.qbits[i]^.state:=QMatCopy(dev.KET_0);
             q:=dev.qbits[i];
           end;
         i:=i+1;
       end;
    QDevAllocate:=q;
end;

(**********)
procedure QDevRelease(dev:QDEV;q:QBIT);
begin
     q^.id:=-1;
     QMatClose(q^.state);
     dispose(q^.state);
     q^.state:=nil;
end;

(**********)
procedure QDevReset(dev:QDEV;q:QBIT);
begin
     QMatClose(q^.state);
     dispose(q^.state);
     q^.state:=QMatCopy(dev.KET_0);
end;

(**********)
procedure QDevH(dev:QDEV;q:QBIT);
var
   mat:QMAT;

begin
     mat:=QMatMul(dev.H, q^.state);
     QMatClose(q^.state);
     dispose(q^.state);
     q^.state:=mat;
end;

(**********)
procedure QDevX(dev:QDEV;q:QBIT);
var
   mat:QMAT;

begin
     mat:=QMatMul(dev.X, q^.state);
     QMatClose(q^.state);
     dispose(q^.state);
     q^.state:=mat;
end;

(**********)
function QDevMeasure(dev:QDEV;q:QBIT):boolean;
var
   num:QNUM;
   r:real;

begin
     num:=QMatGet(q^.state,0,0);
     r:=QAbs(num);

     QDevMeasure:= not( random <= r);
end;

end.