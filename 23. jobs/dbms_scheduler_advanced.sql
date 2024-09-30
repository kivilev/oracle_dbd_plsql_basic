/*
  Курс: PL/SQL.Basic
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 23. Расписания
  
  Описание скрипта: расширенное использование расписаний 
*/

---- Пример 1. Создание цепочки
-- task2_procedure начнёт выполняться только после успешного завершения task1_procedure.

begin
  -- Создаём цепочку
  dbms_scheduler.create_chain(chain_name          => 'data_processing_chain',
                              rule_set_name       => null,
                              evaluation_interval => null);

  -- Добавляем задачи в цепочку
  dbms_scheduler.define_chain_step('data_processing_chain',
                                   'step1',
                                   'task1_procedure');
  dbms_scheduler.define_chain_step('data_processing_chain',
                                   'step2',
                                   'task2_procedure');

  -- Устанавливаем зависимости
  dbms_scheduler.define_chain_rule('data_processing_chain',
                                   'TRUE',
                                   'step1');
  dbms_scheduler.define_chain_rule('data_processing_chain',
                                   'step1 COMPLETED',
                                   'step2');

  -- Активируем цепочку
  dbms_scheduler.enable('data_processing_chain');
end;
/


---- Пример 2. Использование общих расписаний (Schedules)
-- расписание weekly_schedule можно использовать при создании любых задач.

begin
  dbms_scheduler.create_schedule(schedule_name   => 'weekly_schedule',
                                 repeat_interval => 'FREQ=WEEKLY; BYDAY=MON; BYHOUR=8;',
                                 start_date      => systimestamp);
end;
/


---- Пример 3. Запуск внешних программ и скриптов
--  задача daily_backup_job будет запускать скрипт backup.sh каждый день в 23:00.

begin
  dbms_scheduler.create_program(program_name   => 'run_backup_script',
                                program_type   => 'EXECUTABLE',
                                program_action => '/usr/local/bin/backup.sh',
                                enabled        => true);

  dbms_scheduler.create_job(job_name        => 'daily_backup_job',
                            program_name    => 'run_backup_script',
                            repeat_interval => 'FREQ=DAILY; BYHOUR=23;',
                            enabled         => true);
end;
/


---- Пример 4. Использование окон планирования (Windows)
-- это окно будет открываться каждый день в 22:00 и оставаться активным 4 часа.

begin
  dbms_scheduler.create_window(window_name     => 'off_peak_hours',
                               resource_plan   => 'DEFAULT_PLAN',
                               repeat_interval => 'FREQ=DAILY; BYHOUR=22; BYMINUTE=0; DURATION=4:00',
                               enabled         => true);
end;
/

