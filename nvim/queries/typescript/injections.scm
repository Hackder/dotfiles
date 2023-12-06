(call_expression
	function: (await_expression
    (member_expression
    	property: (property_identifier) @_name (#eq? @_name "$queryRaw")
    ))
	arguments: (template_string) @sql
  (#offset! @sql 0 1 0 -1))
