create or replace package test_app_parameter as 

   --%suite("Package APP_PARAMETER")

   --%test("Define STRING parameters")
   --%throws(-20103)
   procedure define_string_parameters;

   --%test("Define BOOLEAN parameters")
   --%throws(-20103)
   procedure define_boolean_parameters;
  
   --%test("Get and Set STRING parameters")
   procedure get_set_string;  

   --%test("LOV for STRING parameters")
   procedure lov_string;  
  
   --%test("Get and Set NUMBER parameters")
   procedure get_set_number;    

   --%test("Get and Set BOOLEAN parameters")
   procedure get_set_boolean;

end test_app_parameter;
/