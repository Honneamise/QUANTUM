unit QNUM_U;

interface

(**********)
type
    _QNUM = record
           re:real;
           im:real;
           end;

    QNUM = ^_QNUM;

(**********)
function QInt(num:integer):QNUM;
function QReal(num:real):QNUM;
function QComplex(re,im:real):QNUM;
function QCopy(q:QNUM):QNUM;
procedure QClose(var q:QNUM);
procedure QPrint(q:QNUM);

function QAbs(q:QNUM):real;
function QSqrt(q:QNUM):QNUM;
function QConj(q:QNUM):QNUM;
function QAdd(a,b:QNUM):QNUM;
function QSub(a,b:QNUM):QNUM;
function QMul(a,b:QNUM):QNUM;
function QDiv(a,b:QNUM):QNUM;

implementation

(**********)
function QInt(num:integer):QNUM;
begin
     QInt := QComplex(num,0);
end;

(**********)
function QReal(num:real):QNUM;
begin
     QReal := QComplex(num,0);
end;

(**********)
function QComplex(re,im:real):QNUM;
var
   q:QNUM;
begin
     q := nil;
     new(q);
     q^.re := re;
     q^.im := im;
     QComplex := q;
end;

(**********)
function QCopy(q:QNUM):QNUM;
begin
     QCopy := QComplex(q^.re,q^.im);
end;

(**********)
procedure QClose(var q:QNUM);
begin
     if (q<>nil) then dispose(q);
     q:=nil;
end;

(**********)
procedure QPrint(q:QNUM);
begin
     write(q^.re:0:2, '+', q^.im:0:2, 'i');
end;

(**********)
function QAbs(q:QNUM):real;
begin
     QAbs := sqrt( sqr(q^.re) + sqr(q^.im) );
end;

(**********)
function QSqrt(q:QNUM):QNUM;
var
   a:real;
   b:real;
   s:real;

begin
     s:= sqrt( (q^.re*q^.re)+(q^.im*q^.im));

     if q^.im<>0 then
       begin
         a:= sqrt((q^.re + s)/2);
         b:= q^.im/abs(q^.im) * sqrt((-q^.re + s)/2);
         QSqrt:=QComplex(a,b);
       end
     else
       begin
         if q^.re>=0 then QSqrt:=QComplex(sqrt(q^.re),0)
         else QSqrt:=QComplex(0,sqrt(-q^.re));
       end;
end;

(**********)
function QConj(q:QNUM):QNUM;
begin
     QConj := QComplex(q^.re, -q^.im);
end;

(**********)
function QAdd(a,b:QNUM):QNUM;
begin
     QAdd := QComplex( a^.re+b^.re, a^.im+b^.im);
end;

(**********)
function QSub(a,b:QNUM):QNUM;
begin
     QSub := QComplex( a^.re-b^.re, a^.im-b^.im);
end;

(**********)
function QMul(a,b:QNUM):QNUM;
var
   _re:real;
   _im:real;
begin
     _re := a^.re*b^.re - a^.im*b^.im;
     _im := a^.re*b^.im + b^.re*a^.im;
     QMul := QComplex(_re,_im);
end;

(**********)
function QDiv(a,b:QNUM):QNUM;
var
   m:QNUM;
   _a:QNUM;
   _b:QNUM;
   d:real;
begin
     m := QConj(b);
     _a := QMul(a,m);
     _b := QMul(b,m);
     d := _b^.re;

     QDiv := QComplex( _a^.re/d, _a^.im/d);

     dispose(_a);
     dispose(_b);
end;

end.