using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706061213)]
    public class _201706061213_insert_into_ars_actualizacion_vista_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("ARS_ACTUALIZACION_VISTAS_T").Exists())
            {
                Insert.IntoTable("ARS_ACTUALIZACION_VISTAS_T").InSchema("SUIRPLUS").Row(
                    new
                    {
                        Nombre_vista = "ARS_DEP_ADICIONALES_MV", Ejecutar = "S"
                    }
                );
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("ARS_ACTUALIZACION_VISTAS_T").Exists())
            {
                Delete.FromTable("ARS_ACTUALIZACION_VISTAS_T").InSchema("SUIRPLUS").Row(new { Nombre_vista = "ARS_DEP_ADICIONALES_MV" });
            }
        }
    }
}
