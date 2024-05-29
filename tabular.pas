unit tabular;
interface

uses errors;

function get_next(var s: string; char_count: integer): string;
function validate(s: string; var lengths: array of integer; minimum_lengths: integer): string;

implementation

function get_next(var s: string; char_count: integer): string;
var i: integer;
begin
  i := 1;
  while (i <= char_count) and (s[i] <> ' ') do begin
    Result := Result + s[i];
    i := i + 1;
  end;
  s := copy(s, char_count + 2, s.Length - (char_count + 1));
end;

function validate(s: string; var lengths: array of integer; minimum_lengths: integer): string;
var i, j, lengths_sum, minimum_lengths_sum: integer;
var t_string, err_string: string;
begin
  err_string := '';

  if s.Length = 0 then append_err(err_string, 'ФОРМАТ ДАННЫХ: Обнаружена пустая строка.')
  else begin
    // Проверка на совпадение длин данной строки и ожидаемого формата данных.
    for i := 0 to lengths.Length-1 do begin
      lengths_sum := lengths_sum + lengths[i];
      if i < minimum_lengths then minimum_lengths_sum := minimum_lengths_sum + lengths[i];
    end;
    if s.Length > lengths_sum + lengths.Length then append_err(err_string, 'ФОРМАТ ДАННЫХ: Слишком много данных. Должно быть не более ' + (lengths.Length).ToString() + ' полей длиной ' + (lengths_sum + lengths.Length).ToString() + ' символов (включая разделители "|").')
    else if s.Length < minimum_lengths_sum + minimum_lengths then append_err(err_string, 'ФОРМАТ ДАННЫХ: Слишком мало данных. Должно быть хотя бы ' + (minimum_lengths).ToString() + ' полей длиной ' + (minimum_lengths_sum + minimum_lengths).ToString() + ' символов (включая разделители "|").')
    else begin
      // Проверка на правильное расположение разделительных знаков (|)
      lengths_sum := lengths[0] + 1;
      i := 0;
      while (i < lengths.Length-1) and (s.Length >= lengths_sum) do begin
        if s[lengths_sum] <> '|' then append_err(err_string, 'ФОРМАТ ДАННЫХ: Неверная длина ' + (i+1).ToString() + '-го поля. В нём должно находиться ровно ' + lengths[i].ToString() + ' символов, включая пробелы, а на ' + lengths_sum.ToString() + '-й позиции строки должен находиться ТОЛЬКО разделитель "|".');
        i := i + 1;
        lengths_sum := lengths_sum + lengths[i] + 1;
      end;
      
      // Проверка на выравнивание по левому краю
      lengths_sum := 1;
      for i := 0 to lengths.Length-1 do begin
        t_string := copy(s, lengths_sum, lengths[i]);
        if t_string[1] = ' ' then append_err(err_string, 'ФОРМАТ ДАННЫХ: Не соблюдено выравнивание по левому краю в ' + (i+1).ToString() + '-м поле.');
        if pos(' ', t_string.Trim()) <> 0 then append_err(err_string, 'ФОРМАТ ДАННЫХ: Обнаружено разделение данных пробелом в ' + (i+1).ToString() + '-м поле.');

        lengths_sum := lengths_sum + lengths[i] + 1;
      end;
    end;
  end;
  
  Result := err_string;
end;

end.