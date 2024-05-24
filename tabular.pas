unit tabular;
interface

uses errors;

function get_next(var s: string; char_count: integer): string;
function validate(s: string; var lengths: array of integer): string;

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

function validate(s: string; var lengths: array of integer): string;
var i, j, lengths_sum: integer;
var err_string: string;
var err_flag, err_flag2: boolean;
begin
  err_string := '';

  if s.Length = 0 then append_err(err_string, 'ФОРМАТ ДАННЫХ: Обнаружена пустая строка.')
  else begin
    // Проверка на совпадение длин данной строки и ожидаемого формата данных.
    for i := 0 to lengths.Length-1 do begin
      lengths_sum += lengths[i];
    end;
    if s.Length > lengths_sum + lengths.Length-1 then append_err(err_string, 'ФОРМАТ ДАННЫХ: Слишком много данных. Должно быть точно ' + (lengths_sum + lengths.Length - 1).ToString() + ' символов (включая разделители "|").')
    else if s.Length < lengths_sum + lengths.Length-1 then append_err(err_string, 'ФОРМАТ ДАННЫХ: Слишком мало данных. Должно быть точно ' + (lengths_sum + lengths.Length - 1).ToString() + ' символов (включая разделители "|").')
    else begin    
      // Проверка на правильное расположение разделительных знаков (|)
      lengths_sum := 0;
      for i := 0 to lengths.Length-2 do begin
        lengths_sum := lengths_sum + lengths[i] + 1;
        if s[lengths_sum] <> '|' then append_err(err_string, 'ФОРМАТ ДАННЫХ: Неверная длина ' + (i+1).ToString() + '-го поля. В нём должно находиться ровно ' + lengths[i].ToString() + ' символов, включая пробелы, а на ' + lengths_sum.ToString() + '-й позиции строки должен находиться ТОЛЬКО разделитель "|".');
      end;
      
      // Проверка на выравнивание по левому краю
      lengths_sum := 1;
      for i := 0 to lengths.Length-1 do begin
        err_flag := (s.Length >= lengths_sum) and (s[lengths_sum] = ' ');
        err_flag2 := false;
        if not err_flag then begin
          j := lengths_sum;
          while (j < s.Length) and (s[j] <> '|') do begin
            if s[j] = ' ' then err_flag2 := true
            else if (s[j] <> ' ') and err_flag2 then err_flag := true;
            j := j+1;
          end;
        end;
        if err_flag then append_err(err_string, 'ФОРМАТ ДАННЫХ: Не соблюдено выравнивание по левому краю в ' + (i+1).ToString() + '-м поле.');
        lengths_sum := lengths_sum + lengths[i] + 1;
      end;
    end;
  end;
  
  Result := err_string;
end;

end.