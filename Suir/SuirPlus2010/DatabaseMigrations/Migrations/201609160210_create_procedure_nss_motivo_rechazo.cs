using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201609160210)]
    public class _201609160210_create_procedure_nss_motivo_rechazo:FluentMigrator.Migration
    {
        public override void Up()
        {
            //Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_motivo_rechazo.sql");
        }

        public override void Down()
        {
            //Execute.Sql("DROP PROCEDURE NSS_MOTIVO_RECHAZO");
        }
    }
}
