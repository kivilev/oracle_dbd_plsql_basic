create or replace package ut_utils_pack is

  -- Author  : D.KIVILEV
  -- Purpose : Движок для реализации Unit-тестов

  -- Запуск тестов
  procedure run_tests(p_package_name user_objects.object_name%type := null);

end;
/
