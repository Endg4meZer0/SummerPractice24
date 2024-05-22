program lab6;

uses consts; // модуль констант, общих для всей программы
uses products; // модули работы с входным файлом
uses sort; // модуль сортировки
uses output; // модуль вывода нового файла

const products_in_filename = 'products.txt';

var err_string, line: string;
var file_record_count: integer;
var f_prod, f_out: text;
var l_prod: list_prod;
var prod: product;
begin
  assign(f_prod, products_in_filename);
  reset(f_prod); 

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
  
  quickSort(l_prod, 1, l_prod.Count);
  
  assign(f_out, 'products_out.txt');
  rewrite(f_out);
  
  printSheet(l_prod, f_out);
  
  close(f_out);
end.