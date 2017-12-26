using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.Xml;

namespace SuirPlus.Operaciones
{
    internal sealed class TeamFoundationConfigurationManager : ConfigurationSection
    {

        /// <summary>
        /// Constructor privado que previene la instancia de la clase.
        /// </summary>
        private TeamFoundationConfigurationManager()
        {
        }

        /// <summary>
        /// Gets an instance of the TeamFoundationConfigurationmanager class that can be used to retrieve
        /// elements of the TeamFoundationIntegration configuration section of the config file.
        /// </summary>
        /// <returns></returns>
        internal static TeamFoundationConfigurationManager GetConfigurationManager()
        {
            TeamFoundationConfigurationManager config = ConfigurationManager.GetSection("TeamFoundationIntegration/TeamFoundationServer") as TeamFoundationConfigurationManager;
            if (config == null)
                throw (new ConfigurationErrorsException("The TeamFoundationIntegration/TeamFoundationServer configuration section cannot be found."));

            return config;

        }

        /// <summary>
        /// Gets or sets the name of the team foundation server the application is 
        /// integrating with.
        /// </summary>
        [ConfigurationProperty("server", DefaultValue = "Source", IsRequired = true)]
        [StringValidator(InvalidCharacters = "@#$%^&*()[]{};'", MinLength = 1, MaxLength = 100)]
        internal String ServerName
        {
            get
            { return (String)this["server"]; }
            set
            { this["server"] = value; }
        }

        /// <summary>
        /// Gets or sets the user name used to access the team foundation server.
        /// </summary>
        [ConfigurationProperty("userName", DefaultValue = "", IsRequired = true)]
        [StringValidator(InvalidCharacters = "", MinLength = 0, MaxLength = 200)]
        internal String UserName
        {
            get
            { return (String)this["userName"]; }
            set
            { this["userName"] = value; }
        }

        /// <summary>
        /// Gets or sets the password used to access the team foundation server
        /// </summary>
        [ConfigurationProperty("password", DefaultValue = "", IsRequired = true)]
        [StringValidator(InvalidCharacters = "", MinLength = 0, MaxLength = 60)]
        internal String Password
        {
            get
            { return (String)this["password"]; }
            set
            { this["password"] = value; }
        }

        /// <summary>
        /// Gets or sets the domain the the user accessing the team foundation server bellongs to
        /// </summary>
        [ConfigurationProperty("domain", DefaultValue = "", IsRequired = true)]
        [StringValidator(InvalidCharacters = "~!@#$%^&*()[]{}/;'\"|\\", MinLength = 0, MaxLength = 100)]
        internal String Domain
        {
            get
            { return (String)this["domain"]; }
            set
            { this["domain"] = value; }
        }

        /// <summary>
        /// Gets or sets the name of the team foundation project being integrated with
        /// </summary>
        [ConfigurationProperty("project", DefaultValue = "", IsRequired = true)]
        [StringValidator(InvalidCharacters = "", MinLength = 0, MaxLength = 1000)]
        internal String Project
        {
            get
            { return (String)this["project"]; }
            set
            { this["project"] = value; }
        }


    }
}
