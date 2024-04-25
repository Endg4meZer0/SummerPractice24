unit products;
interface

uses errors;
uses tabular;

const tab_lengths: array of integer = (8, 32, 10);

type product = record
  code: integer;
  name: string;
  cost: real;
end;
list_prod = array of product;

function makeFromString(s: string): product;
function validateString(s: string): string;

implementation

function makeFromString(s: string): product;
begin
  
end;

function validateString(s: string): string;
var err_string: string;
var t_s: string;
var t_i: integer;
var t_err: integer;
begin
  err_string := '';
  
  // Проверка на соблюдение заданного табличного формата данных.
  if not validate(s, tab_lengths) then append_err(err_string, 'Не соблюдён формат данных. Они должны быть представлены в табличном виде с выравниванием по левому краю и с длинами полей: ' + tab_lengths.JoinToString(', '))
  else begin
    // -------- КОД ТОВАРА --------
    t_s := get_next(s, 8).Trim();
    
    if t_s.StartsWith('0') then append_err(err_string, 'Код товара не может начинаться с 0');
    
    // Проверка на отсутствие лишних символов в коде товара
    val(t_s, t_i, t_err);
    if t_err <> 0 then append_err(err_string, 'Код товара должен состоять максимум из 8 цифр, не должно быть букв и других символов.');
    
    // -------- НАИМЕНОВАНИЕ ТОВАРА --------
    t_s := get_next(s, 32).Trim();
    
    // Проверка на оканчивание имени НЕ на пробел или _
    if t_s.EndsWith('_') then append_err(err_string, 'Наименование товара не может оканчиваться пробелом или нижним подчёркиванием.');
    
    // Проверка на начало имени НЕ на _
    if t_s.StartsWith('_') then append_err(err_string, 'Наименование товара не может начинаться с нижнего подчеркивания.');
    
    // Проверка на отсутствие пробелов внутри имени
    if t_s.Contains(' ') then append_err(err_string, 'Внутри наименования товара не должно быть пробелов. В качестве разделителя используйте нижнее подчёркивание.');
    
    // -------- СТОИМОСТЬ ТОВАРА --------
    t_s := get_next(s, 10).Trim();
    
    val(t_s, t_i, t_err);
    // Проверка на отсутствие лишних символов в стоимости товара
    if t_err <> 0 then append_err(err_string, 'Стоимость товара должна являться вещественным числом максимум из 10 символов (7 цифр перед точкой, сама точка и две обязательных цифры после точки), не должно быть букв и других символов.');
    t_i := pos('.', t_s);
    // Проверка на наличие точки и конкретно двух цифр после неё
    if (t_i = 0) or (t_s.Length - t_i <> 2) then append_err(err_string, 'В стоимости товара обязательно должно присутствовать две цифры после точки, даже если дробное значение равно нулю (тогда стоимость должна иметь ".00" в конце).');
    // Проверка 
    
    
  end;
  Result := err_string;
end;

end.