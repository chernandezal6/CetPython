using SuirPlusEF.Repositories;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Models
{
    [Table("SEG_USUARIO_T")]
    public class Usuario
    {
        [Key, Column("ID_USUARIO")]
        public string IdUsuario { get; set; }

        [Column("ID_TIPO_USUARIO")]
        public string TipoUsuario { get; set; }

        [Column("ID_ENTIDAD_RECAUDADORA")]
        public Int32? EntidadRecaudadora { get; set; }

        [Column("ID_NSS")]
        public Int32? NumeroSeguridadSocial { get; set; }

        [Column("ID_REGISTRO_PATRONAL")]
        public Int32? RegistroPatronal { get; set; }

        [Column("PASSWORD")]
        public string Class { get; set; }

        [Column("NOMBRE_USUARIO")]
        public string Nombres { get; set; }

        [Column("APELLIDOS")]
        public string Apellidos { get; set; }

        [Column("CANTIDAD_INTENTOS")]
        public Int32 CantidadIntentos { get; set; }

        [Column("STATUS")]
        public string Estatus { get; set; }

        public bool EstatusBool
        {
            get
            {
                switch (this.Estatus)
                {
                    case "A":
                        return true;
                    case "I":
                        return false;
                    default:
                        break;
                }

                return false;
            }
        }

        [Column("EMAIL")]
        public string Email { get; set; }

        [Column("DEPARTAMENTO")]
        public string DepartamentoUsuario { get; set; }

        [Column("COMENTARIO")]
        public string Comentario { get; set; }

        [Column("ULT_USUARIO_ACT")]
        public string UltimoUsuarioActualizo { get; set; }

        [Column("ULT_FECHA_ACT")]
        public DateTime? UltimaFechaActualizacion { get; set; }

        [Column("CAMBIAR_CLASS")]
        public string CambiarClass { get; set; }

        [Column("ULT_LOGIN")]
        public DateTime? UltimaFechaLogin { get; set; }

        [Column("IP")]
        public string IP { get; set; }

        [Column("ACTUALIZAR_EMAIL")]
        public string ActualizarEmail { get; set; }

        [Column("TOKEN")]
        public string Token { get; set; }

        [Column("FECHA_CREACION_TOKEN")]
        public DateTime? FechaCreacionToken { get; set; }

        [Column("CONFIRMAR_EMAIL")]
        public string ConfirmarEmail { get; set; }

        public  Representante Representante


        {
            get
            {
                UsuarioRepository _UsrRep = new UsuarioRepository();
                Representante rep = new Representante();               
               

                if (this.NumeroSeguridadSocial.HasValue && this.RegistroPatronal.HasValue)

                    rep = _UsrRep.GetRepresentante(this);

                return rep;

            }
        }
    }

}
