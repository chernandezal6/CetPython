using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200925)]
    public class _201706200925_create_table_rpn_archivos_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_ARCHIVOS_T").Exists())
            {
                Create.Table("RPN_ARCHIVOS_T").WithDescription("Entidad que contiene los archivos de descargas de dispersión y rechazos para las entidades que suben las nóminas de pensionados titulares y dependientes adicionales por período de los distintos régimenes del plan especial de servicio de salud.")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_TIPO_ARCHIVO").AsCustom("VARCHAR2(5)").NotNullable().WithColumnDescription("Identificador del tipo de archivo, fk de la tabla SRE_TIPO_ARCHIVOS_T.")
                    .WithColumn("ID_ARS").AsCustom("NUMBER(4)").Nullable().WithColumnDescription("Identificador único de la ARS a la que está afiliado un pensionado. FK a la tabla ARS_CATALOGO_T.")
                    .WithColumn("ID_ENTIDAD").AsCustom("NUMBER(3)").Nullable().WithColumnDescription(" Identificador único de la entidad que sube los archivos de nómina de titulares y dependientes adicionales.")
                    .WithColumn("PERIODO").AsCustom("NUMBER(6)").NotNullable().WithColumnDescription("Período para el cual se genera el archivo en formato AAAAMM.")
                    .WithColumn("NOMBRE").AsCustom("VARCHAR2(60)").NotNullable().WithColumnDescription("Nombre del archivo")
                    .WithColumn("FECHA_REGISTRO").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha en que se generó el archivo")                    
                    .WithColumn("DATA").AsCustom("CLOB").NotNullable().WithColumnDescription("Cuerpo o contenido del archivo.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro");

                Execute.Sql(@"CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_ARCHIVOS_T_TRG
                                BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_ARCHIVOS_T FOR EACH ROW
                                BEGIN
                                  :new.ult_fecha_act := SYSDATE;
                                  IF (:new.fecha_registro IS NOT NULL AND :old.fecha_registro IS NOT NULL) AND (:new.fecha_registro <> :old.fecha_registro) THEN
                                    :new.fecha_registro := :old.fecha_registro;
                                  ELSIF (:new.fecha_registro IS NULL AND :old.fecha_registro IS NULL) THEN
                                    :new.fecha_registro := SYSDATE;
                                  END IF; 
                                END;");

                Execute.Sql("ALTER TABLE SUIRPLUS.RPN_ARCHIVOS_T ADD CONSTRAINT CHK_RPN_ARS_ENTIDAD CHECK((ID_ARS IS NOT NULL AND ID_ENTIDAD IS NULL) OR (ID_ARS IS NULL AND ID_ENTIDAD IS NOT NULl))");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_ARCHIVOS_T").Exists())
            {
                Delete.Table("SUIRPLUS.RPN_ARCHIVOS_T");
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_ARCHIVOS_T_TRG'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_ARCHIVOS_T_TRG');
                            End if;                          
                        END;");
        }
    }
}
