/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 23. Расписания
  
  Описание скрипта: современный/актуальный способ создания джобов
  
  Необходимые разрешения
  grant create job, manage scheduler to hr;
  grant execute on dbms_scheduler to hr;
  grant create external job to hr;
  
*/


---- Пример 1. Полный цикл управления джобом
-- 1. Создание выключенного джоба
begin
  dbms_scheduler.create_job(job_name   => 'example_job1', -- название джоба
                            job_type   => 'PLSQL_BLOCK', -- тип действия
                            job_action => q'$
                                            BEGIN
                                             dbms_output.put_line('hey1!'); 
                                             dbms_session.sleep(10); 
                                            end;$', -- само действие
                            start_date => systimestamp, -- когда будет активирован/запущен
                            repeat_interval => 'FREQ=SECONDLY; INTERVAL=40',
                            enabled    => false, -- включен ли сразу
                            auto_drop  => false  -- не удалится после выполнения
                            );
end;
/

--  Запрос к системным представлениям для проверки статуса джоба
select sysdate, job_name, state, t.start_date, t.next_run_date, t.*
  from all_scheduler_jobs t
 where job_name = 'EXAMPLE_JOB1';

select sysdate, job_name, t.*
  from all_scheduler_running_jobs t
 where job_name = 'EXAMPLE_JOB1';

select sysdate, job_name, t.*
  from all_scheduler_job_log t
 where job_name = 'EXAMPLE_JOB1';

select sysdate, job_name, t.*
  from all_scheduler_job_run_details t
 where job_name = 'EXAMPLE_JOB1';


-- 2. Включение джоба
begin
  dbms_scheduler.enable('example_job1');
end;
/

-- 3. Запуск джоба вручную
begin
  dbms_scheduler.run_job('example_job1', use_current_session => false);
end;
/

-- 4. Остановка джоба
begin
  dbms_scheduler.stop_job('example_job1', force => true);
end;
/

-- 5. Удаление джоба
begin
  dbms_scheduler.drop_job('example_job1', force => true);
end;
/


---- Пример 2. Создание, включение и запуск в одном флаконе
create or replace procedure test_job_proc is
begin
  dbms_session.sleep(10);
  dbms_output.put_line('hey2!');
end;
/

-- 1. Создание задачи с автоматическим стартом через 10 секунд и повторением каждые 30 секунд
begin
  dbms_scheduler.create_job(job_name        => 'example_job2',
                            job_type        => 'STORED_PROCEDURE',
                            job_action      => 'test_job_proc',
                            start_date      => systimestamp + interval '10'
                                               second,
                            repeat_interval => 'FREQ=SECONDLY; INTERVAL=30',
                            enabled         => true,
                            auto_drop       => false);
end;
/

-- Запрос к системным представлениям для проверки статуса джоба

select sysdate, job_name, state, t.start_date, t.next_run_date, t.*
  from all_scheduler_jobs t
 where job_name = 'EXAMPLE_JOB2';

select job_name, t.*
  from all_scheduler_running_jobs t
 where job_name = 'EXAMPLE_JOB2';

select job_name, t.*
  from all_scheduler_job_log t
 where job_name = 'EXAMPLE_JOB2';

select job_name, t.*
  from all_scheduler_job_run_details t
 where job_name = 'EXAMPLE_JOB2';


-- 2. Удаление джоба
begin
  dbms_scheduler.drop_job('example_job2', force => false);
end;
/


---- Пример 3. Создание и запуск одноразового джоба с выводом сообщения "Hello world"

-- 1. Создание и запуск джоба
begin
  dbms_scheduler.create_job(job_name   => 'EXAMPLE_JOB6',
                            job_type   => 'PLSQL_BLOCK',
                            job_action => 'BEGIN DBMS_OUTPUT.PUT_LINE(''Hello world''); END;',
                            start_date => systimestamp,
                            enabled    => true,
                            auto_drop  => true);
end;
/

-- Запрос к системным представлениям для проверки статуса джоба
select job_name, state, t.*
  from all_scheduler_jobs t
 where job_name = 'EXAMPLE_JOB6';

select job_name, t.*
  from all_scheduler_running_jobs t
 where job_name = 'EXAMPLE_JOB6';

select job_name, t.*
  from all_scheduler_job_log t
 where job_name = 'EXAMPLE_JOB6';

select job_name, t.*
  from all_scheduler_job_run_details t
 where job_name = 'EXAMPLE_JOB6';
 
