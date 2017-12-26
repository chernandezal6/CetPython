begin
  execute immediate 'grant execute on utl_file to public';
  execute immediate 'grant execute on utl_tcp to public';
  execute immediate 'grant execute on utl_smtp to public';
  execute immediate 'grant execute on utl_http to public'; 
  execute immediate 'grant execute on dbms_ddl to public';
  execute immediate 'grant select on v_$session to public';

  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL
  (
   acl => 'WEBSERVICE_JCE_CED.xml', -- or any other name
   description => 'HTTP Access',
   principal => 'SUIRPLUS', -- the user name trying to access the network resource
   is_grant => TRUE,
   privilege => 'connect',
   start_date => null,
   end_date => null
  );

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE
  (
   acl => 'WEBSERVICE_JCE_CED.xml',
   principal => 'SUIRPLUS',
   is_grant => true,
   privilege => 'connect'
  );

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE
  (
   acl => 'WEBSERVICE_JCE_CED.xml',
   principal => 'SUIRPLUS',
   is_grant => true,
   privilege => 'resolve'
  );  

  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL
  (
   acl => 'WEBSERVICE_JCE_CED.xml',
   host => '*.jce.gob.do', /*can be computer name or IP , wildcards are accepted as well for example - '*.us.oracle.com'*/
   lower_port => 8080,
   upper_port => 8080
  );
 
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL
  (
   acl => 'WEBSERVICE_JCE_NUI.xml', -- or any other name
   description => 'HTTP Access',
   principal => 'SUIRPLUS', -- the user name trying to access the network resource
   is_grant => TRUE,
   privilege => 'connect',
   start_date => null,
   end_date => null
  );

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE
  (
   acl => 'WEBSERVICE_JCE_NUI.xml',
   principal => 'SUIRPLUS',
   is_grant => true,
   privilege => 'connect'
  );

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE
  (
   acl => 'WEBSERVICE_JCE_NUI.xml',
   principal => 'SUIRPLUS',
   is_grant => true,
   privilege => 'resolve'
  );  

  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL
  (
   acl => 'WEBSERVICE_JCE_NUI.xml',
   host => '10.12.201.7', /*can be computer name or IP , wildcards are accepted as well for example - '*.us.oracle.com'*/
   lower_port => 8090,
   upper_port => 8090
  );

  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL
  (
   acl => 'PROXY.xml', -- or any other name
   description => 'HTTP Access',
   principal => 'SUIRPLUS', -- the user name trying to access the network resource
   is_grant => TRUE,
   privilege => 'connect',
   start_date => null,
   end_date => null
  );

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE
  (
   acl => 'PROXY.xml',
   principal => 'SUIRPLUS',
   is_grant => true,
   privilege => 'connect'
  );
 
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE
  (
   acl => 'PROXY.xml',
   principal => 'SUIRPLUS',
   is_grant => true,
   privilege => 'resolve'
  );  

  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL
  (
   acl => 'PROXY.xml',
   host => '172.16.5.38', /*can be computer name or IP , wildcards are accepted as well for example - '*.us.oracle.com'*/
   lower_port => 8080,
   upper_port => 8080
  );

  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL
  (
   acl => 'WS_COLANSS.xml', -- or any other name
   description => 'HTTP Access',
   principal => 'SUIRPLUS', -- the user name trying to access the network resource
   is_grant => TRUE,
   privilege => 'connect',
   start_date => null,
   end_date => null
  );
  
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE
  (
   acl => 'WS_COLANSS.xml',
   principal => 'SUIRPLUS',
   is_grant => true,
   privilege => 'connect'
  );
 
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE
  (
   acl => 'WS_COLANSS.xml',
   principal => 'SUIRPLUS',
   is_grant => true,
   privilege => 'resolve'
  );  

  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL
  (
   acl => 'WS_COLANSS.xml',
   host => 'cocker', /*can be computer name or IP , wildcards are accepted as well for example - '*.us.oracle.com'*/
   lower_port => 49204,
   upper_port => 49204
  );

  COMMIT;  
EXCEPTION
  WHEN OTHERS THEN
  	dbms_output.put_line('Error message was: ' || SQLERRM);  
end;
/
exit;