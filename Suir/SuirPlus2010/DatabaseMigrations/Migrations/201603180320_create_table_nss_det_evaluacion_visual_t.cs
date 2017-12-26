using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603180320)]
    public class _201603180320_create_table_nss_det_evaluacion_visual_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("NSS_DET_EVALUACION_VISUAL_T").Exists())
            {
                Create.Table("NSS_DET_EVALUACION_VISUAL_T")
                    .WithColumn("ID_DET_EVALUACION").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla y Id de los casos del Detalle para la Evaluación Visual. SEQUENCE")
                    .WithColumn("ID_EVALUACION").AsInt32().NotNullable().WithColumnDescription("Foreign key de la tabla Evaluacion Visual.")
                    .WithColumn("ID_NSS").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("NSS de la persona que coincide con los datos de la solicitud de asignación NSS. FK de la tabla SRE_CIUDADANOS_T")
                    .WithColumn("ID_EXPEDIENTE").AsCustom("VARCHAR2(25)").Nullable().WithColumnDescription("Numero de expediente para extranjeros.FK de la tabla de maestro extranjeros.")
                    .WithColumn("ID_ACCION_EV").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("Determina que medida debe tomar el evaluador para este caso de Evaluación Visual. FK de la tabla NSS_ACCION_EVALUACION_VISUAL_T");

                //Foreign_key a la tabla NSS_EVALUACION_VISUAL_T
                Create.ForeignKey("FK_DET_EV_TO_EVA_VISUAL")
                    .FromTable("NSS_DET_EVALUACION_VISUAL_T").ForeignColumn("ID_EVALUACION")
                    .ToTable("NSS_EVALUACION_VISUAL_T").PrimaryColumn("ID_EVALUACION");

                //Foreign_key a la tabla SRE_CIUDADANOS_T
                Create.ForeignKey("FK_DET_EV_T_CIUDADANOS_T")
                    .FromTable("NSS_DET_EVALUACION_VISUAL_T").ForeignColumn("ID_NSS")
                    .ToTable("SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                //Foreign_key a la tabla NSS_ACCION_EVALUACION_VISUAL_T
                Create.ForeignKey("FK_DET_EV_ACCION")
                    .FromTable("NSS_DET_EVALUACION_VISUAL_T").ForeignColumn("ID_ACCION_EV")
                    .ToTable("NSS_ACCION_EVALUACION_VISUAL_T").PrimaryColumn("ID_ACCION_EV");

                //como en oracle 11g no existe "identity" necesitamos crear un sequence
                Create.Sequence("NSS_DET_EV_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_DET_EVALUACION_VISUAL_T").Exists())
            {
                Delete.Table("NSS_DET_EVALUACION_VISUAL_T");
                Delete.Sequence("NSS_DET_EV_SEQ");
            }
        }
    }
}
