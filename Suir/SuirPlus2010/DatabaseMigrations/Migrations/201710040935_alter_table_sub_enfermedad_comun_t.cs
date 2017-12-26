using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710040935)]
    public class _201710040935_alter_table_sub_enfermedad_comun_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("SUIRPLUS.SUB_ENFERMEDAD_COMUN_T").Column("ESTATUS").Exists())
            {
                Alter.Table("SUIRPLUS.SUB_ENFERMEDAD_COMUN_T")
                    .AddColumn("ESTATUS")
                    .AsCustom("VARCHAR(2)")
                    .Nullable()
                    .WithDefaultValue("AC") 
                    .WithColumnDescription("Estatus de la Enfermedad. AC = Activo, IN = INACTIVO");                                   
            }
            Execute.Sql("ALTER TABLE SUIRPLUS.SUB_ENFERMEDAD_COMUN_T ADD CONSTRAINT CK_ENF_ESTATUS CHECK (ESTATUS  in ('AC','IN')) ENABLE");
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SUIRPLUS.SUB_ENFERMEDAD_COMUN_T").Column("ESTATUS").Exists())
            {
                Execute.Sql("ALTER TABLE SUIRPLUS.SUB_ENFERMEDAD_COMUN_T DROP CONSTRAINT CK_ENF_ESTATUS");

                Delete.Column("ESTATUS").FromTable("SUIRPLUS.SUB_ENFERMEDAD_COMUN_T");               
            }
        }
    }
}
