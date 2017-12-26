using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610120956)]
    public class _201610120956_add_id_suir_r_sol_asig_cedula_mv: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Exists())
            {
                if (!Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Column("ID").Exists())
                {
                    Alter.Table("SUIR_R_SOL_ASIG_CEDULA_MV")
                        .AddColumn("ID")
                        .AsCustom("INTEGER")
                        .WithColumnDescription("PK en la tabla SUIR_R_SOL_ASIG_CEDULA_MV")
                        .Nullable();
                }
            }
        }

        public override void Down()
        {
            if (Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Exists())
            {
                if (Schema.Table("SUIR_R_SOL_ASIG_CEDULA_MV").Column("ID").Exists())
                {
                    Delete.Column("ID").FromTable("SUIR_R_SOL_ASIG_CEDULA_MV");
                }
            }
        }
    }
}
