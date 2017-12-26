using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706211339)]
    public class _201706211339_insert_into_rpn_entidades_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_ENTIDADES_T").Exists())
            {
                Insert.IntoTable("SUIRPLUS.RPN_ENTIDADES_T").Row(new { Id_entidad = "1", Descripcion = "Dirección General de Jubilación y Pensión DGJP", Id_Entidad_Recaudadora = 71, Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });

                Insert.IntoTable("SUIRPLUS.RPN_ENTIDADES_T").Row(new { Id_entidad = "2", Descripcion = "Junta de Retiro de las Fuerzas Armadas JRFFAA", Id_Entidad_Recaudadora = 72, Ult_Fecha_Act = DateTime.Now, Ult_Usuario_Act = "OPERACIONES" });
            }

        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_ENTIDADES_T").Exists())
            {
                Delete.FromTable("SUIRPLUS.RPN_ENTIDADES_T").Row(new { Id_entidad = "1" });

                Delete.FromTable("SUIRPLUS.RPN_ENTIDADES_T").Row(new { Id_entidad = "2" });
            }
        }
    }
}
