using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040303)]
    public class _201608040303_nss_validaciones_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validaciones_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_validaciones_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE NSS_VALIDACIONES_PKG");
        }
    }
}
