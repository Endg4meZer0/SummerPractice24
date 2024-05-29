unit products;
interface

uses errors;
uses tabular;
uses consts;

type product = record
  code: integer;
  name: string;
  cost: real;
end;

list_prod = record
  List: array[1..possible_records] of product;
  Count: integer;
end;

function makeProductObjectFromString(s: string): product;
function validateProductString(s: string): string;
function validateProductObject(p: product; pl: list_prod): string;

implementation

function makeProductObjectFromString(s: string): product;
var err: integer;
begin
  val(get_next(s,8), Result.code, err);
  Result.name := get_next(s,32);
  val(get_next(s,10), Result.cost, err);
end;

function validateProductString(s: string): string;
var err_string: string;
var t_s: string;
var t_i: integer;
var t_r: real;
var t_flag: boolean;
var t_err: integer;
var tab_lengths: array of integer = (8, 32, 10);
begin
  err_string := validate(s, tab_lengths);
  
  // Проверка на соблюдение заданного формата данных.
  if err_string = '' then begin
    // -------- КОД ТОВАРА --------
    t_s := get_next(s, tab_lengths[0]);
    
    // Проверка на начало кода НЕ с нуля
    if t_s[1] = '0' then append_err(err_string, 'КОД ТОВАРА: Код товара не может начинаться с 0.');
    
    // Проверка на длину кода и отсутствие лишних символов в коде
    val(t_s, t_i, t_err);
    if (t_err <> 0) or (t_i > 99999999) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(err_string, 'КОД ТОВАРА: Код товара должен состоять ТОЛЬКО максимум из 8 цифр, не должно быть букв и других символов вроде "+", "-" и т.п.');
    
    // -------- НАИМЕНОВАНИЕ ТОВАРА --------
    t_s := get_next(s, tab_lengths[1]);
    
    // Проверка на начало имени НЕ на _
    if t_s[1] = '_' then append_err(err_string, 'НАИМЕНОВАНИЕ ТОВАРА: Наименование товара не может начинаться с нижнего подчеркивания.');
    
    // Проверка на оканчивание имени НЕ на пробел или _
    if t_s[t_s.Length] = '_' then append_err(err_string, 'НАИМЕНОВАНИЕ ТОВАРА: Наименование товара не может оканчиваться на нижнее подчёркивание.');
    
    // Проверка на отсутствие невалидных символов
    t_flag := false;
    for t_i := 1 to t_s.Length do begin
      if t_s[t_i] not in ['A'..'Z', 'А'..'Я', 'a'..'z', 'а'..'я', '0'..'9', '_'] then t_flag := true;
    end;
    if t_flag then append_err(err_string, 'НАИМЕНОВАНИЕ ТОВАРА: Обнаружены неприемлимые символы. Разрешены только русский и английский алфавит, цифры и нижнее подчёркивание.');
    
    // -------- СТОИМОСТЬ ТОВАРА --------
    t_s := get_next(s, tab_lengths[2]);
    
    // Проверка на начало стоимости на 0
    if (t_s[1] = '0') then append_err(err_string, 'СТОИМОСТЬ ТОВАРА: Стоимость товара не может начинаться с 0.');
    
    // Проверка на отсутствие + и - в начале
    if (t_s[1] = '+') or (t_s[1] = '-') then append_err(err_string, 'СТОИМОСТЬ ТОВАРА: Стоимость товара не должна начинаться со знаков "+" или "-". Она всегда положительна.');
    
    // Проверка на отсутствие лишних символов в стоимости товара
    val(t_s, t_r, t_err);
    if t_err <> 0 then append_err(err_string, 'СТОИМОСТЬ ТОВАРА: Стоимость товара должна являться вещественным числом максимум из 10 символов (7 цифр перед точкой, сама точка и две обязательных цифры после точки), не должно быть букв и других символов.');
    
    // Проверка на наличие точки и конкретно двух цифр после неё
    t_i := pos('.', t_s);
    if (t_i = 0) or (t_s.Length - t_i <> 2) then append_err(err_string, 'СТОИМОСТЬ ТОВАРА: В стоимости товара обязательно должно присутствовать две цифры после точки, даже если дробное значение равно нулю (тогда стоимость должна иметь ".00" в конце).');
    
  end;
  Result := err_string;
end;

function validateProductObject(p: product; pl: list_prod): string;
var i: integer;
var err_string: string;
begin
  err_string := '';
  for i := 1 to pl.Count do begin
    if pl.List[i].code = p.code then append_err(err_string, 'КОД ТОВАРА: Произошёл конфликт в виде повтора кода товара с кодом другого уже зарегистрированного товара.');
  end;
  
  Result := err_string;
end;

end.