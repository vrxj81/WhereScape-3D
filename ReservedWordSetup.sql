  -- =============================================================================
  -- DBMS Name      :    Any
  -- Script Name    :    ReservedWordSetup.sql
  -- Description    :    Setup instructions, SQL & XML snippets to create a 
  --                     reserved word model rule.
  -- Created on     :    March, 13, 2018
  -- Author         :    Jack Howard
  -- =============================================================================
  -- Notes
  -- 
  -- History
  -- 1.0 Initial Version
  --
  -- Comments
  -- Use the custom report to identify reserved words in tables and columns 
  -- Customers have a wide variety of standards to deal with a reserved word.
  -- The rule will change the reserved word by appending a ### to a discovered 
  -- reserved word.  A post process rule converts the ### to the desired name.

  --========================================================
  -- Optional:  Create Translate Table used by the query
  --========================================================
  -- I used the Teradata view in syslib.sqlrestrictedwords
  -- Create this table if you are on an alternative database
  
  CREATE TABLE name_translate
  (
   SQLRestrictedWord	VARCHAR(150) NOT NULL
   ,TargetWord			VARCHAR(150) NOT NULL
  )
  ;
  --========================================================
  -- Create XML for the rule
  --========================================================
-- The text that builds the xml is case *sensitive*
-- The query to build the rule individual rule.
-- To use name_translate change the From clause.
SELECT
'            <rule type="reserved-words">
              <rule_attribute name="match">' || Trim(Lower(restricted_word)) || '</rule_attribute>
              <rule_attribute name="exact-match">T</rule_attribute>
              <rule_attribute name="case-sensitive">F</rule_attribute>
              <rule_attribute name="action">Rename</rule_attribute>
              <rule_attribute name="action-rename">' || Trim(Lower(restricted_word)) || '###</rule_attribute>
            </rule>' AS rule
FROM syslib.sqlrestrictedwords
ORDER BY restricted_word;
;


-- The XML Header to the rule
-- You may want to change this <transformation name="CheckReservedWordsInAttributes"> to a different name.
-- Copy the header to a new file
<?xml version="1.0" encoding="UTF-8"?>
<source_system xmlns="http://www.wherescape.com/xml/3D" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.wherescape.com/xml/3D ./source_system_34.xsd">
  <xml_version>34</xml_version>
  <structure>
    <tables />
    <relations />
    <transformations>
      <transformation name="CheckReservedWordsInAttributes">
        <rules>
          <rule name="ReservedWordCheck" type="naming-standard" enabled="true" snapshot="false">
            <rule_attribute name="apply-on">Attribute</rule_attribute>
            <rule_attribute name="standard">None</rule_attribute>
--
--  Paste Query Results here to the new file
--

-- The XML Footer
-- Copy the footer to the new file.
</rule>
</rules>
</transformation>
</transformations>
</structure>
</source_system>