create or replace package app_util is

   /**
     Generic Utilities
     
     These should not depend on application specific objects like tables or packages

   */

   -- Tag type 
   type tag_type is record(
         tag   varchar2(100),
         value varchar2(100)
      );
   -- List of tags table 
   type tags_table is table of tag_type;
  
   /**
     Convert tags defined in a string into a table with two columns: TAG and VALUE

     #param p_tags            String defining set of tags with optional values
                              name=abc,system,readOnly=0
     #param p_tag_delimiter   Single character to separate tags
     #param p_value_delimiter Single character to assign value to a tag (optional)
     
     select tag, value from table(app_util.tags_as_table('color=red,readOnly,hidden,name=Colour'))
     
     TAG       VALUE
     -------------------
     color     red
     readOnly
     hidden
     name      Colour
   */

   function tags_as_table(
      p_tags            in varchar2,
      p_tag_delimiter   in varchar2 default ',',
      p_value_delimiter in varchar2 default '='
   ) return tags_table
      pipelined;

end app_util;
/