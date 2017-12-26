using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705181343)]
    public class _201705181343_create_or_replace_trigger_sisalril_suir_sfs_elegibles : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sfs_elegibles_update_trg.sql");
            
        }

        public override void Down()
        {
            Execute.Sql("DROP TRIGGER SFS_ELEGIBLES_UPDATE_TRG");
        }
    }
}
