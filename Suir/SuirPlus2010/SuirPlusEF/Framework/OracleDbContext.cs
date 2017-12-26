using SuirPlusEF.Models;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using System.Data.Entity.Core.Metadata.Edm;
using System;
using System.Data.Entity.Infrastructure;

namespace SuirPlusEF.Framework
{
    public class OracleDbContext : DbContext
    {
        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Bitacora> Bitacoras { get; set; }
        public DbSet<Proceso> Procesos { get; set; }
        public DbSet<RelacionPermisosRol> RelacionPermisosRoles { get; set; }
        public DbSet<Rol> Roles { get; set; }
        public DbSet<UsuarioPermiso> UsuarioPermisos { get; set; }
        public DbSet<Permiso> Permisos { get; set; }
        public DbSet<Factura> Facturas { get; set; }
        public DbSet<EntidadRecaudadora> EntidadesRecaudadora { get; set; }
        public DbSet<LiquidacionISR> LiquidacionesISR { get; set; }
        public DbSet<DetalleFactura> DetalleFacturas { get; set; }
        public DbSet<DetalleLiquidacionInfotep> DetalleLiquidacionesInfotep { get; set; }
        public DbSet<DetalleLiquidacionISR> DetalleLiquidacionesISR { get; set; }
        public DbSet<LiquidacionInfotep> LiquidacionesInfotep { get; set; }
        public DbSet<Error> Errores { get; set; }
        public DbSet<Empresa> Empresas { get; set; }
        public DbSet<Ciudadano> Ciudadanos { get; set; }
        public DbSet<ArsCarga> ArsCargas { get; set; }
        public DbSet<ArsCartera> ArsCarteras { get; set; }
        public DbSet<ArsCarteraError> ArsCarteraErrores { get; set; }
        public DbSet<ArsCarteraSenasa> ArsCarterasSenasa { get; set; }
        public DbSet<ArsCatalogo> ArsCatalogos { get; set; }
        public DbSet<TipoMovimiento> TiposMovimientos { get; set; }
        public DbSet<Provincia> Provincias { get; set; }
        public DbSet<TipoSangre> TipoSangre { get; set; }
        public DbSet<InhabilidadJCE> Inhabilidad { get; set; }
        public DbSet<Nacionalidad> Nacionalidad { get; set; }
        public DbSet<Municipio> Municipio { get; set; }
        public DbSet<Nomina> Nominas { get; set; }
        public DbSet<CategoriaRiesgo> CategoriaRiesgo { get; set; }
        public DbSet<Movimiento> Movimientos { get; set; }
        public DbSet<Oficio> Oficios { get; set; }
        public DbSet<DetalleOficios> DetalleOficios { get; set; }
        public DbSet<Accion> Acciones { get; set; }
        public DbSet<Motivo> Motivos { get; set; }
        public DbSet<OficioDocumentacion> OficioDocumentacion { get; set; }
        public DbSet<Parametro> Parametros { get; set; }
        public DbSet<Aplicacion> Aplicaciones { get; set; }
        public DbSet<Renglon> Renglones { get; set; }
        public DbSet<Entidad> Entidades { get; set; }
        public DbSet<TipoDocumento> TipoDocumentos { get; set; }
        public DbSet<TipoNSS> TiposNss { get; set; }
        public DbSet<HistoricoDocumento> HistoricoDocumentos { get; set; }
        public DbSet<Archivo> Archivos { get; set; }
        public DbSet<SectorSalarial> SectoresSalariales { get; set; }
        public DbSet<SectorEconomico> SectoresEconomicos { get; set; }
        public DbSet<ActividadEconomica> ActividadEconomica { get; set; }
        public DbSet<AdministracionLocal> AdministracionLocal { get; set; }
        public DbSet<MotivoNoImpresion> MotivoNoImpresion { get; set; }
        public DbSet<Log> Logs { get; set; }
        public DbSet<SolicitudNSS> SolicitudesNSS { get; set; }
        public DbSet<TipoSolicitudNSS> TipoSolicitudesNSS { get; set; }
        public DbSet<Config> Configs { get; set; }
        public DbSet<EvaluacionVisual> EvaluacionVisuales { get; set; }
        public DbSet<DetalleEvaluacionVisual> DetEvaluacionVisual { get; set; }       
        public DbSet<Representante> Representantes { get; set; }
        public DbSet<CarnetDGM> CarnetDGM { get; set; }       
        public DbSet<DetalleSolicitudes> DetalleSolicitudes{ get; set; }            
        public DbSet<SolicitudRespuesta> SolicitudRespuesta { get; set; }
        public DbSet<Parentesco> Parentescos { get; set; }
        public DbSet<EstatusNSS> EstatusNSS { get; set; }
        public DbSet<MaestroExtranjero> MaestroExtranjeros { get; set; }
        public DbSet<Certificaciones> Certificaciones { get; set; }
        public DbSet<AccionEvaluacionVisual> AccionEvaliacionVisual { get; set; }
        public DbSet<Trabajador> Trabajadores { get; set; }
        public DbSet<Captcha> Captcha { get; set; }
        public DbSet<DetalleCaptcha> DetalleCaptcha { get; set; }
        public DbSet<DetalleParametro> DetalleParametro { get; set; }
        public OracleDbContext() {
            ///NO Cambiar para evitar que se corran las migraciones
            ///en la base de datos.
            Database.SetInitializer<OracleDbContext>(null);
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {           
            modelBuilder.HasDefaultSchema("SUIRPLUS");            
        }

    }
}
