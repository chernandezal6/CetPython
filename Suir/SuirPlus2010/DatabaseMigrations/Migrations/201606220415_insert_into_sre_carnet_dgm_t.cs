using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201606220415)]
    public class _201606220415_insert_into_sre_carnet_dgm_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRE_CARNET_DGM_T").Exists())
            {
                Insert.IntoTable("SRE_CARNET_DGM_T").Row(new { Id = 1, Descripcion = "Permiso de reentrada" });
                Insert.IntoTable("SRE_CARNET_DGM_T").Row(new { Id = 2, Descripcion = "Residencia permanente (RP-1)" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRE_CARNET_DGM_T").Exists())
            {
                Delete.FromTable("SRE_CARNET_DGM_T").Row(new { Id = 1 });
                Delete.FromTable("SRE_CARNET_DGM_T").Row(new { Id = 2 });
            }
        }
    }
}
