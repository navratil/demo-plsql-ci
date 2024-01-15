create or replace package body test_app_parameter as

   c_param  constant varchar2(100) := 'ut.app.mode';
   c_param2 constant varchar2(100) := 'ut.app.size';
   c_param3 constant varchar2(100) := 'ut.app.readOnly';
   c_param4 constant varchar2(100) := 'ut.app.errorCounter';
   c_name1  constant varchar2(100) := 'Application Mode';
   c_name2  constant varchar2(100) := 'Application Size';
   c_name3  constant varchar2(100) := 'New Application Mode';
   c_name4  constant varchar2(100) := 'System Error Counter';
   c_tags_0 constant varchar2(100) := ',,';
   c_tags_3 constant varchar2(100) := 'readOnly=true,hidden,system:';

   procedure define_string_parameters as
      l_name  varchar2(2000);
      l_count number;
   begin
      -- define new param
      app_parameter.define_string(c_param, c_name1, 'TEST or PROD', c_tags_3);
      select display_name into l_name
        from app_parameters
       where parameter = c_param;
      ut.expect(l_name).to_equal(c_name1);
      select display_name into l_name
        from app_parameters
       where parameter = c_param;
      -- define new param
      app_parameter.define_string(c_param2, c_name2, 'S/M/L/XL');
      select display_name into l_name
        from app_parameters
       where parameter = c_param2;
      ut.expect(l_name).to_equal(c_name2);
      -- update existing
      app_parameter.define_string(c_param, c_name3, 'TEST or PROD or DEV', c_tags_3);
      select display_name into l_name
        from app_parameters
       where parameter = c_param;
      ut.expect(l_name).to_equal(c_name3);
      select count(*) into l_count
        from app_parameter_tags
       where app_parameter_id = (select id from app_parameters where parameter = c_param);
      ut.expect(l_count, 'Mismatch in number of TAGS').to_equal(3);
      -- try to define as Boolean 
      app_parameter.define_boolean(c_param, c_name2, '???');
   end define_string_parameters;

   procedure define_boolean_parameters as
      l_name  varchar2(2000);
      l_count number;
   begin
      -- define new param
      app_parameter.define_boolean(c_param, c_name1, 'On/Off', c_tags_3);
      select display_name into l_name
        from app_parameters
       where parameter = c_param;
      ut.expect(l_name).to_equal(c_name1);
      -- update existing
      app_parameter.define_boolean(c_param, c_name2, '?', c_tags_0);
      select display_name into l_name
        from app_parameters
       where parameter = c_param;
      ut.expect(l_name).to_equal(c_name2);
      select count(*) into l_count
        from app_parameter_tags
       where app_parameter_id = (select id from app_parameters where parameter = c_param);
      ut.expect(l_count, 'Mismatch in number of TAGS').to_equal(0);
      -- try to define as String
      app_parameter.define_string(c_param, c_name2, '???');
   end define_boolean_parameters;

   procedure get_set_string is
      l_value varchar2(2000);
      l_count number;
   begin
      delete from app_parameters where parameter = c_param;
      -- create with default = DEF
      app_parameter.define_string(c_param, c_name1, 'n/a', c_tags_3, 'DEF');
      l_value := app_parameter.get_string(c_param);
      ut.expect(l_value).to_equal('DEF');
      -- set to ABC & stays after another define call
      app_parameter.set_string(c_param, 'ABC');
      app_parameter.define_string(c_param, c_name1, 'n/a', c_tags_3, 'DEF');
      l_value := app_parameter.get_string(c_param);
      ut.expect(l_value).to_equal('ABC');
      -- set to NULL
      app_parameter.set_string(c_param, null);
      l_value := app_parameter.get_string(c_param);
      ut.expect(l_value).to_be_null;
   end;

   procedure lov_string is
      l_value       varchar2(100);
      l_description varchar2(200);
      l_count       number;
   begin
      -- LIST with codes only
      app_parameter.define_string(c_param, c_name1, 'TEST/PROD', c_tags_3, null,
                                  'LIST=TEST,PROD');
      select count(*) into l_count from table(app_parameter.string_lov(c_param));
      ut.expect(l_count).to_equal(2);
      -- LIST with descriptions
      app_parameter.define_string(c_param, c_name1, 'Color', c_tags_3, null,
                                  'LIST=B:Black,W:White,R:Red');
      select count(*) into l_count from table(app_parameter.string_lov(c_param));
      ut.expect(l_count).to_equal(3);
      -- SQL
      app_parameter.define_string(c_param, c_name1, 'TEST or PROD', c_tags_3, null,
                                  'SQL=SELECT parameter, display_name FROM app_parameters WHERE parameter = '''
         || c_param
         || ''' ');
      select description into l_value from table(app_parameter.string_lov(c_param));
      ut.expect(l_value).to_equal(c_name1);
   end;

   procedure get_set_boolean is
      l_value  boolean;
      l_number number;
      l_count  number;
   begin
      delete from app_parameters where parameter = c_param3;
      -- define with default = FALSE
      app_parameter.define_boolean(c_param3, c_name3, 'On/Off', c_tags_3, false);
      l_value  := app_parameter.get_boolean(c_param3);
      ut.expect(l_value).to_equal(false);
      -- change to TRUE
      app_parameter.set_boolean(c_param3, true);
      l_value  := app_parameter.get_boolean(c_param3);
      ut.expect(l_value).to_equal(true);
      -- retrieve value as a NUMBER
      l_number := app_parameter.get_number(c_param3);
      ut.expect(l_number).to_equal(1);
      -- change to NULL
      app_parameter.set_boolean(c_param3, null);
      app_parameter.define_boolean(c_param3, c_name3, 'On/Off', c_tags_3, false);
      l_value  := app_parameter.get_boolean(c_param3);
      ut.expect(l_value).to_be_null;
   end;

   procedure get_set_number is
      l_value number;
      l_count number;
   begin
      -- define with default = 0
      app_parameter.define_number(c_param4, c_name4, 'Lorem ipsum ...', c_tags_3, 0);
      l_value := app_parameter.get_number(c_param4);
      ut.expect(l_value).to_equal(0);
      -- change to 123
      app_parameter.set_number(c_param4, 123);
      app_parameter.define_number(c_param4, c_name4, 'Lorem ipsum ...', c_tags_3, 0);
      l_value := app_parameter.get_number(c_param4);
      ut.expect(l_value).to_equal(123);
   end;

end test_app_parameter;
/