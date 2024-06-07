unit shipments;
interface

uses errors;
uses space_many;
uses consts;
uses products;
uses orders;

type shipped_prod = record
  Code: integer;
  Amount: integer;
end;

type shipment = record
  date: consts.Date; // Дата ОТГРУЗКИ
  order_code: integer;
  prod_list: record
    List: array[1..max_products] of shipped_prod;
    Count: integer;
  end;
end;
list_ship = record
  List: array[1..possible_records] of shipment;
  Count: integer;
end;

function makeShipmentObjectFromString(s: string): shipment;
function validateShipmentString(s: string): string;
function validateShipmentObject(s: shipment; ol: list_ord; pl: list_prod): string;

implementation

function makeShipmentObjectFromString(s: string): shipment;
var i, err: integer;
var _d, _m, _y: integer;
begin
  val(get_next(s), _d, err);
  _m := months.IndexOf(get_next(s)) + 1;
  val(get_next(s), _y, err);
  Result.date := Date.create(_d, _m, _y);
  val(get_next(s), Result.order_code, err);
  
  i := 1;
  while (i <= max_products) and (s <> '') do begin
    val(get_next(s), Result.prod_list.list[i].code, err);
    val(get_next(s), Result.prod_list.list[i].amount, err);
    Result.prod_list.count := i;
    i := i + 1;
  end;
end;

function validateShipmentString(s: string): string;
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
  err_string := validate(s, max_products * 2 + 4);
  
  // Проверка на соблюдение заданного формата данных.
  if err_string = '' then begin
    // -------- ДАТА (ДЕНЬ) --------
    t_s := get_next(s);
    t_flag := true; // Флаг правильности даты
    val(t_s, t_date.day, t_err);
    
    // Проверка на длину строки и на отсутствие лишних символов
    if (t_s.Length <> 2) or (t_err <> 0) then begin 
      append_err(err_string, 'ДАТА (ДЕНЬ): День должен состоять из двух цифр (если число меньше 10, то следует добавить 0 в начало).');
      t_flag := false;
    end
    else begin
      // Проверка на то, чтобы день не был больше 31 или меньше 1
      if (t_date.day > 31) then append_err(err_string, 'ДАТА (ДЕНЬ): День не может быть больше 31.');
      if (t_date.day < 1) then append_err(err_string, 'ДАТА (ДЕНЬ): День не может быть меньше 1.');
    end;
    
    // -------- ДАТА (МЕСЯЦ) --------
    t_s := get_next(s);
    
    // Проверка, что задан верный месяц
    if not months.Contains(t_s) then begin 
      append_err(err_string, 'ДАТА (МЕСЯЦ): Месяц должен состоять из трёх латинских букв по началу их названия (например, "JAN" для января (January)).');
      t_flag := false;
    end
    else begin
      t_date.month := months.IndexOf(t_s);
      if t_flag then begin
        // Проверка, является ли последний день чётного месяца 30-м
        if (t_date.month in ([4, 6, 9, 11])) and (t_date.month <> 2) and (t_date.day > 30) then append_err(err_string, 'ДАТА (МЕСЯЦ): Апрель, июнь, сентябрь и ноябрь имеют всего 30 дней.');
        // Проверка, является ли месяц февралём и день меньшим, чем 30
        if (t_date.month = 2) and (t_date.day > 29) then append_err(err_string, 'ДАТА (МЕСЯЦ): В феврале не может быть больше 29 дней.');
      end;
    end;
    
    // -------- ДАТА (ГОД) --------
    t_s := get_next(s);
    
    // Проверка, что нет лишних символов
    val(t_s, t_date.year, t_err);
    if (t_err <> 0) or (t_date.year < 2000) or (t_date.year > 2099) then begin
      append_err(err_string, 'ДАТА (ГОД): Год должен состоять из четырёх цифр и означать год 21 века (20xx) или 2000-й год.');
      t_flag := false;
    end
    else begin
      if t_flag then begin
        // Проверка на високосные года
        if (t_date.month = 2) and (t_date.day = 29) and ((t_date.year mod 4 <> 0) or ((t_date.year mod 100 = 0) and (t_date.year mod 400 <> 0))) then append_err(err_string, 'ДАТА: 29 февраля может быть только в високосные года.');
      end;
    end;
    
    // -------- КОД ЗАКАЗА --------
    t_s := get_next(s);
    
    // Проверка на начало кода заказа (не должно быть нуля в начале)
    if t_s[1] = '0' then append_err(err_string, 'КОД ЗАКАЗА: Код заказа не может начинаться с 0.');
    
    // Проверка на отсутствие лишних символов в коде заказа
    val(t_s, t_i, t_err);
    if (t_err <> 0) or (t_i > 99999999) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(err_string, 'КОД ЗАКАЗА: Код заказа должен являться целым числом из диапозона [1; 99999999], не должно быть букв и других символов, в том числе "+" и "-".');
    
    // -------- СПИСОК ТОВАРОВ --------
    i := 0;
    t_flag := false; // флаг товара (если найден ВОЗМОЖНЫЙ код товара, то true и ждем кол-во товара, затем снова ставим false)
    while (s <> '') do begin
      t_s := get_next(s);
      
      if t_flag = false then begin
        i := i + 1;
        t_err_string := '';
        
        // Проверка на начало кода НЕ с нуля
        if t_s[1] = '0' then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Код товара не может начинаться с 0.');
        
        // Проверка на отсутствие лишних символов в коде товара
        val(t_s, t_i, t_err);
        if (t_err <> 0) or (t_i > 99999999) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Код товара должен являться целым числом из диапозона [1; 99999999], не должно быть букв и других символов, в том числе "+" и "-".');
        
        if t_err_string <> '' then err_string := err_string + t_err_string;
        t_flag := true;
      end
      else begin
        t_err_string := '';
        
        // Проверка на начало кол-ва НЕ с нуля
        if t_s[1] = '0' then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Кол-во товара не может начинаться с 0.');
        
        // Проверка на отсутствие лишних символов в кол-ве товара
        val(t_s, t_i, t_err);
        if (t_err <> 0) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Кол-во товара должно являться целым числом из диапозона [1; 99999999], не должно быть букв и других символов, в том числе "+" и "-".');
        
        if t_err_string <> '' then err_string := err_string + t_err_string;
        t_flag := false;
      end;
    end;
  end;
  Result := err_string;
