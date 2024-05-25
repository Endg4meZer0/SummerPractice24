program letpract;


// TODO!!!: выходной файлик по условию

uses consts; // модуль констант, общих для всей программы
uses products, orders, shipments; // модули работы с отдельными входными файлами
uses sort; // модуль сортировки
uses output; // модуль вывода ведомости

const products_in_filename = 'products.txt';
const orders_in_filename = 'orders.txt';
const shipments_in_filename = 'shipments.txt';

var err_string, line: string;
var file_record_count, sheetYear: integer;
var f_prod, f_ord, f_ship, f_out: text;
var l_prod: list_prod; l_ord: list_ord; l_ship: list_ship;
var prod: product; ord: order; ship: shipment;
begin
  assign(f_prod, products_in_filename);
  assign(f_ord, orders_in_filename);
  assign(f_ship, shipments_in_filename);
  reset(f_prod); 
  reset(f_ord);
  reset(f_ship);
  
  file_record_count := 0;
  l_prod.Count := 0;
  while (not eof(f_prod)) and (l_prod.Count <= possible_records) do begin
    err_string := '';
    readln(f_prod, line);
    file_record_count := file_record_count + 1;
    err_string := err_string + validateProductString(line);
    if err_string <> '' then begin
      writeln('Ошибки в ' + products_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
    end else begin
      prod := makeProductObjectFromString(line);
      err_string := validateProductObject(prod, l_prod);
      if err_string <> '' then begin
        writeln('Ошибки в ' + products_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
      end else begin
        l_prod.Count := l_prod.Count + 1;
        l_prod.List[l_prod.Count] := prod;
        //writeln(l_prod.List[l_prod.Count]);
      end;
    end;
  end;
  if not eof(f_prod) and (l_prod.Count > possible_records) then writeln('Слишком много записей о товарах. Зарегистрировано максимальное доступное количество (' + possible_records.ToString() + ').');
  close(f_prod);
  
  if l_prod.Count = 0 then writeln('В файле ' + products_in_filename + ' не найдено ни одной валидной записи о товарах!')
  else begin
    file_record_count := 0;
    l_ord.Count := 0;
    while (not eof(f_ord)) and (l_ord.Count <= possible_records) do begin
      err_string := '';
      readln(f_ord, line);
      file_record_count := file_record_count + 1;
      err_string := err_string + validateOrderString(line);
      if err_string <> '' then begin
        writeln('Ошибки в ' + orders_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
      end else begin
        ord := makeOrderObjectFromString(line);
        err_string := validateOrderObject(ord, l_ord, l_prod);
        if err_string <> '' then begin
          writeln('Ошибки в ' + orders_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
        end else begin
          l_ord.Count := l_ord.Count + 1;
          l_ord.List[l_ord.Count] := ord;
          //writeln(l_ord.List[l_ord.Count]);
        end;
      end;
    end;
    if not eof(f_ord) and (l_ord.Count > possible_records) then writeln('Слишком много записей о заказах. Зарегистрировано максимальное доступное количество (' + possible_records.ToString() + ').');
    close(f_ord);
    
    if l_ord.Count = 0 then Writeln('В файле ' + orders_in_filename + ' не найдено ни одной валидной записи о заказах!')
    else begin
      file_record_count := 0;
      l_ship.Count := 0;
      while (not eof(f_ship)) and (l_ship.Count <= possible_records) do begin
        err_string := '';
        readln(f_ship, line);
        file_record_count := file_record_count + 1;
        err_string := err_string + validateShipmentString(line);
        if err_string <> '' then begin
          writeln('Ошибки в ' + shipments_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
        end else begin
          ship := makeShipmentObjectFromString(line);
          err_string := validateShipmentObject(ship, l_ord, l_prod);
          if err_string <> '' then begin
            writeln('Ошибки в ' + shipments_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
          end else begin
            l_ship.Count := l_ship.Count + 1;
            l_ship.List[l_ship.Count] := ship;
            //writeln(l_ship.List[l_ship.Count]);
          end;
        end;
      end;
      if not eof(f_ship) and (l_ship.Count > possible_records) then writeln('Слишком много записей о поставках. Зарегистрировано максимальное доступное количество (' + possible_records.ToString() + ').');
      close(f_ship);
      
      quickSort(l_prod, 1, l_prod.Count);
      quickSort(l_ord, 1, l_ord.Count);
      
      write('Введите год для создания ведомости: ');
      readln(sheetYear);
      
      assign(f_out, 'sheet_' + sheetYear.ToString() + '.txt');
      rewrite(f_out);
      
      printSheet(l_prod, l_ord, l_ship, sheetYear, f_out);
      
      close(f_out);

      writeln('Успешно!');
    end;
  end;
end.