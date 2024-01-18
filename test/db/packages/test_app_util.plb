create or replace package body test_app_util as

   procedure tags_as_strings as
      l_tag   app_util.tag_type;
      l_count number;
   begin
      -- test empty definitions
      select count(*) into l_count from table(app_util.tags_as_table(null));
      ut.expect(l_count).to_equal(0);

      select count(*) into l_count from table(app_util.tags_as_table(' '));
      ut.expect(l_count).to_equal(0);

      select count(*) into l_count from table(app_util.tags_as_table(' ,, , '));
      ut.expect(l_count).to_equal(0);

      -- test 
      select tag, value into l_tag.tag, l_tag.value
        from table(app_util.tags_as_table('name=abc,system,readOnly=0 '))
       where tag = 'name';
      ut.expect(l_tag.value).to_equal('abc');

      select tag, value into l_tag.tag, l_tag.value
        from table(app_util.tags_as_table('name=abc,system,,readOnly=0 '))
       where tag = 'system';
      ut.expect(l_tag.value).to_be_null;

      select tag, value into l_tag.tag, l_tag.value
        from table(app_util.tags_as_table('name=abc,system=,,readOnly=0 '))
       where tag = 'system';
      ut.expect(l_tag.value).to_be_null;

      select tag, value into l_tag.tag, l_tag.value
        from table(app_util.tags_as_table('name=abc,system= ,,readOnly=0 '))
       where tag = 'system';
      ut.expect(l_tag.value).to_equal(' ');
   end;

   procedure format as
      l_tag   app_util.tag_type;
      l_count number;
   begin
     ut.expect(app_util.format(null, '123')).to_be_null;
     ut.expect(app_util.format('%0%1%2')).to_be_null;
     ut.expect(app_util.format('Error #%1', 'ABC', '123', 'XYZ')).to_equal('Error #123');
     ut.expect(app_util.format('Hello %1.%0.%2.%2', 'ABC', '123', 'XYZ')).to_equal('Hello 123.ABC.XYZ.XYZ');
   end;


end test_app_util;
/