using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations
{ 
    [Migration(201603030241)]
    public class _201603030241_create_table_nss_accion_evaluacion_visual_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("NSS_ACCION_EVALUACION_VISUAL_T").Exists())
            {
                Create.Table("NSS_ACCION_EVALUACION_VISUAL_T")
                    .WithColumn("ID_ACCION_EV").AsCustom("NUMBER(10)").NotNullable().PrimaryKey("PK_NSS_ACCION_EV_T").WithColumnDescription("Primary key de la tabla.")
                    .WithColumn("Descripcion").AsCustom("VARCHAR2(100)").NotNullable().WithColumnDescription("Descripción de la acción que toma el evaluador.");
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_ACCION_EVALUACION_VISUAL_T").Exists())
            {
                Delete.Table("NSS_ACCION_EVALUACION_VISUAL_T");
            }
        }
    }
}
