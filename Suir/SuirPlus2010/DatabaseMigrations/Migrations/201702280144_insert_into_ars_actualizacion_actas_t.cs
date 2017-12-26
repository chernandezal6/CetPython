using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702280144)]
    public class _201702280144_insert_into_ars_actualizacion_actas_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("ARS_ACTUALIZACION_VISTAS_T").Exists())
            {
                Insert.IntoTable("ARS_ACTUALIZACION_VISTAS_T").Row(
                    new
                    {
                        Nombre_vista = "RPN_CARTERA_PENSIONADOS_MV",
                        Ejecutar = "S"
                    }
                );
            }
        }

        public override void Down()
        {
            if (Schema.Table("ARS_ACTUALIZACION_VISTAS_T").Exists())
            {
                Delete.FromTable("ARS_ACTUALIZACION_VISTAS_T").Row(new { Nombre_vista = "RPN_CARTERA_PENSIONADOS_MV" });
            }
        }
    }
}