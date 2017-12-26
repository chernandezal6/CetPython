using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201607221124)]
    public class _201607221124_insert_into_sfc_procesos_t : Migration
    {
        public override void Up()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "67",
                        Proceso_Des = "Evaluar solicitud NSS a trabajadores extranjeros",
                        Proceso_Ejecutar = "NSS_VALIDAR_SOL_EXTRANJEROS",
                        Lista_OK = "@gherrera, @cpena, @kcruz",
                        Proceso_validar = "#desarrollo",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Registros = 5
                    }
                );

                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "68",
                        Proceso_Des = "Insertar ciudadano",
                        Proceso_Ejecutar = "NSS_INSERTAR_CIUDADANO",
                        Lista_OK = "@gherrera, @cpena, @kcruz",
                        Proceso_validar = "#desarrollo",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Registros = 5
                    }
                );

                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "69",
                        Proceso_Des = "Evaluar solicitud NSS a NUI",
                        Proceso_Ejecutar = "NSS_VALIDAR_SOLICITUD_NUI",
                        Lista_OK = "@gherrera, @cpena, @kcruz",
                        Proceso_validar = "#desarrollo",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Registros = 5
                    }
                );

                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "73",
                        Proceso_Des = "Cargar solicitud NSS a cedulados",
                        Proceso_Ejecutar = "NSS_CARGAR_SOL_CEDULADOS",
                        Lista_OK = "@gherrera, @cpena, @kcruz",
                        Proceso_validar = "#desarrollo",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Registros = 5
                    }
                );

                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "74",
                        Proceso_Des = "Evaluar solicitud NSS a CEDULA",
                        Proceso_Ejecutar = "NSS_VALIDAR_SOLICITUD_CED",
                        Lista_OK = "@gherrera, @cpena, @kcruz",
                        Proceso_validar = "#desarrollo",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Registros = 5
                    }
                );

                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "75",
                        Proceso_Des = "Actualizar ciudadano",
                        Proceso_Ejecutar = "NSS_ACTUALIZAR_CIUDADANO",
                        Lista_OK = "@gherrera, @cpena, @kcruz",
                        Proceso_validar = "#desarrollo",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Registros = 5
                    }
                );

                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "76",
                        Proceso_Des = "Evaluar solicitud NSS a menores nacionales",
                        Proceso_Ejecutar = "NSS_VALIDAR_SOL_MENORES_NAC",
                        Lista_OK = "@gherrera, @cpena, @kcruz",
                        Proceso_validar = "#desarrollo",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Registros = 5
                    }
                );

                Insert.IntoTable("SFC_PROCESOS_T").Row(
                    new
                    {
                        Id_Proceso = "77",
                        Proceso_Des = "Evaluar solicitud NSS a menores extranjeros",
                        Proceso_Ejecutar = "NSS_VALIDAR_SOL_MENORES_EXT",
                        Lista_OK = "@gherrera, @cpena, @kcruz",
                        Proceso_validar = "#desarrollo",
                        Ult_Fecha_Act = DateTime.Now,
                        Ult_Usuario_Act = "GHERRERA",
                        Is_Bitacora = "S",
                        Status = "A",
                        Lanzador = "S",
                        Registros = 5
                    }
                );

            }
        }

        public override void Down()
        {
            if (Schema.Table("SFC_PROCESOS_T").Exists())
            {
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "67" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "68" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "69" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "73" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "74" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "75" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "76" });
                Delete.FromTable("SFC_PROCESOS_T").Row(new { Id_Proceso = "77" });
            }
        }
    }
}
