using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseMigrations.Migrations
{
    [Migration(201602120208)]
    public class _201602120208_bitacora: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "bitacora.sql");
        }
        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE BITACORA");      
        }
    }
}
