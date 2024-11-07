/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 23. Расписания
  
  Описание скрипта: устаревший способ создания джобов
  
*/

---- Пример 1. Создание, запуск и удаление задачи с использованием DBMS_JOB

-- 1. Создание задачи, которая выполняет простую PL/SQL операцию
-- Здесь создаётся задача, которая выводит сообщение "Привет из DBMS_JOB!" каждый час.
-- Важно: после вызова DBMS_JOB.SUBMIT необходимо выполнить COMMIT, чтобы задача стала активной.

declare
  job_id number;
begin
  dbms_job.submit(job       => job_id,
                  what      => 'BEGIN dbms_session.sleep(10); END;',
                  next_date => sysdate,
                  interval  => 'SYSDATE + 1/24/60' -- Запускать задачу каждую минуту
                  );
  commit;
  dbms_output.put_line('Создана задача с ID: ' || job_id);
end;
/

-- 2. Выполнение задачи вручную
-- Запустить задачу принудительно можно с помощью:
-- (Замените <job_id> на реальный ID задачи, который вы получили после её создания).

begin
  dbms_job.run(job => < job_id >);
end;
/

-- 3. Удаление задачи
-- (Замените <job_id> на ID задачи).
begin
  dbms_job.remove(job => <job_id>);
  commit;
end;
/


---- Пример 2: Создание задачи с определённым интервалом выполнения
-- 1. Создание задачи, которая запускается ежедневно в полночь
-- Задача будет выполняться каждый день ровно в 00:00.

declare
  job_id number;
begin
  dbms_job.submit(job       => job_id,
                  what      => 'BEGIN your_procedure_name; END;', -- Здесь укажите вашу процедуру
                  next_date => trunc(sysdate + 1), -- Запустится в полночь
                  interval  => 'TRUNC(SYSDATE + 1)' -- Затем будет запускаться ежедневно в полночь
                  );
  commit;
  dbms_output.put_line('Создана задача с ID: ' || job_id);
end;
/


---- Пример 3: Остановка и перезапуск задачи

-- 1. Помечаем задачу как "сломанную" (остановка)
-- Задача помечается как "сломанная" и не будет выполняться, пока её не "починят".
-- (Замените <job_id> на ID вашей задачи).

begin
  dbms_job.broken(job => < job_id >, broken => true);
  commit;
end;
/


-- 2. Перезапуск задачи (снятие статуса "сломанная")
-- После выполнения этого кода задача снова станет активной.
-- (Замените <job_id> на ID вашей задачи).

begin
  dbms_job.broken(job => < job_id >, broken => false, next_date => sysdate);
  commit;
end;
/


---- Пример 4: Изменение интервала выполнения существующей задачи
-- 1. Изменяем интервал выполнения задачи на выполнение каждые 5 минут
-- (Замените <job_id> на ID вашей задачи).
-- Теперь задача будет запускаться каждые 5 минут.
-- Запрос к системным представлениям для проверки задач DBMS_JOB

begin
  dbms_job.interval(job      => < job_id >,
                    interval => 'SYSDATE + 5/1440' -- 5 минут = 5/1440 от суток
                    );
  commit;
end;
/

-- Вы можете просмотреть информацию о задачах DBMS_JOB с помощью следующего запроса:
select job
      ,what
      ,next_date
      ,interval
      ,broken
  from dba_jobs
 where job = < job_id >; -- Укажите ID вашей задачи или удалите условие WHERE для просмотра всех задач