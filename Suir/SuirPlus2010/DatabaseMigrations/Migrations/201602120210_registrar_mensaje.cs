using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace DatabaseMigrations.Migrations
{
    [Migration(201602120210)]
    public class _201602120210_registrar_mensaje: FluentMigrator.Migration
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
