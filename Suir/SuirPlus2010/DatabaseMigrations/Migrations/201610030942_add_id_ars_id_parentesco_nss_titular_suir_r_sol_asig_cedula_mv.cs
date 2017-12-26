using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610030942)]
    public class _201610030942_add_id_ars_id_parentesco_nss_titular_suir_r_sol_asig_cedula_mv : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Column("ID_ARS").Exists())
            {
                Alter.Table("SUIR_R_SOL_ASIG_CEDULA_MV")
                     .AddColumn("ID_ARS")
                     .AsCustom("NUMBER(2)")
                     .WithColumnDescription("Código de la ARS")
                    .Nullable();
            }
            if (!Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Column("NSS_TITULAR").Exists())
            {
                Alter.Table("SUIR_R_SOL_ASIG_CEDULA_MV")
                     .AddColumn("NSS_TITULAR")
                     .AsCustom("NUMBER(9)")
                     .WithColumnDescription("NSS del Titular")
                    .Nullable();
            }
            if (!Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Column("CODIGO_PARENTESCO").Exists())
            {
                Alter.Table("SUIR_R_SOL_ASIG_CEDULA_MV")
                     .AddColumn("CODIGO_PARENTESCO")
                     .AsCustom("VARCHAR2(2)")
                     .WithColumnDescription("Código de Parentesco")
                    .Nullable();
            }
        }

        public override void Down()
        {
            if (Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Column("ID_ARS").Exists())
            {
                Delete.Column("ID_ARS").FromTable("SUIR_R_SOL_ASIG_CEDULA_MV");
            }

            if (Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Column("NSS_TITULAR").Exists())
            {
                Delete.Column("NSS_TITULAR").FromTable("SUIR_R_SOL_ASIG_CEDULA_MV");
            }

            if (Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Column("CODIGO_PARENTESCO").Exists())
            {
                Delete.Column("CODIGO_PARENTESCO").FromTable("SUIR_R_SOL_ASIG_CEDULA_MV");
            }
        }
    }
}
