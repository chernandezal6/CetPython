using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201704071147)]
    public class _201704071147_create_package_sre_empleadores_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_empleadores_espec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_empleadores_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRE_EMPLEADORES_PKG");
        }
    }
}
