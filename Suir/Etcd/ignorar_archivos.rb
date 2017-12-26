def ejecutar_ignorados()
	#Colocando estos archivos como ignorados
	puts system('git update-index --skip-worktree SuirPlus2010/SuirPlusCL/app.config')
	puts system('git update-index --skip-worktree SuirPlus2010/SuirPlusEF/App.config')
	puts system('git update-index --skip-worktree SuirPlus2010/DatabaseMigrations/App.config')
	puts system('git update-index --skip-worktree SuirPlus2010/SuirPlusUnitTests/App.config')
	puts system('git update-index --skip-worktree SuirPlus2010/SuirPlusWebSite/Web.config')
	puts system('git update-index --skip-worktree SuirPlus2010/WebServicesTSS/web.config')
	puts system('git update-index --skip-worktree SuirPlus2010/DatabaseMigrations/Scripts/ejecutar/migrate.txt')
	
end
ejecutar_ignorados()