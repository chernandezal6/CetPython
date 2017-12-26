using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612290954)]
    public class _201612290954_update_status_to_seg_usuario_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_USUARIO_T").Column("STATUS").Exists())
            {
                Execute.Sql("alter table SEG_USUARIO_T drop constraint CKC_STATUS_SEG_USUA");
                Execute.Sql("alter table SEG_USUARIO_T add constraint CKC_STATUS_SEG_USUA check(STATUS is null or(STATUS in ('A', 'I', 'B')))");
                Execute.Sql("comment on column SEG_USUARIO_T.status is 'A=ACTIVO, I=INACTIVO, B=BLOQUEADO'");
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_USUARIO_T").Column("STATUS").Exists())
            {
              
            }
        }
    }
}
