create or replace package body common_pack is

  g_enable_manual_changes boolean := false; -- включен ли флажок возможности "ручных" изменений

  procedure enable_manual_changes is
  begin
    -- здесь должна логироваться в спец таблицу информация по тому кто изменил этот флажок
    g_enable_manual_changes := true;
  end;

  procedure disable_manual_changes is
  begin
    -- здесь должна логироваться в спец таблицу информация по тому кто изменил этот флажок
    g_enable_manual_changes := false;
  end;

  function is_manual_change_allowed return boolean is
  begin
    return g_enable_manual_changes;
  end;

end common_pack;
/
