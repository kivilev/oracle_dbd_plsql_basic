create or replace package body ut_utils_pack is

  procedure run_tests(p_package_name user_objects.object_name%type := null) is
    v_full_prc_name varchar2(300 char);
  begin
    <<packages_loop>>
    for p in (select distinct lower(t.name) package_name
                from user_source t
               where t.text like '%--%suite%'
                 and (upper(t.name) = upper(p_package_name) or
                     p_package_name is null)
                 and t.type = 'PACKAGE'
               order by 1) loop
    
      dbms_output.put_line('=== Тесты в пакете: ' || p.package_name);
    
      <<tests_loop>>
      for ut in (select trim(replace(replace(replace((s2.text),
                                                     'procedure',
                                                     ''),
                                             ';',
                                             ''),
                                     chr(10),
                                     '')) procedure_name
                       ,trim(replace(replace(s.text, '--%test(', ''),
                                     ')' || chr(10),
                                     '')) test_name
                   from user_source s
                   join user_source s2
                     on s2.name = s.name
                    and s.type = s2.type
                    and s.line + 1 = s2.line
                    and s2.type = 'PACKAGE'
                  where s.text like '%--%test%'
                    and s.type = 'PACKAGE'
                    and upper(s.name) = upper(p.package_name)
                  order by s2.line) loop
        begin
        
          savepoint sp1;
          
          v_full_prc_name := p.package_name || '.' || ut.procedure_name;
          execute immediate 'begin ' || v_full_prc_name || '; end;';
        
          dbms_output.put_line('Тест "' || ut.test_name ||
                               '" успешно прошел =)');
        
          rollback to sp1;
        
        exception
          when others then
            rollback to sp1;
            dbms_output.put_line('Тест "' || ut.test_name ||
                                 '" не был пройден.');
            dbms_output.put_line(chr(9) || 'Возникла ошибка в ' ||
                                 v_full_prc_name || '. Errm: ' || sqlerrm);
        end;
      
      end loop tests_loop;
    
    end loop packages_loop;
  
    rollback;
  end;

end;
/
