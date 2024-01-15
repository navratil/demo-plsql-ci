create or replace package body app_util as

   --------------------------------------------------------------------------------
   -- PRIVATE
   --------------------------------------------------------------------------------

   --------------------------------------------------------------------------------
   -- PUBLIC
   --------------------------------------------------------------------------------

   function tags_as_table(
      p_tags            in varchar2,
      p_tag_delimiter   in varchar2,
      p_value_delimiter in varchar2
   ) return tags_table
      pipelined
   is
      l_last        number := 0;
      l_value_start number;
      l_token       varchar2(1000);
      l_tag         tag_type;
   begin
      if p_tags is not null then
         for l_idx in 1..length(p_tags) + 1
         loop
            if substr(p_tags || p_tag_delimiter, l_idx, 1) = p_tag_delimiter then
               l_token       := substr(p_tags, l_last + 1, l_idx - l_last - 1);
               l_value_start := instr(l_token, p_value_delimiter);
               if l_value_start = 0 then
                  l_tag.tag   := l_token;
                  l_tag.value := null;
               else
                  l_tag.tag   := substr(l_token, 1, l_value_start - 1);
                  l_tag.value := substr(l_token, l_value_start + 1);
               end if;
               l_last        := l_idx;
               -- pipe row 
               if trim(l_tag.tag) is not null then
                  pipe row(l_tag);
               end if;
            end if;
         end loop;
      end if;
   end;

end app_util;
/