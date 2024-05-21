unit sort;
interface

uses products, orders;
uses consts;

procedure quickSort(var lp: list_prod; low: integer; high: integer);
procedure quickSort(var lo: list_ord; low: integer; high: integer);
function stringCompare(s1, s2: string): integer;

implementation

procedure quickSort(var lp: list_prod; low: integer; high: integer);
var i, j: integer;
var pivot: product;
var iRes, jRes: integer;
begin
  if low < high then begin
    pivot := lp.List[(low + high) div 2];
    i := low;
    j := high;
    repeat
      iRes := stringCompare(lp.List[i].name, pivot.name);
      jRes := stringCompare(lp.List[j].name, pivot.name);
      while (iRes = -1) or ((iRes = 0) and (lp.List[i].code < pivot.code)) do begin
        i := i + 1;
        iRes := stringCompare(lp.List[i].name, pivot.name);
      end;
      while (jRes = 1) or ((jRes = 0) and (lp.List[j].code > pivot.code)) do begin
        j := j - 1;
        jRes := stringCompare(lp.List[j].name, pivot.name);
      end;
      if i <= j then begin
        (lp.List[i], lp.List[j]) := (lp.List[j], lp.List[i]);
        i := i + 1;
        j := j - 1;
      end;
    until i > j;
    
    if low < j then quickSort(lp, low, j);
    if i < high then quickSort(lp, i, high); 
  end;
end;

procedure quickSort(var lo: list_ord; low: integer; high: integer);
var i, j: integer;
var pivot: order;
var iRes, jRes: integer;
begin
  if low < high then begin
    pivot := lo.List[(low + high) div 2];
    i := low;
    j := high;
    repeat
      iRes := stringCompare(lo.List[i].name, pivot.name);
      jRes := stringCompare(lo.List[j].name, pivot.name);
      while (iRes = -1) or ((iRes = 0) and (lo.List[i].code < pivot.code)) do begin
        i := i + 1;
        iRes := stringCompare(lo.List[i].name, pivot.name);
      end;
      while (jRes = 1) or ((jRes = 0) and (lo.List[j].code > pivot.code)) do begin
        j := j - 1;
        jRes := stringCompare(lo.List[j].name, pivot.name);
      end;
      if i <= j then begin
        (lo.List[i], lo.List[j]) := (lo.List[j], lo.List[i]);
        i := i + 1;
        j := j - 1;
      end;
    until i > j;
    
    if low < j then quickSort(lo, low, j);
    if i < high then quickSort(lo, i, high); 
  end;
end;

function stringCompare(s1, s2: string): integer;
// Если s1 < s2 - -1
// Если s1 = s2 - 0
// Если s1 > s2 - 1
var c1, c2: char;
var i: integer;
begin
  result := 0;
  if (s1 = '') and (s2 = '') then result := 0
  else if (s1.Length < s2.Length) then result := -1
  else if (s1.Length > s2.Length) then result := 1
  else begin
    i := 1;
    c1 := s1[i];
    c2 := s2[i];
    while (i <= s1.Length) and (result = 0) do begin
      if c1 < c2 then result := -1
      else if c1 > c2 then result := 1;
      i := i + 1;
      if i <= s1.Length then begin
        c1 := s1[i];
        c2 := s2[i];
      end;
    end;
  end;
end;

end.
