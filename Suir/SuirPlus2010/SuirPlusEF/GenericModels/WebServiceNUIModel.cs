using SuirPlusEF.Framework;
using SuirPlusEF.Models;

namespace SuirPlusEF.GenericModels
{
    public class WebServiceNUIModel : BaseGenericServiceModel
    {
        public string NUI { get; set; }
        public DocumentoNUI NUICompleto {

            get {
                return new GenericModels.DocumentoNUI(this.NUI);
            }

        }
        public string Nombre { get; set; }
        public string PrimerApellido { get; set; }
        public string SegundoApellido { get; set; }
        public string FechaEvento { get; set; }
        public string Sexo { get; set; }
        public string Municipio { get; set; }
        public string Oficialia { get; set; }
        public string Ano { get; set; }
        public string idTipoLibro { get; set; }
        public string NoLibro { get; set; }
        public string Literal { get; set; }
        public string NoFolio { get; set; }
        public string NoActa { get; set; }
        public string CedulaPadre { get; set; }
        public string CedulaMadre { get; set; }
        public string ConsultaValida { get; set; }
        public string Mensaje { get; set; }
        public string FechaHoraConsulta { get; set; }

        public Ciudadano CiudadanoModel {
            get {
                Ciudadano ciu = new Ciudadano();
                ciu.NroDocumento = this.NUICompleto.NumeroSinGuiones();
                ciu.TipoDocumento = "N";
                ciu.Nombres = this.Nombre;
                ciu.PrimerApellido = this.PrimerApellido;
                ciu.SegundoApellido = this.SegundoApellido;
                ciu.Sexo = this.Sexo;
                ciu.IdMunicipio = this.Municipio;
                ciu.OficialiaActa = this.Oficialia;
                ciu.AnoActa = this.Ano;
                ciu.LibroActa = this.NoLibro;
                ciu.LiteralActa = this.Literal;
                ciu.FolioActa = this.NoFolio;
                ciu.NumeroActa = this.NoActa;                      

                return ciu;
            }
        }

    }
}
