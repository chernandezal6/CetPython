$(function () {
    $("#ddInfoEmpleo").hover(
        function () {
            $("#ddMenu1").slideDown("medium");
        },
        function () {
            $("#ddMenu1").slideUp("medium");
        }
    );
    $("#ddSFS").hover(
        function () {
            $("#ddMenu2").slideDown("medium");
        },
        function () {
            $("#ddMenu2").slideUp("medium");
        }
    );
    $("#ddSPension").hover(
        function () {
            $("#ddMenu3").slideDown("medium");
        },
        function () {
            $("#ddMenu3").slideUp("medium");
        }
    );
    $("#ddPerfilUsuario").hover(
        function () {
            $("#ddMenu4").slideDown("medium");
        },
        function () {
            $("#ddMenu4").slideUp("medium");
        }
    );    
});