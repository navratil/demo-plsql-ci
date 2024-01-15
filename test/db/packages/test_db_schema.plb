create or replace package body test_db_schema as

   -----------------------------------------------------------------------------
   -- PRIVATE
   -----------------------------------------------------------------------------

   function get_number_of_invalid_objects(p_type in varchar2) return number is
      l_invalid_objects number;
   begin
      select count(*) into l_invalid_objects
        from user_objects
       where object_type = p_type
         and status != 'VALID';
      return l_invalid_objects;
   end;
  
   -----------------------------------------------------------------------------
   -- PUBLIC
   -----------------------------------------------------------------------------

   procedure all_types_are_valid is
   begin
      ut.expect(get_number_of_invalid_objects('TYPE')).to_equal(0);
   end;

   procedure all_tables_are_valid is
   begin
      ut.expect(get_number_of_invalid_objects('TABLE')).to_equal(0);
      ut.expect(get_number_of_invalid_objects('SEQUENCE')).to_equal(0);
   end;

   procedure all_indexes_are_valid is
   begin
      ut.expect(get_number_of_invalid_objects('INDEX')).to_equal(0);
      ut.expect(get_number_of_invalid_objects('LOB')).to_equal(0);
   end;

   procedure all_triggers_are_valid is
   begin
      ut.expect(get_number_of_invalid_objects('TRIGGER')).to_equal(0);
   end;

   procedure all_packages_are_valid is
   begin
      ut.expect(get_number_of_invalid_objects('PACKAGE')).to_equal(0);
      ut.expect(get_number_of_invalid_objects('PACKAGE BODY')).to_equal(0);
   end;

end test_db_schema;
/