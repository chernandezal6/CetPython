using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200933)]
    public class _201706200933_alter_tables_regimen_pensionado : FluentMigrator.Migration
    {
        public override void Up()
        {
            //Foreign_key de la tabla RPN_ENTIDADES_T
            if (Schema.Schema("SUIRPLUS").Table("RPN_ENTIDADES_T").Exists())
            {
                Create.ForeignKey("FK_RPN_ENTIDAD_SFC_ENTIDAD_REC")
                  .FromTable("SUIRPLUS.RPN_ENTIDADES_T").ForeignColumn("ID_ENTIDAD_RECAUDADORA")
                  .ToTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").PrimaryColumn("ID_ENTIDAD_RECAUDADORA");
            }

            //Se necesita incluir el foreign_key a la tabla RPN_REGIMEN_T
            if (Schema.Schema("SUIRPLUS").Table("RPN_REGIMEN_T").Exists())
            {
                Create.ForeignKey("FK_RPN_REGI_CON_SFC_PARAMETROS")
                  .FromTable("SUIRPLUS.RPN_REGIMEN_T").ForeignColumn("ID_PARAM_CONTRIBUCION")
                  .ToTable("SUIRPLUS.SFC_PARAMETROS_T").PrimaryColumn("ID_PARAMETRO");

                Create.ForeignKey("FK_RPN_REGI_CAP_SFC_PARAMETROS")
                  .FromTable("SUIRPLUS.RPN_REGIMEN_T").ForeignColumn("ID_PARAM_CAPITA")
                  .ToTable("SUIRPLUS.SFC_PARAMETROS_T").PrimaryColumn("ID_PARAMETRO");

                Create.ForeignKey("FK_RPN_REGI_DIR_SFC_PARAMETROS")
                  .FromTable("SUIRPLUS.RPN_REGIMEN_T").ForeignColumn("ID_PARAM_APORTE_DIRECTOS")
                  .ToTable("SUIRPLUS.SFC_PARAMETROS_T").PrimaryColumn("ID_PARAMETRO");

                Create.ForeignKey("FK_RPN_REGI_ADI_SFC_PARAMETROS")
                  .FromTable("SUIRPLUS.RPN_REGIMEN_T").ForeignColumn("ID_PARAM_APORTE_ADICIONALES")
                  .ToTable("SUIRPLUS.SFC_PARAMETROS_T").PrimaryColumn("ID_PARAMETRO");
            }

            //Se necesita incluir el foreign_key a la tabla RPN_ENTIDAD_REGIMEN_T
            if (Schema.Schema("SUIRPLUS").Table("RPN_ENTIDAD_REGIMEN_T").Exists())
            {
                Create.PrimaryKey("PK_RPN_ENTIDAD_REG_T").OnTable("SUIRPLUS.RPN_ENTIDAD_REGIMEN_T").Columns("ID_ENTIDAD, ID_REGIMEN");

                Create.ForeignKey("FK_RPN_ENT_REG_T_RPN_REGIMEN_T")
                    .FromTable("SUIRPLUS.RPN_ENTIDAD_REGIMEN_T").ForeignColumn("ID_REGIMEN")
                    .ToTable("SUIRPLUS.RPN_REGIMEN_T").PrimaryColumn("ID_REGIMEN");

                Create.ForeignKey("FK_RPN_ENT_REG_RPN_ENTIDADES_T")
                    .FromTable("SUIRPLUS.RPN_ENTIDAD_REGIMEN_T").ForeignColumn("ID_ENTIDAD")
                    .ToTable("SUIRPLUS.RPN_ENTIDADES_T").PrimaryColumn("ID_ENTIDAD");
            }

            ////Se necesita incluir el foreign_key a la tabla RPN_NOMINAS_T
            if (Schema.Schema("SUIRPLUS").Table("RPN_NOMINAS_T").Exists())
            {
                Create.PrimaryKey("PK_RPN_NOMINAS_T").OnTable("SUIRPLUS.RPN_NOMINAS_T").Columns("PERIODO,ID_REGIMEN,ID_NSS_TITULAR");

                Create.ForeignKey("FK_RPN_NOMINAS_T_RPN_REGIMEN_T")
                    .FromTable("SUIRPLUS.RPN_NOMINAS_T").ForeignColumn("ID_REGIMEN")
                    .ToTable("SUIRPLUS.RPN_REGIMEN_T").PrimaryColumn("ID_REGIMEN");

                Create.ForeignKey("FK_RPN_NOMINAS_SRE_CIUDADANOS")
                     .FromTable("SUIRPLUS.RPN_NOMINAS_T").ForeignColumn("ID_NSS_TITULAR")
                     .ToTable("SUIRPLUS.SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                Create.ForeignKey("FK_RPN_NOMINAS_SRE_ARCHIVOS_T")
                    .FromTable("SUIRPLUS.RPN_NOMINAS_T").ForeignColumn("ID_RECEPCION")
                    .ToTable("SUIRPLUS.SRE_ARCHIVOS_T").PrimaryColumn("ID_RECEPCION");

                Create.ForeignKey("FK_RPN_NOMINAS_RPN_ENTIDADES_T")
                    .FromTable("SUIRPLUS.RPN_NOMINAS_T").ForeignColumn("ID_ENTIDAD")
                    .ToTable("SUIRPLUS.RPN_ENTIDADES_T").PrimaryColumn("ID_ENTIDAD");

                Create.ForeignKey("FK_RPN_NOMINAS_T_SEG_ERROR_T")
                     .FromTable("SUIRPLUS.RPN_NOMINAS_T").ForeignColumn("ID_ERROR")
                     .ToTable("SUIRPLUS.ARS_CARTERA_ERRORES_T").PrimaryColumn("ID_ERROR");

                Create.ForeignKey("FK_RPN_NOMINAS_T_ARS_CARGA_T")
                    .FromTable("SUIRPLUS.RPN_NOMINAS_T").ForeignColumn("ID_CARGA")
                    .ToTable("SUIRPLUS.ARS_CARGA_T").PrimaryColumn("ID_CARGA");
            }

            Execute.Sql("ALTER TABLE SUIRPLUS.RPN_NOMINAS_T ADD CONSTRAINT CHK_TIPO_PAGO_RPN_NOMINAS_T   CHECK(TIPO_PAGO IN ('H','C'))");

            Execute.Sql("ALTER TABLE SUIRPLUS.RPN_NOMINAS_T ADD CONSTRAINT CHK_TIPO_PENSIO_RPN_NOMINAS_T CHECK(TIPO_PENSIONADO IN ('O','S'))");

            Execute.Sql("ALTER TABLE SUIRPLUS.RPN_NOMINAS_T ADD CONSTRAINT CHK_STATUS_RPN_NOMINAS_T      CHECK(STATUS IN ('PE','RE','OK'))");


            ////Se necesita incluir el foreign_key a la tabla RPN_DEP_ADICIONALES_T
            if (Schema.Schema("SUIRPLUS").Table("RPN_DEP_ADICIONALES_T").Exists())
            {
                Create.PrimaryKey("PK_RPN_DEP_ADICIONALES_T").OnTable("SUIRPLUS.RPN_DEP_ADICIONALES_T").Columns("PERIODO,ID_REGIMEN,ID_NSS_TITULAR,ID_NSS_DEPENDIENTE");

                Create.ForeignKey("FK_RPN_DEP_ADIC_SRE_ARCHIVOS_T")
                    .FromTable("SUIRPLUS.RPN_DEP_ADICIONALES_T").ForeignColumn("ID_RECEPCION")
                    .ToTable("SUIRPLUS.SRE_ARCHIVOS_T").PrimaryColumn("ID_RECEPCION");

                Create.ForeignKey("FK_RPN_DEP_ADIC_T_ARS_CARGA_T")
                    .FromTable("SUIRPLUS.RPN_DEP_ADICIONALES_T").ForeignColumn("ID_CARGA")
                    .ToTable("SUIRPLUS.ARS_CARGA_T").PrimaryColumn("ID_CARGA");

                Create.ForeignKey("FK_RPN_DEP_ADIC_RPN_ENTIDADES")
                    .FromTable("SUIRPLUS.RPN_DEP_ADICIONALES_T").ForeignColumn("ID_ENTIDAD")
                    .ToTable("SUIRPLUS.RPN_ENTIDADES_T").PrimaryColumn("ID_ENTIDAD");

                Create.ForeignKey("FK_RPN_DEP_ADIC_RPN_REGIMEN_T")
                    .FromTable("SUIRPLUS.RPN_DEP_ADICIONALES_T").ForeignColumn("ID_REGIMEN")
                    .ToTable("SUIRPLUS.RPN_REGIMEN_T").PrimaryColumn("ID_REGIMEN");

                Create.ForeignKey("FK_RPN_DEP_ADIC_TIT_SRE_CIUDAD")
                     .FromTable("SUIRPLUS.RPN_DEP_ADICIONALES_T").ForeignColumn("ID_NSS_TITULAR")
                     .ToTable("SUIRPLUS.SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                Create.ForeignKey("FK_RPN_DEP_ADIC_DEP_SRE_CIUDAD")
                     .FromTable("SUIRPLUS.RPN_DEP_ADICIONALES_T").ForeignColumn("ID_NSS_DEPENDIENTE")
                     .ToTable("SUIRPLUS.SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");
            }

            ////Se necesita incluir el foreign_key a la tabla RPN_ARCHIVOS_T 
            if (Schema.Schema("SUIRPLUS").Table("RPN_ARCHIVOS_T").Exists())
            {
                Create.UniqueConstraint("UQ_RPN_RPN_ARCHIVOS_T").OnTable("SUIRPLUS.RPN_ARCHIVOS_T").Columns("PERIODO,ID_TIPO_ARCHIVO,ID_ARS,ID_ENTIDAD");
                
                Create.ForeignKey("FK_RPN_ARCHI_SRE_TIPO_ARCHIVOS")
                    .FromTable("SUIRPLUS.RPN_ARCHIVOS_T").ForeignColumn("ID_TIPO_ARCHIVO")
                    .ToTable("SUIRPLUS.SRE_TIPO_ARCHIVOS_T").PrimaryColumn("ID_TIPO_ARCHIVO");

                Create.ForeignKey("FK_RPN_ARCHI_ARS_CATALOGO_T")
                    .FromTable("SUIRPLUS.RPN_ARCHIVOS_T").ForeignColumn("ID_ARS")
                    .ToTable("SUIRPLUS.ARS_CATALOGO_T").PrimaryColumn("ID_ARS");

                Create.ForeignKey("FK_RPN_ARCHI_RPN_ENTIDADES_T")
                     .FromTable("SUIRPLUS.RPN_ARCHIVOS_T").ForeignColumn("ID_ENTIDAD")
                     .ToTable("SUIRPLUS.RPN_ENTIDADES_T").PrimaryColumn("ID_ENTIDAD");
            }

            if (Schema.Schema("SUIRPLUS").Table("RPN_TMP_NOMINAS_T").Exists())
            {
                Create.PrimaryKey("PK_RPN_TMP_NOMINAS_T").OnTable("SUIRPLUS.RPN_TMP_NOMINAS_T").Columns("ID_SECUENCIA,ID_RECEPCION");

                Create.ForeignKey("FK_RPN_TMP_NOMI_SRE_ARCHIVOS_T")
                    .FromTable("SUIRPLUS.RPN_TMP_NOMINAS_T").ForeignColumn("ID_RECEPCION")
                    .ToTable("SUIRPLUS.SRE_ARCHIVOS_T").PrimaryColumn("ID_RECEPCION");
            }

                ////Se necesita incluir el foreign_key a la tabla RPN_CARTERA_RECHAZOS_T
           if (Schema.Schema("SUIRPLUS").Table("RPN_CARTERA_RECHAZOS_T").Exists())
            {
           
                Create.ForeignKey("FK_RPN_CART_RECH_ARS_CARGA_T")
                    .FromTable("SUIRPLUS.RPN_CARTERA_RECHAZOS_T").ForeignColumn("ID_CARGA")
                    .ToTable("SUIRPLUS.ARS_CARGA_T").PrimaryColumn("ID_CARGA");

                Create.ForeignKey("FK_RPN_CART_RECH_SEG_ERROR_T")
                    .FromTable("SUIRPLUS.RPN_CARTERA_RECHAZOS_T").ForeignColumn("ID_ERROR")
                    .ToTable("SUIRPLUS.ARS_CARTERA_ERRORES_T").PrimaryColumn("ID_ERROR");

            }

            ////Se necesita incluir el foreign_key a la tabla RPN_CARTERA_PENSIONADOS_T
            if (Schema.Schema("SUIRPLUS").Table("RPN_CARTERA_PENSIONADOS_T").Exists())
            {
                Create.PrimaryKey("PK_RPN_CARTERA_PENSIONADOS_T").OnTable("SUIRPLUS.RPN_CARTERA_PENSIONADOS_T").Columns("PERIODO_FACTURA,ID_REGIMEN,ID_NSS_TITULAR,ID_NSS_DEPENDIENTE");

                Create.ForeignKey("FK_RPN_CARTERA_PEN_ARS_CARGA_T")
                    .FromTable("SUIRPLUS.RPN_CARTERA_PENSIONADOS_T").ForeignColumn("ID_CARGA")
                    .ToTable("SUIRPLUS.ARS_CARGA_T").PrimaryColumn("ID_CARGA");

                Create.ForeignKey("FK_RPN_CARTERA_PEN_RPN_REGIMEN")
                   .FromTable("SUIRPLUS.RPN_CARTERA_PENSIONADOS_T").ForeignColumn("ID_REGIMEN")
                   .ToTable("SUIRPLUS.RPN_REGIMEN_T").PrimaryColumn("ID_REGIMEN");

                Create.ForeignKey("FK_RPN_CARTERA_PEN_ARS_PARENTE")
                     .FromTable("SUIRPLUS.RPN_CARTERA_PENSIONADOS_T").ForeignColumn("ID_PARENTESCO")
                     .ToTable("SUIRPLUS.ARS_PARENTESCOS_T").PrimaryColumn("ID_PARENTESCO");

                Create.ForeignKey("FK_RPN_CARTPENS_ARS_CATALOGO_T")
                    .FromTable("SUIRPLUS.RPN_CARTERA_PENSIONADOS_T").ForeignColumn("ID_ARS")
                    .ToTable("SUIRPLUS.ARS_CATALOGO_T").PrimaryColumn("ID_ARS");

                Create.ForeignKey("FK_RPN_CART_PEN_TIT_SRE_CIUDAD")
                     .FromTable("SUIRPLUS.RPN_CARTERA_PENSIONADOS_T").ForeignColumn("ID_NSS_TITULAR")
                     .ToTable("SUIRPLUS.SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                Create.ForeignKey("FK_RPN_CART_PEN_DEP_SRE_CIUDAD")
                     .FromTable("SUIRPLUS.RPN_CARTERA_PENSIONADOS_T").ForeignColumn("ID_NSS_DEPENDIENTE")
                     .ToTable("SUIRPLUS.SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                Execute.Sql("ALTER TABLE SUIRPLUS.RPN_CARTERA_PENSIONADOS_T ADD CONSTRAINT CHK_TIPO_AFIL_RPN_CART_PENS CHECK(TIPO_AFILIADO IN ('T','D','A'))");

                Execute.Sql("ALTER TABLE SUIRPLUS.RPN_CARTERA_PENSIONADOS_T ADD CONSTRAINT CHK_ESTUDIANTE_RPN_CART_PENS CHECK(ESTUDIANTE IN ('S','N'))");

                Execute.Sql("ALTER TABLE SUIRPLUS.RPN_CARTERA_PENSIONADOS_T ADD CONSTRAINT CHK_DISCAPACIDAD_RPN_CART_PENS CHECK(DISCAPACITADO IN ('S','N'))");
            }
            
            ////Se necesita incluir el foreign_key a la tabla  RPN_DISPERSION_RESUMEN_T
            if (Schema.Schema("SUIRPLUS").Table("RPN_DISPERSION_RESUMEN_T").Exists())
            {
                Create.PrimaryKey("PK_RPN_DISPERSION_RESUMEN_T").OnTable("SUIRPLUS.RPN_DISPERSION_RESUMEN_T").Columns("PERIODO,ID_REGIMEN,ID_ARS");

                Create.ForeignKey("FK_RPN_DISP_RES_RPN_REGIMEN_T")
                     .FromTable("SUIRPLUS.RPN_DISPERSION_RESUMEN_T").ForeignColumn("ID_REGIMEN")
                    .ToTable("SUIRPLUS.RPN_REGIMEN_T").PrimaryColumn("ID_REGIMEN");

                Create.ForeignKey("FK_RPN_DISP_RES_ARS_CATALOGO_T")
                    .FromTable("SUIRPLUS.RPN_DISPERSION_RESUMEN_T").ForeignColumn("ID_ARS")
                    .ToTable("SUIRPLUS.ARS_CATALOGO_T").PrimaryColumn("ID_ARS");
            }

            //Foreign_key de la tabla ARS_CATALOGO_T
            if (Schema.Schema("SUIRPLUS").Table("ARS_CATALOGO_T").Exists())
            {
                Create.ForeignKey("FK_ARS_CATALOGO_SFC_ENTIDAD_RE")
                  .FromTable("SUIRPLUS.ARS_CATALOGO_T").ForeignColumn("ID_ENTIDAD_RECAUDADORA")
                  .ToTable("SUIRPLUS.SFC_ENTIDAD_RECAUDADORA_T").PrimaryColumn("ID_ENTIDAD_RECAUDADORA");
            }
        }
        public override void Down()
        {
            //***** ********
                        
        }
    }
}
