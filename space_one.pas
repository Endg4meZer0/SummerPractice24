unit space_one;
interface

uses errors;

function get_next(var s: string): string;
function validate(s: string; max_elements_count: integer): string;

implementation

function get_next(var s: string): string;
var i: integer;
begin
  if s = '' then Result := ''
  else begin
    i := 1;
    while (i <= s.Length) and (s[i] <> ' ') do i := i+1;
    Result := copy(s, 1, i-1);
    s := copy(s, i + 1, s.Length - i);
  end;
end;

function validate(s: string; max_elements_count: integer): string;
var i, count: integer;
var err_string: string;
begin
  err_string := '';
  
  if s.Length = 0 then append_err(err_string, 'ФОРМАТ ДАННЫХ: Обнаружена пустая строка.')
  else begin
    if s[1] = ' ' then append_err(err_string, 'ФОРМАТ ДАННЫХ: Строка не должна начинаться с пробела.');
    if s[s.Length] = ' ' then append_err(err_string, 'ФОРМАТ ДАННЫХ: Строка не должна оканчиваться на пробел.');
    
    count := 1;
    for i := 1 to s.Length do begin
      if (s[i] = ' ') then begin
        count := count + 1;
      end;
    end;
    if (count > max_elements_count) then append_err(err_string, 'ФОРМАТ ДАННЫХ: Слишком много данных. Максимальное кол-во полей: ' + max_elements_count.ToString() + ' (день, месяц и год отгрузки, код заказа и список товаров максимум из ' + (max_elements_count / 2 - 6).ToString() + ' элементов по 2 поля каждый).')
    else if (count < 6) then append_err(err_string, 'ФОРМАТ ДАННЫХ: Слишком мало данных. Необходимо 4 обязательных поля (день, месяц и год отгрузки и код заказа), а так же хотя бы один элемент товара с 2-мя полями: код и кол-во.')
    else if (count mod 2 = 1) then append_err(err_string, 'ФОРМАТ ДАННЫХ: Неверное количество данных. Товары имеют по два поля: код и кол-во. У последнего товара указан только код.');
  end;
  Result := err_string;
end;

end.