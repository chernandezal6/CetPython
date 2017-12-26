using SuirPlusEF.Models;
using System;
using SuirPlusEF.Framework;
using System.Linq;
using System.Collections.Generic;

namespace SuirPlusEF.Repositories
{

    public class CaptchaRepository : Framework.BaseObject<Models.Captcha>, Framework.IBaseRepository<Models.Captcha>
    {
        public CaptchaRepository() : base() { }
        public CaptchaRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        CiudadanoRepository ciudadano = new CiudadanoRepository();


        Captcha IBaseRepository<Captcha>.GetById(int id)
        {
            throw new NotImplementedException();
        }

        public List<CaptchaRespuesta> PreguntaCaptcha(string url) {

            var infoCaptcha = from a in db.Captcha
                              join b in db.DetalleCaptcha
                              on a.ID equals b.MaestroId
                              where a.ID == 1
                              select new CaptchaRespuesta
                              {
                                  Pregunta = b.Pregunta,
                                  ObjetoHTML = b.TipoInput,
                                  Origen = b.OrigenRespuesta,
                                  CampoRepuesta = b.CampoRespuesta 
                              };
            return infoCaptcha.ToList();
        }
        

 }

    public class CaptchaRespuesta{
        public string Pregunta { get; set;}
        public string ObjetoHTML { get; set; }
        public string Origen { get; set; }
        public string CampoRepuesta { get; set; }
    }
}
