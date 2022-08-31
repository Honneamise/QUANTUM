unit QMAT_U;

interface

uses QNUM_U;

const MAX_MAT = 4;

(**********)
type
    _QMAT = record
          rows:integer;
          cols:integer;
          data:array [0..MAX_MAT-1] of QNUM;
          end;

    QMAT = ^_QMAT;

(**********)
function QMatInit(rows,cols:integer):QMAT;
function QMatCopy(mat:QMAT):QMAT;
procedure QMatClose(var mat:QMAT);
procedure QMatPrint(mat:QMAT);

procedure QMatSet(mat:QMAT;row,col:integer;q:QNUM);
function QMatGet(mat:QMAT;row,col:integer):QNUM;

function QMatAdd(a,b:QMAT):QMAT;
function QMatSub(a,b:QMAT):QMAT;
function QMatMul(a,b:QMAT):QMAT;

procedure QMatAddNum(mat:QMAT;num:QNUM);
procedure QMatSubNum(mat:QMAT;num:QNUM);
procedure QMatMulNum(mat:QMAT;num:QNUM);
procedure QMatDivNum(mat:QMAT;num:QNUM);

implementation

(**********)
function QMatInit(rows,cols:integer):QMAT;
var
    mat:QMAT;
    i:integer;

begin
     new(mat);
     mat^.rows := rows;
     mat^.cols := cols;

     for i:=0 to (rows*cols)-1 do
       mat^.data[i] := nil;

     QMatInit := mat;
end;

function QMatCopy(mat:QMAT):QMAT;
var
   i:integer;
   m:QMAT;

begin
     m:=QMatInit(mat^.rows,mat^.cols);

     for i:=0 to (mat^.rows*mat^.cols)-1 do
         m^.data[i]:=QCopy(mat^.data[i]);

   QMatCopy:=m;
end;

(**********)
procedure QMatClose(var mat:QMAT);
var
   i:integer;

begin
     mat^.rows := 0;
     mat^.cols := 0;
     for i:=0 to (mat^.rows*mat^.cols)-1 do
         QClose(mat^.data[i]);

end;

(**********)
procedure QMatPrint(mat:QMAT);
var
   i:integer;
   module:integer;
begin
     writeln('[rows=', mat^.rows, ',cols=',mat^.cols,']');
     for i:=0 to (mat^.rows*mat^.cols)-1 do
       begin
         module := i mod mat^.cols;
         if( (i>0) and (module=0) ) then writeln('');
         QPrint(mat^.data[i]);
         write('    ');
       end;

     writeln('');
end;

(**********)
procedure QMatSet(mat:QMAT; row,col:integer; q:QNUM);
var
   index:integer;
begin
     index := row*mat^.cols + col;
     QClose(mat^.data[index]);
     mat^.data[index] := q;
end;

(**********)
function QMatGet(mat:QMAT; row,col:integer):QNUM;
var
   index:integer;
begin
     index := row*mat^.cols + col;
     QMatGet := mat^.data[index];
end;

(**********)
function QMatAdd(a,b:QMAT):QMAT;
var
   i:integer;
   mat:QMAT;

begin
     mat := QMatInit(a^.rows, a^.cols);

     for i:=0 to (mat^.rows * mat^.cols)-1 do
       begin
         mat^.data[i] := QAdd(a^.data[i], b^.data[i]);
       end;

     QMatAdd:=mat;
end;

(**********)
function QMatSub(a,b:QMAT):QMAT;
var
   i:integer;
   mat:QMAT;

begin
     mat := QmatInit(a^.rows, a^.cols);

     for i:=0 to (mat^.rows * mat^.cols)-1 do
       begin
         mat^.data[i] := QSub(a^.data[i], b^.data[i]);
       end;

     QMatSub:=mat;
end;

(**********)
function QMatMul(a,b:QMAT):QMAT;
var
   i,j,k:integer;
   mat:QMAT;
   tmp,sum,mul:QNUM;

begin
     mat:=QMatInit(a^.rows,b^.cols);

     for i:=0 to a^.rows-1 do
       begin
         for j:=0 to b^.cols-1 do
           begin

             sum := QComplex(0,0);

             for k:=0 to a^.cols-1 do
               begin
                 mul := QMul( QMatGet(a,i,k), QMatGet(b,k,j) );
                 tmp := QAdd(sum,mul);
                 QClose(sum);
                 QClose(mul);
                 sum := tmp;
               end;

             QMatSet(mat,i,j,sum);

           end;
       end;

     QMatMul:=mat;
end;

(**********)
procedure QMatAddNum(mat:QMAT;num:QNUM);
var
   i:integer;
   q:QNUM;

begin
     for i:=0 to (mat^.rows*mat^.cols)-1 do
       begin
         q:= QAdd(mat^.data[i],num);
         QClose(mat^.data[i]);
         mat^.data[i]:=q;
       end;
end;

(**********)
procedure QMatSubNum(mat:QMAT;num:QNUM);
var
   i:integer;
   q:QNUM;

begin
     for i:=0 to (mat^.rows*mat^.cols)-1 do
       begin
         q:= QSub(mat^.data[i],num);
         QClose(mat^.data[i]);
         mat^.data[i]:=q;
     end;
end;

(**********)
procedure QMatMulNum(mat:QMAT;num:QNUM);
var
   i:integer;
   q:QNUM;

begin
     for i:=0 to (mat^.rows*mat^.cols)-1 do
       begin
         q:= QMul(mat^.data[i],num);
         QClose(mat^.data[i]);
         mat^.data[i]:=q;
       end;
end;

(**********)
procedure QMatDivNum(mat:QMAT;num:QNUM);
var
   i:integer;
   q:QNUM;

begin
     for i:=0 to (mat^.rows*mat^.cols)-1 do
       begin
         q:= QDiv(mat^.data[i],num);
         QClose(mat^.data[i]);
         mat^.data[i]:=q;
       end;
end;

end.