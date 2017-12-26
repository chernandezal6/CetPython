using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusUnitTests.Framework
{
    public static class DefaultValues
    {
        /* Campos claves y comunes de la base datos declarados para los UnitTest */
        //Campos de tipo Varchar2.
        public static string IdReferenciaTSS = "0120161669422419";               //---> Campo de hasta 16 Caracteres.
        public static string IdReferenciaDGII = "2008101317408442";              //---> Campo de hasta 16 Caracteres.
        public static string IdReferenciaISR = "2005010001433064";               //---> Campo de hasta 16 Caracteres.
        public static string IdUsuario = "40151707800104137708";                 //---> Campo de hasta 35 Caracteres.
        public static string IdUsuarioRepresentante = "0560145454800105248330";  //---> Campo de hasta 35 Caracteres.
        public static string PeriodoFactura = "201601";                          //---> Campo de hasta 6 Caracteres.
        public static string IdProceso = "14";                                   //---> Campo de hasta 2 Caracteres.
        public static string IdError = "13";                                     //---> Campo de hasta 3 Caracteres.
        public static string NroDocumentoCedula = "223-0126523-1";//"00100840651";                 //---> Campo de hasta 25 Caracteres.
        public static string NroDocumentoPasaporte = "P40224353264";             //---> Campo de hasta 25 Caracteres.
        public static string NroDocumentoNUI = "402-0172158-2";                    //---> Campo de hasta 25 Caracteres.
        public static string IdProvincia = "01";                                 //--->
        public static string IdTipoSangre = "7";                                 //--->
        public static string IdNacionalidad = "1";                               //--->
        public static string IdMunicipio = "000";                                //--->
        public static string IdRiesgo = "IV";
        public static string IdAplicacion = "SS";
        public static string IdRenglon = "SRL";
        public static string IdTipoDocumento = "P";                              //--->Campo de 1 Caracter.
        public static string IdTipoMovimiento = "DA";
        public static string IdActividadEco = "999999";
        public static string IdAdministracionLocal = "AAAA";
        public static string IdMotivoNoImpresion = "AAAAA";
        public static string IdModulo = "WS_NUI_JCE";
        public static string IdSolicitudNss = "00118179209";
        public static string IdRespuesta = "1";

        //Campos de tipo Number.
        public static Int32 IdNSS = 751737;                    //---> Campo de hasta 10 digitos.
        public static Int32 IdArs = 73;                           //---> Campo de hasta 2 digitos.
        public static Int32 IdBitacora = 3378138;                 //---> Campo de hasta 10 digitos.
        public static Int32 IdErrorCartera = 36;                  //---> Campo de hasta 10 digitos.
        public static Int32 IdCarga = 142;                        //---> Campo de hasta 10 digitos.
        public static Int32 IdPermiso = 112;                      //---> Campo de hasta 10 digitos.
        public static Int32 IdRole = 339;                         //---> Campo de hasta 5 digitos.
        public static Int32 IdEntidadRecaudadora = 7;             //---> Campo de hasta 2 digitos.
        public static Int32 IdRegistroPatronal = 473122;          //---> Campo de hasta 9 digitos.
        public static Int32 IdInhabilidad = 11;                   //--->
        public static Int32 IdNomina = 1;
        public static Int32 IdMovimiento = 9852326;
        public static Int32 IdAccion = 1;
        public static Int32 IdOficio = 13132;
        public static Int32 IdMotivo = 55555;
        public static Int32 IdDocumento = 12345;
        public static Int32 IdParametro = 23;
        public static Int32 IdEntidad= 2;                         //---> Campo de hasta 2 digitos.
        public static Int32 IdTipoNSS = 1;                        //---> Campo de hasta 9 digitos.
        public static Int32 IdHistoricoDocumento = 1;             //---> Campo de hasta 10 digitos.
        public static Int32 IdRecepcion = 1539429;
        public static Int32 CodSector = 10;
        public static Int32 IdSectorEconomico = 10;
        public static Int32 IdTipoSolicitudNSS = 1;
        public static Int32 IdSolicitudNSS = 1;
        public static Int32 IdDetSolicitudNSSDoc = 1;
        public static Int32 IdEvaluacionVisual = 1;
        public static Int32 IdCarnet = 1;        
        //public static Int32 IdSolicitudNss = 12345;
        public static Int32 IdRequisito = 1;
        public static Int32 IdValidacion = 1;
        
    }
}
