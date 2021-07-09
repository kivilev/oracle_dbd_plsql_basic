------- Пример 5. Управление транзакциями в PL/SQL

-- 1) Управление транакциями
begin
  savepoint sp1;
  
  rollback to sp1;
  commit; 
end;
/
