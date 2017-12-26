using System;
using SuirPlusEF.Models;

namespace SuirPlusEF.GenericModels
{
    public class WebServiceCedulaModel: Framework.BaseGenericServiceModel
    {
        public string Cedula { get; set; }
        public DocumentoCedula CedCompleta
        {
            get
            {
                return new GenericModels.DocumentoCedula(this.Cedula);
            }

        }
        public string Nombres { get; set; }
        public string Apellido1 { get; set; }
        public string Apellido2 { get; set; }
        public string FechaNacimiento { get; set; }
        public string CodSangre { get; set; }
        //public string DescSangre { get; set; }
        public string Sexo { get; set; }
        public string CodNacionalidad{ get; set; }
        //public string DescNacionalidad { get; set; }
        public string EstadoCivil { get; set; }
        public string CedulaPadre { get; set; }
        public string NombrePadre { get; set; }
        public string Apellido1Padre { get; set; }
        public string Apellido2Padre { get; set; }
        public string CedulaMadre { get; set; }
        public string NombreMadre { get; set; }
        public string Apellido1Madre { get; set; }
        public string Apellido2Madre { get; set; }
        public string CedulaConyugue { get; set; }
        public string TipoCausa { get; set; }
        public string CodCausa { get; set; }
        //public string DescCausaInhabilidad { get; set; }

        public string MunicipioActa { get; set; }
        //public string DescMunicipio { get; set; }
        public string OficialiaActa { get; set; }
        public string NoLibro { get; set; }
        public string NoFolio { get; set; }
        public string NoActa { get; set; }
        public string AnoActa { get; set; }
        public string TipoLibroActa { get; set; }

        public string Estatus { get; set; }
        //public string DescEstatus { get; set; }
        public string FechaCancelacion { get; set; }

        public string Success { get; set; }
        public string Mensaje { get; set; }

        public Ciudadano CiudadanoModel
        {
            get
            {
                Ciudadano ciu = new Ciudadano();
                ciu.FechaRegistro = DateTime.Now;
                ciu.NroDocumento = this.CedCompleta.NumeroSinGuiones();
                ciu.TipoDocumento = "C";
                ciu.Nombres = this.Nombres;
                ciu.PrimerApellido = this.Apellido1;
                ciu.SegundoApellido = this.Apellido2;
                //ciu.FechaNacimiento = this.FechaNacimiento;
                ciu.Sexo = this.Sexo;
                ciu.EstadoCivil = this.EstadoCivil;
                ciu.NombrePadre = this.NombrePadre;
                ciu.NombreMadre = this.NombreMadre;
                ciu.TipoCausa = this.TipoCausa;
                
                //ciu.IdCausaInhabilidad = this.CodCausa;                         
                ciu.IdMunicipio = this.MunicipioActa;
                ciu.OficialiaActa = this.OficialiaActa;
                ciu.AnoActa = this.AnoActa;
                ciu.LibroActa = this.NoLibro;
                ciu.FolioActa = this.NoFolio;
                ciu.NumeroActa = this.NoActa;
                ciu.TipoLibroActa = this.TipoLibroActa;
                ciu.Estatus = this.Estatus;                

                return ciu;
            }
        }

    }
}
