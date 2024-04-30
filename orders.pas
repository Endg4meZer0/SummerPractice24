unit orders;
interface

uses errors;
uses space_one;
uses consts;
uses products;

type order = record
  code: integer;
  name: string;
  phone: integer;
  date: record // Дата ПОСТУПЛЕНИЯ заказа
    day: integer;
    month: integer;
    year: integer;
  end;
  prod_list: array[1..max_products] of record
    code: integer;
    amount: integer;
  end;
end;
list_ord = array[1..possible_records] of order;

function makeOrderObjectFromString(s: string): order;
function validateOrderString(s: string): string; // Валидация ФОРМАТА данных
function validateOrderObject(o: order; ol: list_ord; pl: list_prod): string; // Валидация ОБЪЕКТА (здесь находится проверка, например, существования указанных кодов товаров)

implementation

function makeOrderObjectFromString(s: string): order;
var i, err: integer;
begin
  val(get_next(s), Result.code, err);
  Result.name := get_next(s);
  val(get_next(s), Result.phone, err);
  val(get_next(s), Result.date.day, err);
  Result.date.month := months.IndexOf(get_next(s));
  val(get_next(s), Result.date.year, err);
  
  i := 1;
  while (i <= max_products) and (s <> '') do begin
    val(get_next(s), Result.prod_list[i].code, err);
    val(get_next(s), Result.prod_list[i].amount, err);
  end;
end;

function validateOrderString(s: string): string;
var err_string, t_err_string: string;
var t_s: string;
var t_i, i: integer;
var t_err: integer;
var t_flag: boolean;
var t_date: record
  day: integer;
  month: integer;
  year: integer;
