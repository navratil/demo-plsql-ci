create or replace package test_app_util as 

   --%suite("Package APP_UTIL")

   --%test("Tags as strings conversions")
   procedure tags_as_strings;

   --%test("Test format function")
   procedure format;   

end test_app_util;
/