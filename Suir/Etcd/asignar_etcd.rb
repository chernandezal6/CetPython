require 'etcd'

begin

	etcd_server = "box"
	client = Etcd.client(host: etcd_server, port: 2379)

	array = '['
	array << '{"teamcity_username":"Hector Mota","slack_username":"hector_mota","channel":"#gerencia-dti"},'
	array << '{"teamcity_username":"Gregorio Herrera","slack_username":"gherrera","channel":"#desarrollo"},'
	array << '{"teamcity_username":"Jose Taveras Rodriguez","slack_username":"etaveras05","channel":"#operaciones_alertas"},'
	array << '{"teamcity_username":"Ramon Pichardo","slack_username":"rpichardo9","channel":"#operaciones_alertas"},'
	array << '{"teamcity_username":"Pedro Vasquez","slack_username":"pedro_vasquez","channel":"#operaciones_alertas"},'
	array << '{"teamcity_username":"Cesar Duran","slack_username":"cduran","channel":"#seguridad"},'
	array << '{"teamcity_username":"Charlie Pena","slack_username":"cpena","channel":"#desarrollo"},'
	array << '{"teamcity_username":"Billy Urena","slack_username":"bilito65","channel":"#seguridad"},'
	array << '{"teamcity_username":"David Pineda","slack_username":"dpineda","channel":"#desarrollo"},'
	array << '{"teamcity_username":"Edward Ortiz","slack_username":"ortized","channel":"#seguridad"},'
	array << '{"teamcity_username":"Eury Vallejo","slack_username":"euryvallejo","channel":"#desarrollo"},'
	array << '{"teamcity_username":"Graciela Castro","slack_username":"gcastro","channel":"#operaciones_alertas"},'
	array << '{"teamcity_username":"Greiman Garcia","slack_username":"greiman_garcia","channel":"#dba"},'
	array << '{"teamcity_username":"Lucas Nicolás Mejía","slack_username":"lucas_mejia","channel":"#operaciones_alertas"},'
	array << '{"teamcity_username":"Roberto Carlos Jáquez Rivera","slack_username":"rjaquez","channel":"#operaciones_alertas"},'
	array << '{"teamcity_username":"Samil Castillo","slack_username":"scastillo","channel":"#seguridad"},'
	array << '{"teamcity_username":"Wander Moreta Rivas","slack_username":"wmoreta","channel":"#seguridad"},'
	array << '{"teamcity_username":"Kerlin De La Cruz","slack_username":"kcruz","channel":"#desarrollo"},'
	array << '{"teamcity_username":"Margarita Esquea","slack_username":"margarita","channel":"#mesa-de-ayuda"},'
	array << '{"teamcity_username":"Martina Hernandez","slack_username":"Martina_Hernandez","channel":"#iso-itil-cobit-aument"},'
	array << '{"teamcity_username":"Manuel Bisono","slack_username":"mbisono","channel":"#dba"},'
	array << '{"teamcity_username":"Jeisson Polanco","slack_username":"jeison","channel":"#seguridad"},'
	array << '{"teamcity_username":"Milciades Hernandez","slack_username":"chernandez","channel":"#desarrollo"},'
	array << '{"teamcity_username":"Kendys Torres","slack_username":"kendys_torres","channel":"#operaciones_alertas"}'
	array << ']'

	client.set('/slack_usernames', value: array)

end