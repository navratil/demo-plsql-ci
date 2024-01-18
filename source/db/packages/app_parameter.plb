create or replace package body app_parameter as

   --------------------------------------------------------------------------------
   -- PRIVATE
   --------------------------------------------------------------------------------
   c_type_string  constant varchar2(10) := 'STRING';
   c_type_boolean constant varchar2(10) := 'BOOLEAN';
   c_type_number  constant varchar2(10) := 'NUMBER';
   c_type_date    constant varchar2(10) := 'DATE';
   c_type_blob    constant varchar2(10) := 'BLOB';
   c_type_clob    constant varchar2(10) := 'CLOB';

   c_error_parameter_not_found     constant number := -20101;
   c_error_parameter_not_found_msg constant varchar2(100) := 'Parameter "%0" not defined';
   c_error_param_not_updated       constant number := -20102;
   c_error_param_not_updated_msg   constant varchar2(100) := 'Parameter "%0" has not been updated!';
   c_error_param_type_change       constant number := -20103;
   c_error_param_type_change_msg   constant varchar2(100) := 'Parameter "%0" type can not be changed from "%1" to "%2"';
   c_error_lov_not_recognized      constant number := -20104;
   c_error_lov_not_recognized_msg  constant varchar2(100) := 'LOV type not recognized for parameter "%0"';


   function parameter_exists(p_parameter in varchar2,
                             p_type      in varchar2) return boolean
   is
      l_type app_parameters.parameter_type%type;
   begin
      select parameter_type into l_type
        from app_parameters
       where parameter = p_parameter for update;
      if l_type = p_type then
         return true;
      else
         raise_application_error(c_error_param_type_change,
            app_util.format(c_error_param_type_change_msg, p_parameter, l_type, p_type));
      end if;
   exception
      when no_data_found then
         return false;
   end;

   procedure reset_tags(p_parameter in varchar2,
                        p_tags      in varchar2) is
      l_parameter_id app_parameter_tags.id%type;
   begin
      select id into l_parameter_id from app_parameters where parameter = p_parameter;
      -- remove existing tags that are not in p_tags
      delete from app_parameter_tags
       where id in (
                select id
                  from app_parameter_tags old_tags
                  left outer join app_util.tags_as_table(p_tags) new_tags
                    on new_tags.tag = old_tags.tag
                 where (new_tags.tag is null)
                   and (old_tags.app_parameter_id = l_parameter_id)
             );
      -- add new tags from p_tags
      merge into app_parameter_tags ot
       using app_util.tags_as_table(p_tags) nt
       on ((ot.tag = nt.tag) and (ot.app_parameter_id = l_parameter_id))
      when matched then
        update set ot.value = nt.value where ot.value != nt.value
      when not matched then
        insert (ot.app_parameter_id, ot.tag, ot.value) values (l_parameter_id, nt.tag, nt.value);
   end;

   procedure create_parameter(p_parameter      in varchar2,
                              p_type           in varchar2,
                              p_display_name   in varchar2,
                              p_description    in varchar2,
                              p_tags           in varchar2,
                              p_lov            in varchar2 default null,
                              p_default_string in varchar2 default null,
                              p_default_number in number   default null) is
   begin
      insert into app_parameters(
         parameter,
         parameter_type,
         display_name,
         description,
         value_string,
         value_number,
         lov
      )
      values(
         p_parameter,
         p_type,
         p_display_name,
         p_description,
         p_default_string,
         p_default_number,
         p_lov
      );
      reset_tags(p_parameter, p_tags);
   end;

   procedure update_parameter(p_parameter    in varchar2,
                              p_type         in varchar2,
                              p_display_name in varchar2,
                              p_description  in varchar2,
                              p_tags         in varchar2,
                              p_lov          in varchar2 default null) is
   begin
      update app_parameters set display_name = p_display_name,
             description = p_description,
             lov = p_lov
       where (parameter = p_parameter)
         and (parameter_type = p_type);
      reset_tags(p_parameter, p_tags);
   end;
  
   --------------------------------------------------------------------------------
   -- PUBLIC
   --------------------------------------------------------------------------------

   procedure define_string(p_parameter    in varchar2,
                           p_display_name in varchar2,
                           p_description  in varchar2,
                           p_tags         in varchar2,
                           p_default      in varchar2,
                           p_lov          in varchar2
   ) as
      l_type constant varchar2(20) := c_type_string;
   begin
      if parameter_exists(p_parameter, l_type) then
         update_parameter(
            p_parameter    => p_parameter,
            p_type         => l_type,
            p_display_name => p_display_name,
            p_description  => p_description,
            p_tags         => p_tags,
            p_lov          => p_lov
         );
      else
         create_parameter(
            p_parameter      => p_parameter,
            p_type           => l_type,
            p_display_name   => p_display_name,
            p_description    => p_description,
            p_tags           => p_tags,
            p_default_string => p_default,
            p_lov            => p_lov
         );
      end if;
   end define_string;

   procedure define_number(p_parameter    in varchar2,
                           p_display_name in varchar2,
                           p_description  in varchar2,
                           p_tags         in varchar2,
                           p_default      in number) as
      l_type constant varchar2(20) := c_type_number;
   begin
      if parameter_exists(p_parameter, l_type) then
         update_parameter(
            p_parameter    => p_parameter,
            p_type         => l_type,
            p_display_name => p_display_name,
            p_description  => p_description,
            p_tags         => p_tags
         );
      else
         create_parameter(
            p_parameter      => p_parameter,
            p_type           => l_type,
            p_display_name   => p_display_name,
            p_description    => p_description,
            p_tags           => p_tags,
            p_default_number => p_default
         );
      end if;
   end define_number;

   procedure define_boolean(p_parameter    in varchar2,
                            p_display_name in varchar2,
                            p_description  in varchar2,
                            p_tags         in varchar2,
                            p_default      in boolean) as
      l_type constant varchar2(20) := c_type_boolean;
   begin
      if parameter_exists(p_parameter, l_type) then
         update_parameter(
            p_parameter    => p_parameter,
            p_type         => l_type,
            p_display_name => p_display_name,
            p_description  => p_description,
            p_tags         => p_tags
         );
      else
         create_parameter(
            p_parameter      => p_parameter,
            p_type           => l_type,
            p_display_name   => p_display_name,
            p_description    => p_description,
            p_tags           => p_tags,
            p_default_number => sys.diutil.bool_to_int(p_default)
         );
      end if;
   end define_boolean;
  
   -- GET / SET methods

   procedure set_string(p_parameter in varchar2,
                        p_value     in varchar2) as
   begin
      update app_parameters set value_string = p_value
       where parameter = p_parameter
         and parameter_type = c_type_string;
      if sql%rowcount <> 1 then
         raise_application_error(c_error_param_not_updated, app_util.format(c_error_param_not_updated_msg, p_parameter));
      end if;
   end set_string;

   function get_string(p_parameter in varchar2) return varchar2
      result_cache
   as
      l_value app_parameters.value_string%type;
   begin
      select value_string into l_value
        from app_parameters
       where parameter = p_parameter
         and parameter_type = c_type_string;
      return l_value;
   end get_string;

   function string_lov(p_parameter in varchar2)
      return string_lov_table
      pipelined
   is
      p_field_delimiter constant varchar2(1) := ',';
      p_desc_delimiter  constant varchar2(1) := ':';
      l_last            number               := 0;
      l_now             number               := 1;
      l_value_start     number;
      l_string          app_parameters.lov%type;
      l_token           app_parameters.lov%type;
      l_row             string_lov_type;
      l_select          app_parameters.lov%type;
      l_refcur          sys_refcursor;
   begin
      -- fetch LOV
      select lov
        into l_string
        from app_parameters
       where parameter = p_parameter
         and parameter_type = c_type_string;
      -- parsing loop
      if substr(l_string, 1, 5) = 'LIST=' then
         -- Static LOV
         l_string := substr(l_string, 6) || p_field_delimiter;

         for i in 1..length(l_string)
         loop
            if substr(l_string, i, 1) = p_field_delimiter then
               l_now         := i;
               l_token       := substr(l_string, l_last + 1, l_now - l_last - 1);
               l_value_start := instr(l_token, p_desc_delimiter);
               if l_value_start = 0 then
                  l_row.description := l_token;
                  l_row.value       := l_token;
               else
                  l_row.value       := substr(l_token, 1, l_value_start - 1);
                  l_row.description := substr(l_token, l_value_start + 1);
               end if;
               l_last        := l_now;
               pipe row(l_row);
            end if;
         end loop;
      elsif (substr(l_string, 1, 4) = 'SQL=') then
         -- Dynamic LOV
         if trim(substr(l_string, 5)) is not null then
            l_select := substr(l_string, 5);
            open l_refcur for l_select;
            loop
               fetch l_refcur
                  into l_row.value,
                       l_row.description;
               exit when l_refcur%notfound;
               pipe row(l_row);
            end loop;
            close l_refcur;
         end if;
      else
         raise_application_error(c_error_lov_not_recognized, 
            app_util.format(c_error_lov_not_recognized_msg, p_parameter));
      end if;
   exception
      when no_data_found then
         raise_application_error(c_error_parameter_not_found, 
            app_util.format(c_error_parameter_not_found_msg, p_parameter));
   end string_lov;

   procedure set_number(p_parameter in varchar2,
                        p_value     in number) as
   begin
      update app_parameters set value_number = p_value
       where parameter = p_parameter
         and parameter_type = c_type_number;
      if sql%rowcount <> 1 then
         raise_application_error(c_error_param_not_updated,
            app_util.format(c_error_param_not_updated_msg, p_parameter));
      end if;
   end set_number;

   function get_number(p_parameter in varchar2) return number
      result_cache
   as
      l_value app_parameters.value_number%type;
   begin
      select value_number into l_value
        from app_parameters
       where (parameter = p_parameter)
         and (parameter_type = c_type_boolean or parameter_type = c_type_number);
      return l_value;
   end get_number;

   procedure set_boolean(p_parameter in varchar2,
                         p_value     in boolean) as
      l_value number;
   begin
      l_value := sys.diutil.bool_to_int(p_value);
      update app_parameters set value_number = l_value
       where parameter = p_parameter
         and parameter_type = c_type_boolean;
      if sql%rowcount <> 1 then
          raise_application_error(c_error_param_not_updated, 
            app_util.format(c_error_param_not_updated_msg, p_parameter));
     end if;
   end set_boolean;

   function get_boolean(p_parameter in varchar2) return boolean
      result_cache
   as
      l_value app_parameters.value_number%type;
   begin
      select value_number into l_value
        from app_parameters
       where parameter = p_parameter
         and parameter_type = c_type_boolean;
      return (l_value = 1);
   end get_boolean;

end app_parameter;
/