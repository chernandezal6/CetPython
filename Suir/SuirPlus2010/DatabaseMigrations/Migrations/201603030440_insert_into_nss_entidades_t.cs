using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603030440)]
    public class _201603030440_insert_into_nss_entidades_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("NSS_ENTIDADES_T").Exists())
            {
                Insert.IntoTable("NSS_ENTIDADES_T").Row(new { id_Entidad = "1", Descripcion = "Junta Central Electoral"});
                Insert.IntoTable("NSS_ENTIDADES_T").Row(new { id_Entidad = "2", Descripcion = "Tesorería de la Seguridad Social" });
                Insert.IntoTable("NSS_ENTIDADES_T").Row(new { id_Entidad = "3", Descripcion = "Dirección General de Migración"});                    
                Insert.IntoTable("NSS_ENTIDADES_T").Row(new { id_Entidad = "4", Descripcion = "Ministerio de Interior y Policia" });
                Insert.IntoTable("NSS_ENTIDADES_T").Row(new { id_Entidad = "5", Descripcion = "Ministerio de Relaciones Exteriores" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_ENTIDADES_T").Exists())
            {
                Delete.FromTable("NSS_ENTIDADES_T").Row(new {id_Entidad = "1"});
                Delete.FromTable("NSS_ENTIDADES_T").Row(new {id_Entidad = "2"});
                Delete.FromTable("NSS_ENTIDADES_T").Row(new {id_Entidad = "3"});
                Delete.FromTable("NSS_ENTIDADES_T").Row(new {id_Entidad = "4"});
                Delete.FromTable("NSS_ENTIDADES_T").Row(new {id_Entidad = "5"});           
            }
        }
    }
}
