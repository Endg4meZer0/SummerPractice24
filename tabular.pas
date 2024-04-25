unit tabular;
interface

function get_next(var s: string; char_count: integer): string;
function validate(s: string; var lengths: array of integer): boolean;

implementation

function get_next(var s: string; char_count: integer): string;
begin
  Result := copy(s, 0, char_count).Trim();
  s := copy(s, char_count + 1, s.Length - (char_count + 1));
end;

function validate(s: string; var lengths: array of integer): boolean;
var i, lengths_sum: integer;
begin
  // Проверка на совпадение длин данной строки и ожидаемого формата данных.
  for i := 1 to lengths.Length do begin
    lengths_sum += lengths[i];
  end;
  Result := s.Length = lengths_sum + lengths.Length-1;
  
  // Проверка на правильное расположение разделительных знаков (|)
  if Result then begin
    for i := 1 to lengths.Length-1 do begin
      if s[lengths[i]+1] <> '|' then Result := false;
    end;
  end;
  
  // Проверка на выравнивание по левому краю
  if Result then begin
    lengths_sum := 0;
    for i := 1 to lengths.Length do begin
      if s[lengths_sum] = ' ' then Result := false;
      lengths_sum := lengths_sum + lengths[i] + 1;
    end;
  end;
end;

end.