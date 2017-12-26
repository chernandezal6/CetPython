using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201703021242)]
    public class _201703021242_create_package_srp_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "srp_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "srp_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRP_PKG");
        }
    }
}
