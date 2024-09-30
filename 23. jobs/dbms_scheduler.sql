/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 23. Расписания
  
  Описание скрипта: современный/актуальный способ создания джобов

*/


---- Пример 1. Полный цикл управления джобом
-- 1. Создание выключенного джоба
begin
  dbms_scheduler.create_job(job_name   => 'example_job1',
                            job_type   => 'PLSQL_BLOCK',
                            job_action => 'BEGIN DBMS_LOCK.SLEEP(5); END;',
                            start_date => systimestamp,
                            enabled    => false);
end;
/

-- 2. Включение джоба
begin
  dbms_scheduler.enable('example_job1');
end;
/

-- 3. Запуск джоба вручную
begin
  dbms_scheduler.run_job('example_job1');
end;
/

-- 4. Остановка джоба
begin
  dbms_scheduler.stop_job('example_job1', force => true);
end;
/

-- 5. Удаление джоба
begin
  dbms_scheduler.drop_job('example_job1');
end;
/

--  Запрос к системным представлениям для проверки статуса джоба

select job_name
      ,state
  from all_scheduler_jobs
 where job_name = 'EXAMPLE_JOB1';



---- Пример 2: Создание, включение и запуск в одном флаконе
-- 1. Создание задачи с автоматическим стартом через 10 секунд и повторением каждые 30 секунд
begin
  dbms_scheduler.create_job(job_name        => 'example_job2',
                            job_type        => 'PLSQL_BLOCK',
                            job_action      => 'BEGIN DBMS_LOCK.SLEEP(5); END;',
                            start_date      => systimestamp + interval '10'
                                               second,
                            repeat_interval => 'FREQ=SECONDLY; INTERVAL=30',
                            enabled         => true);
end;
/

-- 2. Удаление джоба
begin
  dbms_scheduler.drop_job('example_job2');
end;
/

-- Запрос к системным представлениям для проверки статуса джоба

select job_name
      ,state
      ,last_start_date
      ,next_run_date
  from all_scheduler_jobs
 where job_name = 'EXAMPLE_JOB2';



---- Пример 3: Остановка и удаление работающего джоба

-- 1. Создание джоба, выполняющего засыпание на 1 минуту
begin
  dbms_scheduler.create_job(job_name   => 'example_job3',
                            job_type   => 'PLSQL_BLOCK',
                            job_action => 'BEGIN DBMS_LOCK.SLEEP(60); END;',
                            start_date => systimestamp,
                            enabled    => true);
end;
/

-- 2. Остановка этого работающего джоба с force = true
begin
  dbms_scheduler.stop_job('example_job3', force => true);
end;
/

-- 3. Удаление джоба
BEGIN
  DBMS_SCHEDULER.drop_job('example_job3');
END;
/

-- Запрос к системным представлениям для проверки статуса джоба
select job_name
      ,state
      ,last_start_date
      ,last_run_duration
  from all_scheduler_jobs
 where job_name = 'EXAMPLE_JOB3';


---- Пример 4: Создание и запуск одноразового джоба с выводом сообщения "Hello world"

-- 1. Создание и запуск джоба
begin
  dbms_scheduler.create_job(job_name   => 'example_job4',
                            job_type   => 'PLSQL_BLOCK',
                            job_action => 'BEGIN DBMS_OUTPUT.PUT_LINE(''Hello world''); END;',
                            start_date => systimestamp,
                            enabled    => true);
end;
/

-- Запрос к системным представлениям для проверки статуса джоба
select job_name
      ,state
      ,last_start_date
      ,run_duration
  from all_scheduler_jobs
 where job_name = 'EXAMPLE_JOB4';