end;
begin
  err_string := validate(s, max_products * 2 + 6);
  
  // Проверка на соблюдение заданного формата данных.
  if err_string = '' begin
    // -------- КОД ЗАКАЗА --------
    t_s := get_next(s);
    
    // Проверка на начало кода заказа (не должно быть нуля в начале)
    if t_s[1] = '0' then append_err(err_string, 'Код заказа не может начинаться с 0');
    
    // Проверка на отсутствие лишних символов в коде заказа
    val(t_s, t_i, t_err);
    if (t_err <> 0) or (t_i > 99999999) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(err_string, 'Код заказа должен состоять ТОЛЬКО максимум из 8 цифр, не должно быть букв и других символов.');
    
    // -------- НАИМЕНОВАНИЕ ЗАКАЗЧИКА --------
    t_s := get_next(s);
    
    // Проверка на оканчивание имени НЕ на пробел или _
    if t_s[t_s.Length] = '_' then append_err(err_string, 'Наименование товара не может оканчиваться нижним подчёркиванием.');
    
    // Проверка на начало имени НЕ на _
    if t_s[1] = '_' then append_err(err_string, 'Наименование товара не может начинаться с нижнего подчеркивания.');
    
    // -------- НОМЕР ТЕЛЕФОНА --------
    // Пример: 78009921385
    t_s := get_next(s);
    val(t_s, t_i, t_err);
    
    // Проверка на длину номера телефона и на отсутствие лишних символов.
    if (t_s.Length <> 11) or (t_err <> 0) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(err_string, 'Номер телефона должен быть записан, используя только 11 цифр.');
    
    // Проверка на начало номера на 7
    if (t_s[1] = '7') then append_err(err_string, 'Номер должен начинаться с 7 (код России).');
    
    // -------- ДАТА (ДЕНЬ) --------
    t_s := get_next(s);
    t_flag := true; // Флаг правильности даты
    val(t_s, t_date.day, t_err);
    
    // Проверка на длину строки и на отсутствие лишних символов
    if (t_s.Length <> 2) or (t_err <> 0) then begin 
      append_err(err_string, 'День должен состоять из двух цифр (если число меньше 10, то следует добавить 0 в начало).');
      t_flag := false;
    end
    else begin
      // Проверка на то, чтобы день не был больше 31 или меньше 1
      if (t_date.day > 31) then append_err(err_string, 'День не может быть больше 31.');
      if (t_date.day < 1) then append_err(err_string, 'День не может быть меньше 1.');
    end;
    
    // -------- ДАТА (МЕСЯЦ) --------
    t_s := get_next(s);
    
    // Проверка, что задан верный месяц
    if not months.Contains(t_s) then begin 
      append_err(err_string, 'Месяц должен состоять из трёх латинских букв по началу их названия (например, "JAN" для января (January)).');
      t_flag := false;
    end
    else begin
      t_date.month := months.IndexOf(t_s);
      if t_flag then begin
        // Проверка, является ли последний день чётного месяца 30-м
        if (t_date.month mod 2 = 0) and (t_date.month <> 2) and (t_date.day > 30) then append_err(err_string, 'Чётные месяцы (кроме февраля) имеют всего 30 дней.');
        // Проверка, является ли месяц февралём и день меньшим, чем 30
        if (t_date.month = 2) and (t_date.day > 29) then append_err(err_string, 'В феврале не может быть больше 29 дней.');
      end;
    end;
    
    // -------- ДАТА (ГОД) --------
    t_s := get_next(s);
    
    // Проверка, что нет лишних символов
    val(t_s, t_date.year, t_err);
    if (t_err <> 0) or (t_date.year < 2000) or (t_date.year > 2099) then begin
      append_err(err_string, 'Год должен состоять из четырёх цифр и означать год 21 века (20xx) или 2000-й год.');
      t_flag := false;
    end
    else begin
      if t_flag then begin
        // Проверка на високосные года
        if (t_date.month = 2) and (t_date.day = 29) and ((t_date.year mod 4 <> 0) or ((t_date.year mod 100 = 0) and (t_date.year mod 400 <> 0))) then append_err(err_string, '29 февраля может быть только в високосные года.');
      end;
    end;
    
    // -------- СПИСОК ТОВАРОВ --------
    i := 0;
    t_flag := false; // флаг товара (если найден ВОЗМОЖНЫЙ код товара, то true и ждем кол-во товара, затем снова ставим false)
    while (s <> '') do begin
      t_s := get_next(s);
      
      if t_flag = false then begin
        i := i + 1;
        t_err_string := '';
        
        // Проверка на начало кода НЕ с нуля
        if t_s[1] = '0' then append_err(t_err_string, '(Товар ' + i.ToString() + ') Код товара не может начинаться с 0.');
        
        // Проверка на отсутствие лишних символов в коде товара
        val(t_s, t_i, t_err);
        if (t_err <> 0) or (t_i > 99999999) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(t_err_string, '(Товар ' + i.ToString() + ') Код товара должен состоять ТОЛЬКО максимум из 8 цифр, не должно быть букв и других символов.');
        
        if t_err_string <> '' then err_string := err_string + t_err_string;
        t_flag := true;
      end
      else begin
        t_err_string := '';
        
        // Проверка на начало кол-ва НЕ с нуля
        if t_s[1] = '0' then append_err(t_err_string, '(Товар ' + i.ToString() + ') Кол-во товара не может начинаться с 0.');
        
        // Проверка на отсутствие лишних символов в кол-ве товара
        val(t_s, t_i, t_err);
        if (t_err <> 0) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(t_err_string, '(Товар ' + i.ToString() + ') Кол-во товара должен состоять ТОЛЬКО из цифр, не должно быть букв и других символов.');
        
        if t_err_string <> '' then err_string := err_string + t_err_string;
        t_flag := false;
      end;
    end;
  end;
  Result := err_string;
end;

function validateOrderObject(o: order; ol: list_ord; pl: list_prod): string;
var i, j: integer;
var flag: boolean;
var err_string: string;
begin
  err_string := '';
  for i := 1 to possible_records do begin
    if ol[i].code = o.code then append_err(err_string, 'КОД ЗАКАЗА: Произошёл конфликт в виде совпадения кода заказа с кодом другого уже зарегистрированного заказа.');
  end;
  for i := 1 to max_products do begin
    if o.prod_list[i].code <> 0 then begin
      flag := false;
      for j := 1 to possible_records do begin
        if pl[j].code = o.prod_list[i].code then flag := true;
      end;
      if not flag then append_err(err_string, 'ТОВАР ' + i.ToString() + ': Код товара не соответствует ни одному из зарегистрированных в файле товаров.');
    end;
  end;
  Result := err_string;
end;

end.