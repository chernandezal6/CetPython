using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201606241130)]
    public class _201606241130_create_package_sre_empleadores_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_cartera_senasa_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "ars_cartera_senasa_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE ARS_CARTERA_SENASA_PKG");
        }
    }
}
