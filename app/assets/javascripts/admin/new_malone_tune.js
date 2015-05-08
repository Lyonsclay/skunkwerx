window.onload = function () {
    var name = document.querySelector('#malone_tune_name'),
        form = document.forms['new_malone_tune'];
    form.onsubmit = function () {
        name.value = 'Malone - ' + name.value;
    };
};

