def ejecutar_no_ignorados()
	#Quitandole el estatus de ignorados
	puts system('git update-index --no-skip-worktree SuirPlus2010/SuirPlusCL/app.config')
	puts system('git update-index --no-skip-worktree SuirPlus2010/SuirPlusEF/App.config')
	puts system('git update-index --no-skip-worktree SuirPlus2010/DatabaseMigrations/App.config')
	puts system('git update-index --no-skip-worktree SuirPlus2010/SuirPlusUnitTests/App.config')
	puts system('git update-index --no-skip-worktree SuirPlus2010/SuirPlusWebSite/Web.config')
	puts system('git update-index --no-skip-worktree SuirPlus2010/WebServicesTSS/web.config')
	puts system('git update-index --no-skip-worktree SuirPlus2010/DatabaseMigrations/Scripts/ejecutar/migrate.txt')
	
	#Configs quitando las modificaciones si la tienen
	puts system('git checkout -- SuirPlus2010/SuirPlusCL/app.config')
	puts system('git checkout -- SuirPlus2010/SuirPlusEF/App.config')
	puts system('git checkout -- SuirPlus2010/DatabaseMigrations/App.config')
	puts system('git checkout -- SuirPlus2010/SuirPlusUnitTests/App.config')
	puts system('git checkout -- SuirPlus2010/SuirPlusWebSite/Web.config')
	puts system('git checkout -- SuirPlus2010/WebServicesTSS/web.config')
	puts system('git checkout -- SuirPlus2010/DatabaseMigrations/Scripts/ejecutar/migrate.txt')
	
end
ejecutar_no_ignorados()