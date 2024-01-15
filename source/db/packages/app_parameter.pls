create or replace package app_parameter is

   /**
     Application Parameters (global)

     Define and Get/Set API global application parameters 
     Actual parameters are stored in the APP_PARAMETERS and APP_PARAMETER_TAGS tables
   */

   -- LOV lookup table row 
   type string_lov_type is record(
         description varchar2(200),
         value       varchar2(100)
      );
   -- LOV lookup table 
   type string_lov_table is table of string_lov_type;
  
   /**
     Define a string (VARCHAR2) parameter

     If parameter with the same code and type exists all other attributes are updated.

     #param p_parameter      Unique case sensitive alphanumeric paramater code
     #param p_display_name   Visible name
     #param p_description    Long description of the namespace (up to 1000 characters)
     #param p_lov            Define static list of values for the parameter either a static list (LIST) or dynamic (SQL)
                             LIST=Black,White,Red
                             LIST=B:Black,W:White,R:Red
                             SQL=SELECT description, value FROM t ORDER BY description
     #param p_default        Default value
   */

   procedure define_string(p_parameter    in varchar2,
                           p_display_name in varchar2,
                           p_description  in varchar2 default null,
                           p_tags         in varchar2 default null,
                           p_default      in varchar2 default null,
                           p_lov          in varchar2 default null);

   /**
     Define a numeric parameter

     If parameter with the same code and type exists all other attributes are updated.

     #param p_parameter      Unique case sensitive alphanumeric paramater code
     #param p_display_name   Visible name
     #param p_description    Long description of the namespace (up to 1000 characters)
     #param p_default        Default value
   */
   procedure define_number(p_parameter    in varchar2,
                           p_display_name in varchar2,
                           p_description  in varchar2,
                           p_tags         in varchar2 default null,
                           p_default      in number   default null);
                                         
   /**
     Define a boolean parameter

     If parameter with the same code and type exists all other attributes are updated.

     #param p_parameter      Unique case sensitive alphanumeric paramater code
     #param p_display_name   Visible name
     #param p_description    Long description of the namespace (up to 1000 characters)
     #param p_default        Default value
   */
   procedure define_boolean(p_parameter    in varchar2,
                            p_display_name in varchar2,
                            p_description  in varchar2,
                            p_tags         in varchar2 default null,
                            p_default      in boolean  default null);

   -- Set value of a String parameter
   procedure set_string(p_parameter in varchar2,
                        p_value     in varchar2);

   -- Get value of a String parameter
   function get_string(p_parameter in varchar2) return varchar2
      result_cache;
  
   -- List of values for a String parameter
   function string_lov(p_parameter in varchar2)
      return string_lov_table
      pipelined;  

   -- Set value of a Numeric parameter
   procedure set_number(p_parameter in varchar2,
                        p_value     in number);

   -- Get value of a Numeric parameter
   function get_number(p_parameter in varchar2) return number
      result_cache;

   -- Set value of a Boolean parameter
   procedure set_boolean(p_parameter in varchar2,
                         p_value     in boolean);

   -- Get value of a Boolean parameter OR use get_number for 0 and 1 values
   function get_boolean(p_parameter in varchar2) return boolean
      result_cache;

   /** TODO : Add more parameter types 
     -- Set value of a Date parameter
     procedure set_date(p_parameter in varchar2, p_value in date);
     function get_date(p_parameter in varchar2) return date result_cache;
   
     -- Set value of an Image (BLOB) parameter
     procedure set_image(p_parameter in varchar2, p_value in blob);
     function get_image(p_parameter in varchar2) return blob;
   
   */

end app_parameter;
/