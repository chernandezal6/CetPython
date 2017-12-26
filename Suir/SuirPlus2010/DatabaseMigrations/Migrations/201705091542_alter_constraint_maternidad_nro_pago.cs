using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705091542)]
    public class _201705091542_alter_constraint_maternidad_nro_pago : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T DROP CONSTRAINT CK_SFS_SUBS_MAT_NRO_PAGO");
            Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T ADD CONSTRAINT CK_SFS_SUBS_MAT_NRO_PAGO CHECK (nro_pago  in (0,1,2,3,4)) ENABLE");

        }

        public override void Down()
        {
            
        }
    }
}
