create or replace package test_db_schema as 

   --%suite("Test Database Schema")

   --%test("All types are valid")
   procedure all_types_are_valid;

   --%test("All tables are valid")
   procedure all_tables_are_valid;

   --%test("All indexes are valid")
   procedure all_indexes_are_valid;

   --%test("All triggers are valid")
   procedure all_triggers_are_valid;

   --%test("All packages are valid")
   procedure all_packages_are_valid;

end test_db_schema;
/