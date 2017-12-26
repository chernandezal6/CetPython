using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{   
     [Migration(01611030552)]
    public class _201611030552_call_sre_procesar_cedula_rechazadas : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_procesar_cedula_rechazadas.sql");
        }
        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE SRE_PROCESAR_CEDULA_RECHAZADAS");
        }
    }
}

