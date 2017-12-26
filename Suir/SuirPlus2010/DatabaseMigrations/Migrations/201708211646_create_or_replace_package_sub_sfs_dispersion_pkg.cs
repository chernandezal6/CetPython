using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708211646)]
    public class _201708211646_create_or_replace_package_sub_sfs_dispersion_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sub_sfs_dispersion_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sub_sfs_dispersion_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SUIRPLUS.SUB_SFS_DISPERSION_PKG");
        }
    }
}
