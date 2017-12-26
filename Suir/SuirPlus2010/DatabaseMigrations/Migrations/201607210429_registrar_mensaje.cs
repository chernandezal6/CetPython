using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    //Esta migración fue creada porque ya existe otra que inserta errores [Migration(201602120210)]
    //corrida anteriormente en produccion y viene en la tabla VERSIONINFO
    //Creada nuevamente porque el procedure anterior nombre de manera erronea algunos campos en la tabla SEG_MSG_T

    [Migration(201607210429)]
    public class _201607210429_registrar_mensaje : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "registrar_mensaje.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE REGISTRAR_MENSAJE");
        }
    }
}
