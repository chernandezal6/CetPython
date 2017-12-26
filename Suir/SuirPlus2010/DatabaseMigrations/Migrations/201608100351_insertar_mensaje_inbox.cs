using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608100351)]
    public class _201608100351_insertar_mensaje_inbox : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "InsertarMensajeInbox.sql");
        }
        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE INSERTARMENSAJEINBOX");
        }        
    }
}
