using System;
using System.Linq;
using System.Text;
using SuirPlusEF.Models;
using System.Security.Cryptography;

namespace SuirPlusEF.Repositories
{

    public class UsuarioRepository : Framework.BaseObject<Models.Usuario>, Framework.IBaseRepository<Models.Usuario>

    {

        public UsuarioRepository() : base() { }
        public UsuarioRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Usuario GetById(int id)
        {
            return db.Usuarios.FirstOrDefault();
        }

        public Usuario GetByUsername(string UserName)
        {
            return db.Usuarios.FirstOrDefault(x => x.IdUsuario == UserName);
        }

        public Usuario GetByUsernameEmail(string UserName)
        {
            var usuario = new Usuario();
            usuario = db.Usuarios.FirstOrDefault(x => x.IdUsuario == UserName);
            return usuario;
        }

        public Representante GetRepresentante(Usuario usuario)
        {

            var Representante = new Representante();

            if (usuario.NumeroSeguridadSocial.HasValue && usuario.RegistroPatronal.HasValue)

            {
                Representante = db.Representantes.FirstOrDefault(x => x.IdNSS == usuario.NumeroSeguridadSocial.Value && x.IdRegistroPatronal == usuario.RegistroPatronal.Value);
            }

            return Representante;
        }

        public static string ActualizarUsuario(string usuario, string status, string link)
        {
            try
            {
                var estatus = SuirPlus.Seguridad.Usuario.ActualizarUsuario(usuario, status, link);
                return estatus;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public string HashPassword(string Password)
        {
            string ResultadoHash = string.Empty;
            using (MD5 md5Hash = MD5.Create())
            {
                ResultadoHash = ConvertirMd5(md5Hash, Password.ToLower());
            }
            return ResultadoHash;
        }

        public bool Login(String UserName, String Clave, String ip, String TipoUsuario, String servidor, String Browser, ref bool CambiarPassword, ref string UrlRetorno, ref bool Activo, ref string Status, ref int Intentos)
        {

            /// Variables del Metodo
            bool Resultado = false;

            /// Valores por default;       
            Activo = true;
            Status = "A";

            /// Autenticar usuario
            UserName = UserName.ToUpper();
            Usuario user = new Usuario();
            user = GetByUsername(UserName);

            if (user == null)
            {
                Resultado = false;

            }
            else
            {
                // Estatus del Usuario
                Activo = user.EstatusBool;

                // Encriptar la clave con MD5
                Clave = HashPassword(Clave);


                //Confirmar que el usuario este activo y ese sea su Class
                if (user.IdUsuario == UserName && user.Class == Clave && user.Estatus == "A")
                {

                    Resultado = true;

                    // En el caso de que sea representante, tambien validar que el presentante este activo
                    if (user.TipoUsuario == "2")
                    {

                        if (user.Representante.Status != "A")
                        {
                            Activo = false;
                            Resultado = false;
                        }
                    }


                    /// Confirmar si tiene que cambiar la clave, dependiendo si es Representante o Normal
                    if (user.CambiarClass == "S")
                    {
                        CambiarPassword = true;

                        /// Confirmar donde debe retornarlo, dependiendo si es un representante o un usuario normal
                        switch (user.TipoUsuario)
                        {

                            case "1":
                                UrlRetorno = "~/sys/segCambioClass.aspx";
                                break;
                            case "2":

                                EmpresaRepository _RepEmp = new EmpresaRepository(this.db);
                                CiudadanoRepository _RepCiu = new CiudadanoRepository(this.db);

                                string rnc = _RepEmp.GetByRegistroPatronal(user.RegistroPatronal).RncCedula;
                                string cedula = _RepCiu.GetByNSS(user.NumeroSeguridadSocial).NroDocumento;

                                UrlRetorno = "~/sys/segCambioClass.aspx?log=r&RNC=" + rnc + "&Cedula=" + cedula;

                                break;
                            default:
                                break;
                        }

                    }
                    else
                    {
                        CambiarPassword = false;
                    }
                }
                else
                {
                    if (user.Estatus == "I")
                    {
                        Activo = false;
                        Status = "I";
                        Resultado = false;
                    }

                    if (user.Estatus == "B")
                    {
                        Activo = false;
                        Status = "B";
                        Resultado = false;
                    }

                    Intentos = user.CantidadIntentos;
                    Intentos += 1;

                    if (Intentos <= 3)
                    {
                        user.CantidadIntentos = Intentos;
                        db.SaveChanges();
                    }

                    if (Intentos > 2)
                    {
                        ActualizarUsuario(user.IdUsuario, "B", null);
                        Status = "B";
                        Resultado = false;

                    }


                    Resultado = false;

                    Log log = new Log();
                    LogRepository _RepLog = new LogRepository(this.db);

                    var ResultadoIP = ip;
                    if (ResultadoIP.Length > 16)
                    {
                        ip = "0";
                    }

                    log.IdTipo = Convert.ToInt32(EnumLog.Login);
                    log.RegistroPatronal = user.RegistroPatronal;
                    log.UsuarioRepresentante = UserName;
                    log.FechaRegistro = DateTime.Now;
                    log.IpPC = ip;
                    log.UsuarioNormal = UserName;
                    log.Comentario = $"Resultado: {Resultado} - Tipo: {user.TipoUsuario} - CambiarPassword: {CambiarPassword} - Browser: {Browser} - Error IP: {ResultadoIP}";
                    log.Servidor = servidor;

                    _RepLog.Add(log);
                }

                if (Resultado == true)
                {
                    user.CantidadIntentos = 0;
                    db.SaveChanges();
                }


            }

            return Resultado;
        }

        public static string ConvertirMd5(MD5 md5Hash, string input)
        {
            byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));
            StringBuilder sBuilder = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }
            return sBuilder.ToString();
        }

    }
}
