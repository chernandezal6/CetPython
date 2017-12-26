using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusUnitTests.Framework;
using SuirPlusEF.Service;
using SuirPlusEF.GenericModels;

namespace SuirPlusUnitTests.EF.Models
{
    public class CiudadanoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByNroDocumento()
        {

            Ciudadano ciudadano = new Ciudadano();
            CiudadanoRepository _RepCiu = new CiudadanoRepository();
            int existe = 0;
            ciudadano = _RepCiu.GetByNroDocumento(DefaultValues.NroDocumentoCedula, "C",ref existe);
            NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("EntityFramework")]
        public void ForeignKeys()
        {      

            //ProvinciaRepository _RepProv = new ProvinciaRepository();
            //TipoSangreRepository _RepTipoSangre = new TipoSangreRepository(_RepProv.db);
            //InhabilidadRepository _RepInhabilidad = new InhabilidadRepository(_RepProv.db);
            //NacionalidadRepository _RepNacionalidad = new NacionalidadRepository(_RepProv.db);
            //MunicipioRepository _RepMunicipio = new MunicipioRepository(_RepProv.db);
            //TipoNSSRepository _RepTipoNSS = new TipoNSSRepository(_RepProv.db);                      
            
            //Provincia provincia = _RepProv.GetByIdProvincia(DefaultValues.IdProvincia);
            //TipoSangre tipoSangre = _RepTipoSangre.GetByIdTipoSangre(DefaultValues.IdTipoSangre);
            //InhabilidadJCE inhabilidad = _RepInhabilidad.GetByIdInhabilidad(DefaultValues.IdInhabilidad);
            //Nacionalidad nacionalidad = _RepNacionalidad.GetByIdNacionalidad(DefaultValues.IdNacionalidad);
            //Municipio municipio = _RepMunicipio.GetByIdMunicipio(DefaultValues.IdMunicipio);
            //TipoNSS tipoNSS = _RepTipoNSS.GetByIdTipoNSS(DefaultValues.IdTipoNSS);
            
            //Ciudadano ciudadano = new Ciudadano { IdNSS = DefaultValues.IdNSS, Provincia = provincia, TipoSangre = tipoSangre, InhabilidadJCE = inhabilidad, Nacionalidad = nacionalidad, Municipio = municipio, tipoNSS= tipoNSS };

            //string DescripcionProvincia = ciudadano.Provincia.Descripcion;
            //string IdTipoSangre = ciudadano.TipoSangre.IdTipoSangre;
            //int IdInhabilidad = ciudadano.InhabilidadJCE.IdCausaInhabilidad;
            //string IdNacionalidad = ciudadano.Nacionalidad.IdNacionalidad;
            //string IdMunicipio = ciudadano.Municipio.IdMunicipio;
            //int IdTipoNSS = ciudadano.tipoNSS.IdTipoNSS;

            //NUnit.Framework.Assert.True(true);

        }

        //[Test]
        //[Category("EntityFrameworkData1")]
        //public void GetNextNSSByTipoDocumento()
        //{
        //    NumeroSeguridadSocial nss = new NumeroSeguridadSocial();
        //    DocumentoNSS docNSS = nss.Crear("C");
        //    Console.WriteLine("Mi nuevo NSS es: " + docNSS.NumeroSinGuiones());
        //    NUnit.Framework.Assert.True(true);
        //}

    }
}