end;

function validateShipmentObject(s: shipment; ol: list_ord; pl: list_prod): string;
var i, j: integer;
var flag, allow_check: boolean;
var err_string: string;
var o: order;
begin
  o.code := -1;
  err_string := '';
  allow_check := true;

  // ДАТА
  i := 1;
  while (i <= ol.Count) and not flag do begin
    if ol.List[i].code = s.order_code then begin
      o := ol.List[i];
      if s.date.compare(o.date) = -1
        then append_err(err_string, 'ДАТА: Дата отгрузки товаров по заказу не может быть установлена раньше, чем дата поступления самого заказа.');
    end;
    i := i + 1;
  end;

  // СУЩЕСТВОВАНИЕ ЗАКАЗА ПО КОДУ
  if o.code = -1 then append_err(err_string, 'КОД ЗАКАЗА: Код заказа не соответствует ни одному из зарегистрированных заказов.');

  // СПИСОК ТОВАРОВ
  j := 0;
  for i := 1 to s.prod_list.count do begin
    // ОТСОРТИРОВАННОСТЬ СПИСКА ТОВАРОВ
    if j <> 0 then
      if s.prod_list.list[i].code < j then begin 
        if o.prod_list.List[i].code = j then append_err(err_string, 'СПИСОК ТОВАРОВ: Обнаружено два одинаковых кода товара в списке.')
        else append_err(err_string, 'СПИСОК ТОВАРОВ: Список не отсортирован по кодам товаров.'); 
        allow_check := false; 
      end;

    // СУЩЕСТВОВАНИЕ ТОВАРОВ ИЗ СПИСКА
    if allow_check then begin
      flag := false;
      j := 1;
      while not flag and (j <= pl.Count) do begin
        if pl.List[j].code = s.prod_list.list[i].code then flag := true;
        j := j + 1;
      end;
      if not flag then append_err(err_string, 'ТОВАР №' + i.ToString() + ': Код товара не соответствует ни одному из зарегистрированных товаров.')
      // СООТВЕТСТВИЕ СПИСКА ТОВАРОВ ОТГРУЗКИ СПИСКУ ТОВАРОВ ЗАКАЗА
      else if (o.code <> -1) and (s.prod_list.list[i].code <> o.prod_list.list[i].Code) then append_err(err_string, 'ТОВАР №' + i.ToString() + ': Код товара не соответствует списку товаров заказа.');
    end;
    j := s.prod_list.list[i].code;
  end;
  Result := err_string;
end;

end.