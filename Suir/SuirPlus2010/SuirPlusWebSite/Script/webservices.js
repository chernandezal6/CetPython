

function llamarWS(Url, data, recibirResultado, ajaxFailed) {
    try {
        $.ajax({
            type: "POST",
            url: Url,
            cache: false,
            contentType: "application/json; charset=utf-8",
            data: data,
            dataType: "json",
            success: recibirResultado,
            error: ajaxFailed
        });
    } catch (e) {
        
        alert(e);
    }

    $.fn.serializeObject = function () {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function () {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };


}


