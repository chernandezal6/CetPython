using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseMigrations.Migrations
{
    [Migration(201602120456)]
    public class _201602120456_reenvio_movimientos : FluentMigrator.Migration
    {
        public override void Up() {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "reenvio_movimientos.sql");
        }

        public override void Down() {
            Execute.Sql("DROP PROCEDURE REENVIO_MOVIMIENTOS");
        }
    }
}
