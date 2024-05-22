unit sort;
interface

uses products;
uses consts;

procedure quickSort(var lp: list_prod; low: integer; high: integer);
function stringCompare(s1, s2: string): integer;
//procedure filterByYear(var lp: list_prod; var lo: list_ord; year: integer);

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
//
//procedure filterByYear(var lp: list_prod; var lo: list_ord; year: integer);
//var new_lp: list_prod;
//    new_lo: list_ord;
//    i,j,k: integer;
//    alreadyExists: boolean;
//begin
//  new_lp.Count := 0; new_lo.Count := 0;
//  for i := 1 to lo.Count do begin
//    if lo.List[i].date.Year = year then begin
//      j := 1;
//      while (j <= max_records) and not (lo.List[i].prod_list[j].Code = 0) do begin
//        for k := 1 to lp.Count do begin
//          
//        end;
//        alreadyExists := false; k := 1;
//        while (k <= new_lp.Count) and not alreadyExists do begin
//          if new_lp.List[k].code = lo.List[i].prod_list[j].Code then alreadyExists := true;
//          k := k + 1;
//        end;
//        if not alreadyExists then begin
//          new_lp.Count := new_lp.Count + 1;
//          new_lp.List[new_lp.Count] := 
//        end;
//        j := j + 1;
//      end;
//    end;
//  end;
//end;

end.
