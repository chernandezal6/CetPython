using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201703200444)]
    public class _201703200444_create_package_sfc_infotep_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_infotep_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfc_infotep_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRP_PKG");
        }
    }
}
